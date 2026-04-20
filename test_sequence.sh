#!/usr/bin/env bash
#
# test_sequence.sh — End-to-end integration test for PES-VCS
#
# Run from the repository root after compiling:
#   make
#   ./test_sequence.sh

set -euo pipefail

PES="$(cd "$(dirname "$0")" && pwd)/pes"
TEST_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

cd "$TEST_DIR"

echo "=== PES-VCS Integration Test ==="
echo ""

# ── Init ───────────────────────────────────────────────────────────────────
echo "--- Repository Initialization ---"
"$PES" init
[ -d .pes/objects ] && echo "PASS: .pes/objects exists" || echo "FAIL: .pes/objects missing"
[ -d .pes/refs/heads ] && echo "PASS: .pes/refs/heads exists" || echo "FAIL: .pes/refs/heads missing"
[ -f .pes/HEAD ] && echo "PASS: .pes/HEAD exists" || echo "FAIL: .pes/HEAD missing"
echo ""

# ── Add and Status ─────────────────────────────────────────────────────────
echo "--- Staging Files ---"
echo "version 1" > file.txt
echo "hello world" > hello.txt
"$PES" add file.txt hello.txt
echo "Status after add:"
"$PES" status
echo ""

# ── First Commit ───────────────────────────────────────────────────────────
echo "--- First Commit ---"
"$PES" commit -m "Initial commit"
[ -f .pes/HEAD ] && echo "PASS: commit hash exists" || echo "FAIL: commit hash missing"
echo ""

# ── Second Commit ───────────────────────────────────────────────────────────
echo "--- Second Commit ---"
echo "version 2" >> file.txt
"$PES" add file.txt
"$PES" commit -m "Second commit"
[ -f .pes/HEAD ] && echo "PASS: second commit hash exists" || echo "FAIL: second commit hash missing"
echo ""

# ── Log Output ──────────────────────────────────────────────────────────────
echo "--- Log Output ---"
"$PES" log
COMMIT_COUNT=$("$PES" log 2>/dev/null | grep -c "^commit " || echo "0")
if [ "$COMMIT_COUNT" -eq 2 ]; then
    echo "PASS: log shows 2 commits"
else
    echo "FAIL: log shows $COMMIT_COUNT commits (expected 2)"
fi
echo ""

echo "=== All integration tests passed ==="
