---
name: forge-skill
description: Forge a new Claude Code skill for cheap models like Haiku or Copilot — gather requirements, draft it, then battle-test it against 5 sequential Haiku runs and harden it until they run clean. Use when the user wants to author, generate, forge, or harden a skill.
model: opus
effort: max
---

# Forge Skill

Forge a new Claude Code skill: gather what it should do, draft it, then
**battle-test it against cheap models and harden it until it runs clean**. The
skills this produces are meant to run elsewhere on inexpensive models (Haiku,
Copilot), so the bar is high — the artifact must be so clear and well documented
that a cheap model executes it without ever stopping to figure things out.

## Core principles

- **Target = cheap models.** Everything produced is optimized for Haiku / Copilot
  to run flawlessly. Favor explicit steps, worked examples, and copy-paste
  templates over anything open-ended.
- **Tripping is the enemy.** A test model "trips" when it either (a) produces the
  wrong output, OR (b) burns cycles/tokens figuring out what to do — guessing,
  asking, exploring, backtracking, re-reading. Both count as trips.
- **A trip is a gap in the SKILL, never a flaw in the model.** When the model
  trips, the fix is always to tighten the skill — forge until tripping is minimal.
  But separate gaps from intent: following a documented default, fallback, or
  branch — or asking when the input is *genuinely* ambiguous — is expected
  behavior, NOT a trip. Only wasted cycles caused by the skill's own ambiguity
  count.
- **Never lie to the model — even by accident.** Every claim the skill makes must
  be something the model can rely on. Don't assert a default as a fact ("the app
  *is* at X" when it might not be) or state things only true in one
  repo/environment. Frame heuristics as heuristics and scope claims to where they
  actually hold — false premises confuse the model and read as gaps.
- **This machine can afford to forge.** It runs on a heavy Claude subscription, so
  spend Opus + Haiku cycles freely here to produce a skill that's cheap to run
  everywhere else.

## Operating mode — intentional over-provisioning

This skill always runs on **Opus** at **max** effort (pinned in frontmatter
above) and drives the work through the **Workflow** tool rather than one-shotting
it — the ultracode approach. ultrathink. Opus does the thinking (gather, draft,
diagnose, harden); Haiku does the testing. The heavy cost lives here and buys a
lightweight artifact for elsewhere.

## Procedure

### 1. Gather
Interview the user until the target skill is fully specified with NOTHING left to
guess. Capture:
- name, one-line purpose, and the exact conditions that should trigger it;
- inputs/arguments and the precise expected output or behavior;
- the target model(s) it will run on (Haiku, Copilot, etc.);
- **at least 5 distinct test scenarios paired with their correct/expected
  outputs**, spanning the happy path and the edge cases — one feeds each Haiku
  run, and they are the ground truth used later to detect trips. No ground truth →
  no way to judge correctness. Set up any fixtures the scenarios need (real target
  files/dirs, varied starting states) so the runs are realistic;
- known edge cases, constraints, and the tools it needs.

Ask follow-ups until the spec is unambiguous.

### 2. Create
Draft the new skill at `.claude/skills/<name>/SKILL.md` (and its folder), written
FOR the cheap target model: explicit step-by-step instructions, worked examples,
copy-paste templates, clearly stated triggers and outputs. Pre-empt every
ambiguity — leave no room to "figure it out." Set the produced skill's OWN
frontmatter for its cheap target (do NOT copy this forge skill's Opus/max
settings into it).

### 3. Forge (test-and-harden loop)
Drive this loop with the Workflow tool. Repeat each round until the judge passes
all five runs, or stop after **5 rounds** and report the skill as not yet
converged.

1. **Test (coverage)** — run **5 Haiku agents, one per scenario** (`model:
   'haiku'`), each given the produced skill and a **different** scenario, so one
   round covers five distinct angles (happy path + edge cases) rather than the
   same case five times. Run them **sequentially**, resetting the workspace to a
   clean baseline between runs (or give each its own isolated copy) — never let
   agents mutate the same files at once, or they clobber each other. Each Haiku
   executes the skill as a fresh cheap model would and returns raw data only: the
   output it produced, a factual log of what it did (steps taken, anywhere it
   paused / guessed / asked / backtracked), and its tool-call count. The Haiku
   does NOT judge itself.
2. **Judge (outside, Opus)** — an independent Opus judge (never the test models)
   scores each of the five runs against its ground truth: did the output match
   (correctness), and did the trajectory stay lean (efficiency)? It rules each run
   **clean** or **tripped**, and for every trip names the failure mode (wrong
   output vs. wasted cycles) and the specific gap in the skill that caused it.
3. **Clean?** If the judge passes all five, the skill is forged — go to Report.
4. **Diagnose & harden** — otherwise, aggregate the gaps the judge found across
   the tripped runs (fold any newly surfaced edge case into the scenario pool),
   rewrite the skill to close them, and loop with fresh Haikus.

### 4. Report
Output the forged skill's path plus a short report: rounds taken, gaps found and
closed, and the final clean-round trajectory.

## Scope — what forging does and does not catch

The forge surfaces **execution** trips a cheap model hits in the test
environment. It will NOT catch correctness or portability gaps that never surface
there — e.g. how the skill behaves in a repo with a different layout, or a claim
that is only true for the test project. So review the draft by hand for
truthfulness and portability too; hand review and forging catch complementary
failure modes.
