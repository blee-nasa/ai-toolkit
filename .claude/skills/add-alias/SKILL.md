---
name: add-alias
description: Add an import path alias to this repo's Vite + TypeScript app — e.g. "@components" → "src/components" — so it resolves in both Vite and TypeScript. Locates the app via its vite.config.ts, edits that app's tsconfig.app.json paths, and turns on resolve.tsconfigPaths in its vite.config.ts if needed. Use when asked to add, create, or set up a path alias or import shortcut.
model: haiku
argument-hint: <@alias> <src/target-dir>
---

# Add Alias

Add an import alias to this repo's Vite + TypeScript app so that
`import x from "@alias/..."` resolves in both Vite (bundling) and TypeScript
(types + editor). You change at most two files, both inside the app folder.

## Inputs

Exactly two arguments:
1. `<@alias>` — the alias name, always starting with `@` (e.g. `@components`).
2. `<src/target-dir>` — the target folder **relative to the app root**, always
   under `src/` (e.g. `src/components`).

Example: `/add-alias @components src/components`

## Step 1 — Locate the app

A Vite app most often lives at **`apps/web`**, so check there first: if
`apps/web/vite.config.ts` exists, that folder is the app root — use it.

If it is not there, find the app instead: search the repo for `tsconfig.app.json`
(or `vite.config.ts`), ignoring `node_modules` and `dist`, and use the folder
that contains it. If there are several, ask which app.

Both routes are normal — neither is a mistake. Everything below happens inside
the app root, and `<src/target-dir>` is relative to it.

## Done = both of these are true (inside the app root)

1. **`<app>/tsconfig.app.json`** has BOTH a bare and a wildcard entry under
   `compilerOptions.paths`:
   ```json
   "paths": {
     "@components": ["./src/components"],
     "@components/*": ["./src/components/*"]
   }
   ```
2. **`<app>/vite.config.ts`** has `resolve: { tsconfigPaths: true }` (this is what
   makes Vite read those paths).

## Step 2 — Turn on Vite path resolution (one-time)

Open `<app>/vite.config.ts`.
- If it already has `resolve: { tsconfigPaths: true }`, leave it as is.
- If not, add it to the config object:
  ```ts
  export default defineConfig({
    plugins: [react()],
    resolve: { tsconfigPaths: true },
  })
  ```
Do NOT install any package — `tsconfigPaths` is a built-in Vite option.

## Step 3 — Add the alias to `<app>/tsconfig.app.json`

Edit the tsconfig whose `"include"` covers `src` — that is the only one you
touch. In a create-vite app the three tsconfigs split up like this:
- ✅ `<app>/tsconfig.app.json` — has `"include": ["src"]`; this is the one.
- ❌ `<app>/tsconfig.json` — in this layout it only holds project references
  (no `compilerOptions.paths`).
- ❌ `<app>/tsconfig.node.json` — in this layout it covers `vite.config.ts`, not
  your source.

If an app has just one `tsconfig.json` with `compilerOptions` (no split), add the
paths there instead.

Inside `compilerOptions`:
- If there is no `paths` key, add one.
- Add BOTH entries for the alias, each value a one-item array with a leading
  `./`:
  - `"<@alias>": ["./<src/target-dir>"]`
  - `"<@alias>/*": ["./<src/target-dir>/*"]`
- MERGE with any existing entries — never delete or overwrite the others.
- If both entries already exist exactly, change nothing (it is already done).
- Keep valid JSON: comma between entries, no trailing comma.

## Step 4 — Confirm

Re-read the `paths` block and check both new entries are present and spelled
correctly. Report the alias you added, the app root, and which file(s) you
changed.

## Worked example — merging into existing paths

App root `apps/web`, run: `/add-alias @lib src/lib`

`apps/web/tsconfig.app.json` before:
```json
"compilerOptions": {
  // ...other options...
  "paths": {
    "@components": ["./src/components"],
    "@components/*": ["./src/components/*"]
  }
}
```
After — existing entries kept, two new ones appended:
```json
"compilerOptions": {
  // ...other options...
  "paths": {
    "@components": ["./src/components"],
    "@components/*": ["./src/components/*"],
    "@lib": ["./src/lib"],
    "@lib/*": ["./src/lib/*"]
  }
}
```
