#!/usr/bin/env bash
# install-skills.sh — make this toolkit's skills available to your AI tools.
#
# Links (or copies) selected skills from this repo into a skills dir your agent
# harness scans. Default target is ~/.agents/skills (read by Copilot); use
# --claude for Claude Code's ~/.claude/skills, or --target for anywhere.
#
# Single source of truth: symlinks point back into THIS clone, so `git pull`
# updates the skills in place — no re-run needed for content. Re-run only when a
# NEW skill is added (to create its link).
#
# Usage:
#   scripts/install-skills.sh                         # all skills -> ~/.agents/skills
#   scripts/install-skills.sh add-alias new-component # only these
#   scripts/install-skills.sh --claude                # -> ~/.claude/skills (Claude Code)
#   scripts/install-skills.sh --target DIR ...        # custom target dir
#   scripts/install-skills.sh --copy add-alias        # copy instead of symlink
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_ROOT/.claude/skills"

TARGET="$HOME/.agents/skills"
MODE="symlink"
SKILLS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --claude)  TARGET="$HOME/.claude/skills"; shift ;;
    --target)  TARGET="$2"; shift 2 ;;
    --copy)    MODE="copy"; shift ;;
    -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
    -*)        echo "unknown option: $1" >&2; exit 1 ;;
    *)         SKILLS+=("$1"); shift ;;
  esac
done

# Default to every skill folder in the repo.
if [ ${#SKILLS[@]} -eq 0 ]; then
  for d in "$SRC"/*/; do SKILLS+=("$(basename "$d")"); done
fi

mkdir -p "$TARGET"

for name in "${SKILLS[@]}"; do
  src="$SRC/$name"
  dst="$TARGET/$name"
  if [ ! -d "$src" ]; then
    echo "skip   $name (no such skill in $SRC)" >&2
    continue
  fi
  if [ "$MODE" = copy ]; then
    rm -rf "$dst"
    cp -R "$src" "$dst"
    echo "copied $name -> $dst"
  else
    # Refresh our own symlink, but never clobber a real directory someone else owns.
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
      echo "skip   $name ($dst exists and isn't a symlink — leaving it)" >&2
      continue
    fi
    rm -f "$dst"
    ln -s "$src" "$dst"
    echo "linked $name -> $dst"
  fi
done
