#!/usr/bin/env bash
# tests/test_copywriting_install.sh
# Static + behavioral coverage for copywriting/install.sh.
#
# The copywriting module installs a single skill at ~/.claude/skills/copywriting
# composed of SKILL.md + 19 reference files. The installer pulls each file from
# raw.githubusercontent.com/lorecraft-io/creativity-maxxing/main with a local
# fallback. This test asserts the static contract + runs a behavioral probe
# that forces the local fallback path so it works offline.

set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$HERE/.." && pwd)"
# shellcheck source=./lib/assertions.sh
source "$HERE/lib/assertions.sh"

assert_reset "test_copywriting_install"

COPY_SH="$REPO_ROOT/copywriting/install.sh"
if [[ ! -f "$COPY_SH" ]]; then
  printf "%sSKIP%s test_copywriting_install (copywriting/install.sh not present)\n" \
    "${_C_YELLOW:-}" "${_C_RESET:-}"
  exit 0
fi

# ---------------------------------------------------------------------------
# Static contract.
# ---------------------------------------------------------------------------
assert_contains "$COPY_SH" 're:^set -euo pipefail' \
  "copywriting/install.sh uses strict mode"
assert_contains "$COPY_SH" "verify_prerequisites" \
  "verify_prerequisites function defined"
assert_contains "$COPY_SH" "install_copywriting_skill" \
  "install_copywriting_skill function defined"
assert_contains "$COPY_SH" "run_self_test" \
  "run_self_test function defined"
assert_contains "$COPY_SH" "lorecraft-io/creativity-maxxing/main/copywriting-skill" \
  "BASE_URL points at lorecraft-io/creativity-maxxing main copywriting-skill"
assert_contains "$COPY_SH" 're:\$HOME/\.claude/skills/copywriting' \
  "skill installs to \$HOME/.claude/skills/copywriting"

# Every reference file the master vault ships must be in COPY_REF_FILES.
for ref in body-copy.md compression.md cta-patterns.md \
           frameworks-attention.md frameworks-awareness.md frameworks-sales.md \
           frameworks.md gates.md headlines.md humanization.md \
           proofreading.md proposal-patterns.md psych-triggers.md \
           voice-library.md voices-challenger.md voices-dtc.md \
           voices-honesty.md voices-punch.md voices-restraint.md; do
  assert_contains "$COPY_SH" "\"$ref\"" \
    "COPY_REF_FILES includes $ref"
done

# Local fallback path is wired (handles offline / pre-publish state).
assert_contains "$COPY_SH" 're:LOCAL_SRC=' \
  "LOCAL_SRC computed from script dir (offline-safe local fallback)"
assert_contains "$COPY_SH" 're:cp .*LOCAL_SRC' \
  "local-fallback copy invoked when curl fails"

# Self-test asserts SKILL.md + a sentinel reference.
assert_contains "$COPY_SH" "re:TEST: copywriting SKILL.md" \
  "self-test asserts copywriting SKILL.md landed"
assert_contains "$COPY_SH" "voice-library.md" \
  "self-test asserts voice-library.md (sentinel reference)"

# main() wires every step.
for fn in verify_prerequisites install_copywriting_skill run_self_test print_summary; do
  assert_contains "$COPY_SH" "re:^[[:space:]]+${fn}(\$|[[:space:]])" \
    "main() calls $fn"
done

# Vendored skill source must be present alongside the installer.
VENDOR_DIR="$REPO_ROOT/copywriting-skill"
assert_file "$VENDOR_DIR/SKILL.md" "vendored SKILL.md at copywriting-skill/"
for ref in body-copy.md compression.md cta-patterns.md \
           frameworks-attention.md frameworks-awareness.md frameworks-sales.md \
           frameworks.md gates.md headlines.md humanization.md \
           proofreading.md proposal-patterns.md psych-triggers.md \
           voice-library.md voices-challenger.md voices-dtc.md \
           voices-honesty.md voices-punch.md voices-restraint.md; do
  assert_file "$VENDOR_DIR/references/$ref" \
    "vendored reference file: $ref"
done

# ---------------------------------------------------------------------------
# Behavioral probe: run the installer against a sandbox HOME with curl
# stubbed to always-fail so the local fallback path is exercised. Verifies
# 1 SKILL.md + 19 references land + self-test passes.
# ---------------------------------------------------------------------------
TMPROOT="$(mktemp -d -t cm-copy-XXXXXX)"
cleanup() {
  if [[ -n "${TMPROOT:-}" && ( "$TMPROOT" == /tmp/* || "$TMPROOT" == /var/folders/* ) ]]; then
    rm -rf "$TMPROOT"
  fi
}
trap cleanup EXIT

FAKE_HOME="$TMPROOT/home"
mkdir -p "$FAKE_HOME/.claude/skills"

MOCK_BIN="$TMPROOT/mock-bin"
mkdir -p "$MOCK_BIN"
cat > "$MOCK_BIN/claude" <<'SHIM'
#!/usr/bin/env bash
if [[ "${1:-}" == "--version" ]]; then
  echo "2.1.0 (Claude Code)"
fi
exit 0
SHIM
chmod +x "$MOCK_BIN/claude"

# Stub curl with a deterministic non-zero exit so the installer falls back to
# the vendored local source. Pre-pend in PATH ahead of the real curl.
cat > "$MOCK_BIN/curl" <<'SHIM'
#!/usr/bin/env bash
exit 22
SHIM
chmod +x "$MOCK_BIN/curl"

set +e
INSTALL_OUT="$(PATH="$MOCK_BIN:$PATH" HOME="$FAKE_HOME" \
  bash "$COPY_SH" 2>&1)"
INSTALL_RC=$?
set -e 2>/dev/null || true

assert_eq "$INSTALL_RC" "0" "copywriting/install.sh exits 0 with curl forced to fail (local fallback)"

# Count landed files.
SKILL_DIR="$FAKE_HOME/.claude/skills/copywriting"
if [[ -f "$SKILL_DIR/SKILL.md" ]]; then
  _pass "SKILL.md landed at \$HOME/.claude/skills/copywriting/"
else
  _fail "SKILL.md missing — local fallback did not fire"
fi

REF_COUNT="$(find "$SKILL_DIR/references" -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
assert_eq "$REF_COUNT" "19" "all 19 reference files landed via local fallback"

# Self-test output sanity.
if echo "$INSTALL_OUT" | grep -q 'self-test: 2/2 passed'; then
  _pass "self-test reports 2/2 passed"
else
  _fail "self-test did not report 2/2 passed"
  printf '  saw: %s\n' "${INSTALL_OUT:0:600}" 1>&2
fi

# Idempotency: re-run with the SAME sandbox HOME — should still exit 0 and
# leave the same file count (overwrites are fine, count must not grow).
set +e
# shellcheck disable=SC2034 # _RERUN_OUT captured for debugging-on-fail; intentional
_RERUN_OUT="$(PATH="$MOCK_BIN:$PATH" HOME="$FAKE_HOME" \
  bash "$COPY_SH" 2>&1)"
RERUN_RC=$?
set -e 2>/dev/null || true

assert_eq "$RERUN_RC" "0" "copywriting/install.sh re-runs cleanly (idempotent under fallback)"
REF_COUNT_2="$(find "$SKILL_DIR/references" -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
assert_eq "$REF_COUNT_2" "19" "reference count unchanged after re-run"

# ---------------------------------------------------------------------------
# Behavioral probe 2: prereq check fails without `claude` on PATH.
# ---------------------------------------------------------------------------
PATH_NO_CLAUDE="$TMPROOT/path-no-claude"
mkdir -p "$PATH_NO_CLAUDE"
for t in bash grep find mktemp git curl awk sed tr cp mv rm mkdir chmod touch dirname basename uname head tail; do
  if command -v "$t" >/dev/null 2>&1; then
    ln -s "$(command -v "$t")" "$PATH_NO_CLAUDE/$t" 2>/dev/null || true
  fi
done

set +e
NOCLAUDE_OUT="$(PATH="$PATH_NO_CLAUDE" HOME="$FAKE_HOME" \
  bash "$COPY_SH" 2>&1)"
NOCLAUDE_RC=$?
set -e 2>/dev/null || true

if [[ "$NOCLAUDE_RC" -ne 0 ]]; then
  _pass "copywriting/install.sh exits non-zero when claude is absent"
else
  _fail "copywriting/install.sh exited 0 despite claude missing"
fi
if echo "$NOCLAUDE_OUT" | grep -qi 'cli-maxxing\|Claude Code not found'; then
  _pass "missing-claude message points at cli-maxxing"
else
  _fail "missing-claude message did not point at cli-maxxing"
  printf '  saw: %s\n' "${NOCLAUDE_OUT:0:300}" 1>&2
fi

assert_report
