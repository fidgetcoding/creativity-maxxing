#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# creativity-maxxing — Claude-Watch module
# Installs the /watch skill — drop any video URL (single video, full
# YouTube channel, or playlist) and Claude returns timestamped, frame-aware
# study notes. Runs key-free against the local whisper.cpp + ffmpeg + yt-dlp
# stack that the media module already set up; cloud Whisper (Groq / OpenAI)
# stays available as a fallback.
#
# Downloads SKILL.md + scripts/ + commands/ + hooks/ from this repo's
# `watch-skill/` directory on main, with a local fallback when running
# from a clone.
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
fail()    { echo -e "${RED}[FAIL]${NC} $1"; exit 1; }
soft_fail() { echo -e "${RED}[FAIL]${NC} $1 (non-critical, continuing...)"; ERRORS=$((ERRORS + 1)); }

# -----------------------------------------------------------------------------
# Prerequisites — Claude Code + skills dir must exist (cli-maxxing prereq).
# The skill's own setup.py preflight handles ffmpeg / yt-dlp / whisper-cli at
# runtime — they ship from creativity-maxxing's media module, not here.
# -----------------------------------------------------------------------------
verify_prerequisites() {
    if ! command -v claude &>/dev/null; then
        fail "Claude Code not found. Install cli-maxxing first."
    fi
    [ -d "$HOME/.claude/skills" ] || fail "\$HOME/.claude/skills missing — run cli-maxxing first."
    success "Prerequisites verified"
}

# -----------------------------------------------------------------------------
# File list — keep in sync with watch-skill/ contents.
# Paths are relative to watch-skill/.
# -----------------------------------------------------------------------------
CW_FILES=(
    "SKILL.md"
    "scripts/__init__.py"
    "scripts/channel.py"
    "scripts/download.py"
    "scripts/frames.py"
    "scripts/library.py"
    "scripts/resolve.py"
    "scripts/scenes.py"
    "scripts/setup.py"
    "scripts/transcribe.py"
    "scripts/watch.py"
    "scripts/whisper.py"
    "commands/watch.md"
    "hooks/hooks.json"
    "hooks/scripts/session_start.sh"
)

# -----------------------------------------------------------------------------
# Install the /watch skill.
# Tries curl from main first; falls back to a local copy if reachable.
# -----------------------------------------------------------------------------
install_watch_skill() {
    local SKILL_DIR="$HOME/.claude/skills/watch"
    local BASE_URL="https://raw.githubusercontent.com/lorecraft-io/creativity-maxxing/main/watch-skill"

    mkdir -p "$SKILL_DIR/scripts" "$SKILL_DIR/commands" "$SKILL_DIR/hooks/scripts"

    # Resolve local source dir from this script's path (works for clone + curl|bash)
    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
    local LOCAL_SRC="$(dirname "$SCRIPT_DIR")/watch-skill"

    download_one() {
        local rel="$1"
        local dest="$2"
        local tmp="$dest.tmp"
        mkdir -p "$(dirname "$dest")"
        if curl -fsSL "$BASE_URL/$rel" -o "$tmp" 2>/dev/null && [ -s "$tmp" ]; then
            mv "$tmp" "$dest"
            return 0
        fi
        rm -f "$tmp"
        if [ -f "$LOCAL_SRC/$rel" ]; then
            cp "$LOCAL_SRC/$rel" "$dest"
            return 0
        fi
        return 1
    }

    info "Installing /watch skill..."

    local ok=1
    for rel in "${CW_FILES[@]}"; do
        download_one "$rel" "$SKILL_DIR/$rel" || ok=0
    done

    # session_start hook needs to be executable
    chmod +x "$SKILL_DIR/hooks/scripts/session_start.sh" 2>/dev/null || true

    if [ "$ok" -eq 1 ]; then
        success "/watch skill installed at $SKILL_DIR"
    else
        soft_fail "Could not install /watch skill — download and local fallback both failed"
    fi
}

# -----------------------------------------------------------------------------
# Self-test — confirm SKILL.md + critical scripts landed.
# We do NOT execute setup.py here: the user's media-module deps + whisper
# model file may not be fully wired yet when this runs during a fresh
# `bash <(curl ...)` install, and setup.py is designed to surface those
# states at first /watch invocation via the SessionStart hook.
# -----------------------------------------------------------------------------
run_self_test() {
    local SKILL_DIR="$HOME/.claude/skills/watch"
    local pass=0 fail=0

    if [ -f "$SKILL_DIR/SKILL.md" ]; then
        success "TEST: watch SKILL.md installed"
        pass=$((pass + 1))
    else
        soft_fail "TEST: watch SKILL.md missing"
        fail=$((fail + 1))
    fi

    if [ -f "$SKILL_DIR/scripts/watch.py" ] && [ -f "$SKILL_DIR/scripts/setup.py" ]; then
        success "TEST: watch scripts installed (watch.py + setup.py present)"
        pass=$((pass + 1))
    else
        soft_fail "TEST: watch scripts missing"
        fail=$((fail + 1))
    fi

    if [ -f "$SKILL_DIR/scripts/channel.py" ]; then
        success "TEST: channel/playlist support present (channel.py)"
        pass=$((pass + 1))
    else
        soft_fail "TEST: channel.py missing — playlist/channel mode unavailable"
        fail=$((fail + 1))
    fi

    if [ -x "$SKILL_DIR/hooks/scripts/session_start.sh" ]; then
        success "TEST: SessionStart hook installed + executable"
        pass=$((pass + 1))
    else
        soft_fail "TEST: SessionStart hook missing or not executable"
        fail=$((fail + 1))
    fi

    if [ -f "$SKILL_DIR/commands/watch.md" ]; then
        success "TEST: /watch slash-command entry point installed"
        pass=$((pass + 1))
    else
        soft_fail "TEST: commands/watch.md missing"
        fail=$((fail + 1))
    fi

    echo ""
    if [ "$fail" -eq 0 ]; then
        success "Claude-watch module self-test: $pass/$pass passed"
    else
        warn "Claude-watch module self-test: $pass passed, $fail failed"
    fi
}

print_summary() {
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  Claude-watch module install complete.${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  Skill installed:"
    echo "    /watch — frame-aware video → structured study notes"
    echo "                    (15 files: SKILL.md + 11 scripts + hook + command + plugin glue)"
    echo ""
    echo "  Use it: paste any URL — single video, channel, or playlist:"
    echo "    /watch https://youtu.be/<id>"
    echo "    /watch https://www.youtube.com/@<channel>/videos --limit 10"
    echo "    /watch ~/path/to/local.mp4"
    echo ""
    echo "  Transcript backend (auto-selected at runtime):"
    echo "    1. YouTube/IG/TikTok native captions (free)"
    echo "    2. Local whisper.cpp — uses media-module's ~/.whisper/ggml-base.en.bin"
    echo "    3. Groq / OpenAI Whisper API — only if you set a key in"
    echo "       ~/.config/watch/.env"
    echo ""
    if [ "$ERRORS" -gt 0 ]; then
        echo -e "${YELLOW}  $ERRORS non-critical error(s) above — install is partial.${NC}"
        echo ""
    fi
}

main() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Claude-Watch Module${NC}"
    echo -e "${BLUE}  /watch — frame-aware video → structured study notes${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    verify_prerequisites
    install_watch_skill
    run_self_test
    print_summary
}

main "$@"
