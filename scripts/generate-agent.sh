#!/usr/bin/env bash
#
# Generate a new agent in .claude/agents/<name>.md from the sample-agent template.
# Usage: scripts/generate-agent.sh <agent-name>   (kebab-case, e.g. my-agent)
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$ROOT/.claude/agents/sample-agent.md"

name="${1:-}"
if [[ -z "$name" ]]; then
  echo "Usage: $0 <agent-name>   (kebab-case, e.g. my-agent)" >&2
  exit 1
fi
if [[ ! "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Error: '$name' must be kebab-case (lowercase letters, digits, single hyphens)." >&2
  exit 1
fi
if [[ ! -f "$TEMPLATE" ]]; then
  echo "Error: template not found at $TEMPLATE" >&2
  exit 1
fi

dest="$ROOT/.claude/agents/$name.md"
if [[ -e "$dest" ]]; then
  echo "Error: $dest already exists." >&2
  exit 1
fi

# "my-agent" -> "My Agent" (portable title-case; macOS/BSD-safe, no GNU sed \u)
title="$(echo "$name" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) substr($i,2)}}1')"

sed -e "s/sample-agent/$name/g" -e "s/Sample Agent/$title/g" "$TEMPLATE" > "$dest"

echo "Created agent: $dest"
