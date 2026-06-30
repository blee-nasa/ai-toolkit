# ai-toolkit — agent guide

A forge for portable AI-dev skills: authored once under `.claude/`, hardened
against cheap models, and read natively by Claude Code and GitHub Copilot. The
goal is a **single source of truth** for AI dev tools — no build step.

## Conventions

Canonical tool definitions are authored once under `.claude/`:

- `.claude/agents/<name>.md` — subagents / custom agents
- `.claude/skills/<name>/SKILL.md` — skills (model-invoked; run with `/<name>`)
- `.claude/rules/<name>.md` — path-scoped instructions

Both Claude Code and VS Code Copilot read `.claude/` natively, so there is nothing
to generate or sync *to use a skill here*. To deliver the same single source to
**other** projects or machines, `scripts/install-skills.sh` symlinks (or copies)
chosen skills into a global skills dir (`~/.agents/skills`, `~/.claude/skills`, …);
a `git pull` keeps them current.

## How skills are made here

`forge-skill` drafts a skill and battle-tests it against cheap models until it
runs clean. Its proving ground is **`apps/web`** — a minimal Vite + React + TS app
with a Vitest suite that the stack-specific skills (`add-alias`, `new-component`)
are forged and tested against. When working on those skills, that app is the
fixture to exercise them on.

This file (`AGENTS.md`) holds shared always-on context. Copilot reads it directly;
Claude Code reads it via the one-line `@AGENTS.md` import in `CLAUDE.md`.
