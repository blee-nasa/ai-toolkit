# ai-toolkit

A **forge for portable AI-dev skills**: author once under `.claude/`, harden them
against cheap models, and ship them to any project — read natively by Claude Code
and GitHub Copilot.

## Skills

- **`forge-skill`** — the blade-maker. Gather → draft → battle-test a new skill
  against sequential Haiku runs → harden until it runs clean. Runs on Opus here.
- **`add-alias`** — add a Vite + TS import path alias (both `tsconfig.app.json`
  `paths` and `resolve.tsconfigPaths`).
- **`new-component`** — scaffold a React component / page / view / context / hook
  (per-item folder, barrel, adjacent test, CSS module) to a project's conventions.

`forge-skill` is expensive on purpose; the artifacts it produces (`add-alias`,
`new-component`) are forged to run reliably on cheap models (Haiku, Copilot).

## Use the skills in another project

```sh
git clone https://github.com/blee-nasa/ai-toolkit.git
cd ai-toolkit
scripts/install-skills.sh add-alias new-component   # → ~/.agents/skills (Copilot)
scripts/install-skills.sh --claude                  # all skills → ~/.claude/skills (Claude Code)
```

`install-skills.sh` symlinks the chosen skills into a global skills dir, so a
`git pull` keeps them current — re-run only to add a new skill. `--copy` and
`--target DIR` cover other setups.

## `apps/web`

A minimal Vite + React + TypeScript app (npm-workspaces monorepo) with a Vitest
suite — the battlefield the stack-specific skills are forged and tested against.

See [`AGENTS.md`](AGENTS.md) for the authoring conventions.
