# ai-toolkit — agent guide

Project-agnostic, portable tooling for AI-assisted software development. The goal
is a **single source of truth** for AI dev tools, authored once and read natively
by Claude Code and GitHub Copilot — no build or sync step.

## Conventions

Canonical tool definitions are authored once under `.claude/`:

- `.claude/agents/<name>.md` — subagents / custom agents
- `.claude/skills/<name>/SKILL.md` — skills (model-invoked; run with `/<name>`)
- `.claude/rules/<name>.md` — path-scoped instructions

Both Claude Code and VS Code Copilot read `.claude/` natively, so there's nothing
to generate or sync.

This file (`AGENTS.md`) holds shared always-on context. Copilot reads it directly;
Claude Code reads it via the one-line `@AGENTS.md` import in `CLAUDE.md`.
