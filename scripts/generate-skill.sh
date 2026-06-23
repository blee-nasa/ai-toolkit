#!/usr/bin/env bash
#
# Generate a new skill in .claude/skills/<name>/SKILL.md from the sample-skill template.
# Usage: scripts/generate-skill.sh <skill-name>   (kebab-case, e.g. my-skill)
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$ROOT/.claude/skills/sample-skill/SKILL.md"

name="${1:-}"
if [[ -z "$name" ]]; then
  echo "Usage: $0 <skill-name>   (kebab-case, e.g. my-skill)" >&2
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

dest_dir="$ROOT/.claude/skills/$name"
dest="$dest_dir/SKILL.md"
if [[ -e "$dest" ]]; then
  echo "Error: $dest already exists." >&2
  exit 1
fi

# "my-skill" -> "My Skill" (portable title-case; macOS/BSD-safe, no GNU sed \u)
title="$(echo "$name" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) substr($i,2)}}1')"

mkdir -p "$dest_dir"
sed -e "s/sample-skill/$name/g" -e "s/Sample Skill/$title/g" "$TEMPLATE" > "$dest"

echo "Created skill: $dest"
echo "  invoke with: /$name"
