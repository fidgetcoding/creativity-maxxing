#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# creativity-maxxing — Root installer
# Installs the design + media + copywriting + watch modules.
#
# Design module:       UI/UX Pro Max skill · 8× Taste Skills · 21st.dev Magic MCP
#                      Canva MCP · Figma MCP · Excalidraw MCP · Playwright MCP
#                      Gamma MCP (opt-in via --with-gamma)
# Media module:        Remotion skill · 15× Higgsfield/Seedance skills
#                      YouTube Transcript MCP · yt-dlp (CLI + MCP) · whisper-cpp
#                      whisper-mcp · FFmpeg
# Copywriting module:  /copywriting skill — master-trained anti-AI-slop filter
#                      (Bernbach, Hegarty, Abbott, Trott, Wieden, Sugarman,
#                      Sackheim, Schwartz, Bencivenga, Gossage, Krone, McElligott)
# Claude-Watch module: /watch skill — drop any video/channel/playlist
#                      URL and get back timestamped, frame-aware study notes.
#                      Uses the media-module's local whisper.cpp + yt-dlp stack
#                      so it runs key-free + offline.
# =============================================================================

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

MARKER="$HOME/.claude/.creativity-maxxing-installed"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  creativity-maxxing — Install${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  Design module:"
echo "    UI/UX Pro Max skill · 8× Taste Skills · 21st.dev Magic MCP"
echo "    Canva MCP · Figma MCP · Excalidraw MCP · Playwright MCP"
echo "    Gamma MCP (opt-in via --with-gamma; needs API key)"
echo ""
echo "  Media module:"
echo "    Remotion skill · 15× Higgsfield/Seedance skills"
echo "    YouTube Transcript MCP · yt-dlp (CLI + MCP)"
echo "    whisper-cpp · whisper-mcp · FFmpeg"
echo ""
echo "  Copywriting module:"
echo "    /copywriting skill — anti-AI-slop master-trained copy filter"
echo ""
echo "  Claude-Watch module:"
echo "    /watch skill — frame-aware video → structured study notes"
echo "                          (single video, full channel, or playlist)"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Opt-in flags (--with-gamma, any future --with-*) must still work on an
# already-installed machine. The module installers are idempotent, so when an
# opt-in flag is passed we skip the marker early-exit and forward the flags
# instead of telling the user the documented re-run path is a no-op.
OPT_IN_RERUN=0
for _arg in "$@"; do
    case "$_arg" in
        --with-*) OPT_IN_RERUN=1 ;;
    esac
done

if [ -f "$MARKER" ]; then
    if [ "$OPT_IN_RERUN" = "1" ]; then
        echo -e "${YELLOW}  Already installed — opt-in flag detected. Re-running the module${NC}"
        echo -e "${YELLOW}  installers (idempotent) to apply: $*${NC}"
        echo ""
    else
        echo -e "${YELLOW}  Already installed. Delete the marker to force a full reinstall:${NC}"
        echo -e "${YELLOW}    rm ~/.claude/.creativity-maxxing-installed${NC}"
        echo -e "${YELLOW}  Then re-run this script.${NC}"
        echo -e "${YELLOW}  (Opt-in flags like --with-gamma re-run automatically — no marker${NC}"
        echo -e "${YELLOW}  delete needed.)${NC}"
        echo ""
        exit 0
    fi
fi

command -v claude >/dev/null || { echo "Claude Code not found — run cli-maxxing first"; exit 1; }
[ -d "$HOME/.claude/skills" ] || { echo "\$HOME/.claude/skills missing — run cli-maxxing first"; exit 1; }

# Resolve repo root — works from local clone AND bash <(curl ...)
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ ! -f "$HERE/design/install.sh" ]; then
    _TMPDIR="$(mktemp -d)"
    trap 'rm -rf "$_TMPDIR"' EXIT
    git clone --quiet --depth 1 https://github.com/fidgetcoding/creativity-maxxing.git "$_TMPDIR"
    HERE="$_TMPDIR"
fi

bash "$HERE/design/install.sh" "$@"
bash "$HERE/media/install.sh" "$@"
bash "$HERE/copywriting/install.sh" "$@"
bash "$HERE/watch/install.sh" "$@"
touch "$MARKER"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  creativity-maxxing install complete.${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}  Manual follow-ups required for 5 tools:${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  21st.dev Magic — free API key required:"
echo "    1. Go to https://21st.dev/mcp  (the MCP dashboard, not the homepage)"
echo "    2. Create a free account and copy your API key"
echo "    3. Run the setup one-liner shown on the MCP page"
echo ""
echo "  Canva, Figma, Excalidraw — OAuth on first use:"
echo "    No setup needed now. The first time you ask Claude to use"
echo "    one of these tools, a browser window opens for sign-in."
echo "    Approve access once — subsequent calls are seamless."
echo ""
echo "  Gamma — opt-in (requires API key):"
echo "    Default install does NOT register Gamma (it fails to connect"
echo "    without a key). To enable, grab a key from https://gamma.app/api"
echo "    and re-run the installer with --with-gamma."
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
