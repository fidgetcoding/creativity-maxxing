#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# creativity-maxxing — Copywriting module
# Installs two skills:
#
#   /copywriting — the operator's anti-AI-slop, master-trained copywriting
#                  filter (Bernbach, Hegarty, Abbott, Trott, Wieden, Sugarman,
#                  Sackheim, Schwartz, Bencivenga, Gossage, Krone, McElligott).
#                  SKILL.md + 19 reference files downloaded from this repo's
#                  `copywriting-skill/` directory on main, with a local
#                  fallback when running from a clone.
#
#   /humanizer   — third-party AI-tell scrubber (blader/humanizer), installed
#                  from a pinned commit. 33 patterns lifted from Wikipedia's
#                  "Signs of AI writing". Runs AFTER /copywriting as a
#                  finishing pass; the two conflict if run together.
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
# Prerequisites — Claude Code + skills dir must exist (cli-maxxing prereq)
# -----------------------------------------------------------------------------
verify_prerequisites() {
    if ! command -v claude &>/dev/null; then
        fail "Claude Code not found. Install cli-maxxing first."
    fi
    [ -d "$HOME/.claude/skills" ] || fail "\$HOME/.claude/skills missing — run cli-maxxing first."
    success "Prerequisites verified"
}

# -----------------------------------------------------------------------------
# File list — keep in sync with copywriting-skill/ contents
# -----------------------------------------------------------------------------
COPY_REF_FILES=(
    "body-copy.md"
    "compression.md"
    "cta-patterns.md"
    "frameworks-attention.md"
    "frameworks-awareness.md"
    "frameworks-sales.md"
    "frameworks.md"
    "gates.md"
    "headlines.md"
    "humanization.md"
    "proofreading.md"
    "proposal-patterns.md"
    "psych-triggers.md"
    "voice-library.md"
    "voices-challenger.md"
    "voices-dtc.md"
    "voices-honesty.md"
    "voices-punch.md"
    "voices-restraint.md"
)

# -----------------------------------------------------------------------------
# Install the /copywriting skill
# Tries curl from main first; falls back to a local copy if reachable.
# -----------------------------------------------------------------------------
install_copywriting_skill() {
    local SKILL_DIR="$HOME/.claude/skills/copywriting"
    local SKILL_REF_DIR="$SKILL_DIR/references"
    local BASE_URL="https://raw.githubusercontent.com/fidgetcoding/creativity-maxxing/main/copywriting-skill"

    mkdir -p "$SKILL_REF_DIR"

    # Resolve local source dir from this script's path (works for clone + curl|bash)
    local SCRIPT_DIR
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
    local LOCAL_SRC
    LOCAL_SRC="$(dirname "$SCRIPT_DIR")/copywriting-skill"

    download_one() {
        local rel="$1"
        local dest="$2"
        local tmp="$dest.tmp"
        if curl -fsSL --proto '=https' --proto-redir '=https' "$BASE_URL/$rel" -o "$tmp" 2>/dev/null && [ -s "$tmp" ]; then
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

    info "Installing /copywriting skill..."

    local ok=1
    download_one "SKILL.md" "$SKILL_DIR/SKILL.md" || ok=0
    for ref in "${COPY_REF_FILES[@]}"; do
        download_one "references/$ref" "$SKILL_REF_DIR/$ref" || ok=0
    done

    if [ "$ok" -eq 1 ]; then
        success "/copywriting skill installed at $SKILL_DIR"
    else
        soft_fail "Could not install /copywriting skill — download and local fallback both failed"
    fi
}

# -----------------------------------------------------------------------------
# Install the /humanizer skill from a pinned commit (rug-pull defense, same
# posture as the taste-skill / remotion packs in design/ + media/).
#
# blader/humanizer keeps SKILL.md at the repo root rather than under skills/,
# so the generic install_skill_pack_pinned discovery in design/install.sh would
# copy the whole checkout including .git. This copies the payload and drops the
# VCS metadata instead. Bump HUMANIZER_COMMIT to update.
# -----------------------------------------------------------------------------
install_humanizer_skill() {
    local SKILL_DIR="$HOME/.claude/skills/humanizer"
    local HUMANIZER_URL="https://github.com/blader/humanizer"
    local HUMANIZER_COMMIT="523374dee72d67c7b2b5f858ea0094ffda49c3ac"

    if [ -f "$SKILL_DIR/SKILL.md" ]; then
        success "/humanizer skill already installed"
        return 0
    fi

    if ! command -v git &>/dev/null; then
        soft_fail "/humanizer needs git — install git and re-run"
        return 1
    fi

    info "Installing /humanizer skill (blader/humanizer @ ${HUMANIZER_COMMIT:0:7})..."

    local tmp
    tmp="$(mktemp -d)"

    if ! git clone --quiet "$HUMANIZER_URL" "$tmp" 2>/dev/null; then
        rm -rf "$tmp"
        soft_fail "/humanizer: clone failed ($HUMANIZER_URL)"
        return 1
    fi

    if ! git -C "$tmp" checkout --quiet "$HUMANIZER_COMMIT" 2>/dev/null; then
        rm -rf "$tmp"
        soft_fail "/humanizer: pinned commit $HUMANIZER_COMMIT not found upstream"
        return 1
    fi

    if [ ! -f "$tmp/SKILL.md" ]; then
        rm -rf "$tmp"
        soft_fail "/humanizer: SKILL.md not found at the pinned commit"
        return 1
    fi

    rm -rf "$tmp/.git" "$tmp/.github"
    mkdir -p "$SKILL_DIR"
    cp -R "$tmp/." "$SKILL_DIR/"
    rm -rf "$tmp"

    success "/humanizer skill installed at $SKILL_DIR (pinned @ ${HUMANIZER_COMMIT:0:7})"
}

# -----------------------------------------------------------------------------
# Self-test — confirm SKILL.md + a sentinel reference landed
# -----------------------------------------------------------------------------
run_self_test() {
    local SKILL_DIR="$HOME/.claude/skills/copywriting"
    local pass=0 fail=0

    if [ -f "$SKILL_DIR/SKILL.md" ]; then
        success "TEST: copywriting SKILL.md installed"
        pass=$((pass + 1))
    else
        soft_fail "TEST: copywriting SKILL.md missing"
        fail=$((fail + 1))
    fi

    if [ -f "$SKILL_DIR/references/voice-library.md" ] && [ -f "$SKILL_DIR/references/gates.md" ]; then
        success "TEST: copywriting references installed (voice-library.md + gates.md present)"
        pass=$((pass + 1))
    else
        soft_fail "TEST: copywriting references missing"
        fail=$((fail + 1))
    fi

    if [ -f "$HOME/.claude/skills/humanizer/SKILL.md" ]; then
        success "TEST: humanizer SKILL.md installed"
        pass=$((pass + 1))
    else
        soft_fail "TEST: humanizer SKILL.md missing"
        fail=$((fail + 1))
    fi

    if [ ! -d "$HOME/.claude/skills/humanizer/.git" ]; then
        success "TEST: humanizer install carries no .git metadata"
        pass=$((pass + 1))
    else
        soft_fail "TEST: humanizer install left a .git directory behind"
        fail=$((fail + 1))
    fi

    echo ""
    if [ "$fail" -eq 0 ]; then
        success "Copywriting module self-test: $pass/$pass passed"
    else
        warn "Copywriting module self-test: $pass passed, $fail failed"
    fi
}

print_summary() {
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  Copywriting module install complete.${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  Skills installed:"
    echo "    /copywriting — master-trained anti-AI-slop copy filter"
    echo "                   (20 files: 1 SKILL.md + 19 references)"
    echo "    /humanizer   — AI-tell scrubber, 33 patterns from Wikipedia's"
    echo "                   \"Signs of AI writing\" (blader/humanizer, pinned)"
    echo ""
    echo "  /copywriting auto-activates on: headline, hero, body, CTA,"
    echo "                     manifesto, proposal copy, landing pages,"
    echo "                     ad copy, brand voice, naming,"
    echo "                     \"rewrite this paragraph\""
    echo ""
    echo "  /humanizer runs AFTER /copywriting as a finishing pass."
    echo "  Do not run both on the same draft at once — they fight."
    echo ""
    if [ "$ERRORS" -gt 0 ]; then
        echo -e "${YELLOW}  $ERRORS non-critical error(s) above — copy is partial.${NC}"
        echo ""
    fi
}

main() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Copywriting Module${NC}"
    echo -e "${BLUE}  /copywriting — anti-AI-slop master-trained copy filter${NC}"
    echo -e "${BLUE}  /humanizer   — AI-tell scrubber (finishing pass)${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    verify_prerequisites
    install_copywriting_skill
    install_humanizer_skill || true
    run_self_test
    print_summary
}

main "$@"
