#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 0 ]]; then
  PROMPT="$*"
else
  PROMPT="$(cat)"
fi

TMP_OUT="$(mktemp)"
trap 'rm -f "$TMP_OUT"' EXIT

printf '%s\n' "$PROMPT" | fabric -p era_agent_triage >"$TMP_OUT"

is_valid_quick() {
  grep -q '^QUICK DELEGATION' "$TMP_OUT" &&
    [[ "$(grep -c '^TARGET TYPE:' "$TMP_OUT")" -eq 1 ]] &&
    [[ "$(grep -c '^TARGET:' "$TMP_OUT")" -eq 1 ]] &&
    [[ "$(grep -c '^INVOKE:' "$TMP_OUT")" -eq 1 ]] &&
    [[ "$(grep -c '^CONFIDENCE:' "$TMP_OUT")" -eq 1 ]] &&
    [[ "$(grep -c '^ECONOMY:' "$TMP_OUT")" -eq 1 ]] &&
    [[ "$(grep -c '^MEMORY:' "$TMP_OUT")" -eq 1 ]] &&
    [[ "$(grep -c '^MEMORY_ROOM:' "$TMP_OUT")" -eq 1 ]]
}

is_valid_mission() {
  grep -q '^MISSION PLAN' "$TMP_OUT" &&
    grep -q '^MEMORY$' "$TMP_OUT" &&
    grep -q 'MEMORY_ROOM_MAP' "$TMP_OUT" &&
    grep -q '^VERIFY$' "$TMP_OUT" &&
    ! grep -q '^```' "$TMP_OUT" &&
    ! grep -qi '^note:' "$TMP_OUT" &&
    ! grep -qi '\*\*note' "$TMP_OUT" &&
    ! grep -qi 'security-pattern\|risk-simulation-chain\|memory agent\|TARGET: MemGPT/Letta' "$TMP_OUT"
}

if is_valid_quick || is_valid_mission; then
  cat "$TMP_OUT"
  exit 0
fi

cat <<EOF
QUICK DELEGATION
================
TARGET TYPE: agent
TARGET: era-ops
INVOKE: "Use era-ops to plan and coordinate this mission with strict output format and MemGPT/Letta memory via mempalace.yaml."
CONFIDENCE: medium
ECONOMY: medium
MEMORY: enabled (MemGPT/Letta via mempalace.yaml)
MEMORY_ROOM: orchestration-history
EOF
