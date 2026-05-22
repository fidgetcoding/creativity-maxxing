#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# creativity-maxxing — Copywriting module
# Installs the /copywriting skill — Nate's anti-AI-slop, master-trained
# copywriting filter (Bernbach, Hegarty, Abbott, Trott, Wieden, Sugarman,
# Sackheim, Schwartz, Bencivenga, Gossage, Krone, McElligott).
#
# Downloads SKILL.md + 19 reference files from this repo's `copywriting-skill/`
# directory on main, with a local fallback when running from a clone.
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
    echo "  Skill installed:"
    echo "    /copywriting — master-trained anti-AI-slop copy filter"
    echo "                   (20 files: 1 SKILL.md + 19 references)"
    echo ""
    echo "  Auto-activates on: headline, hero, body, CTA, manifesto,"
    echo "                     proposal copy, landing pages, ad copy,"
    echo "                     brand voice, naming, \"rewrite this paragraph\""
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
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    verify_prerequisites
    install_copywriting_skill
    run_self_test
    print_summary
}

main "$@"
