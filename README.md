# ai-toolkit

Project-agnostic, portable tooling for AI-assisted software development.

Canonical AI tool definitions live once under `.claude/` and are read natively by
both **Claude Code** and **GitHub Copilot** — no build or sync step. See
[`AGENTS.md`](AGENTS.md) for the conventions.

## Scaffolding new tools

`sample-agent` and `sample-skill` are the templates. Generate a new tool from them:

```sh
# bash directly
scripts/generate-agent.sh my-agent
scripts/generate-skill.sh my-skill

# or via npm / bun
npm run generate:agent -- my-agent
bun run generate:skill my-skill
```

This writes `.claude/agents/<name>.md` or `.claude/skills/<name>/SKILL.md`, ready to
edit. Reload your editor window to pick up the new definition.
