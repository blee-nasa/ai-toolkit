---
name: new-component
description: Scaffold a new React building block — component / page / view / screen / layout / context / hook — in this repo's Vite + TS app, matching the project's conventions (per-item folder, barrel, adjacent test, CSS module). Use when asked to create, add, scaffold, or make a new component, page, view, screen, layout, context, or hook.
model: haiku
argument-hint: <Name> (e.g. "a page called LandingPage", "Button", "a context called Theme", "useToggle")
---

# New Component

Scaffold a new building block in this repo's Vite + TypeScript app, matching the
structure the project already uses. You create a per-item folder with a shell, a
barrel, and (when a test suite exists) an adjacent test.

Ask the user for guidance ONLY as a last resort — infer what you can first. Three
moments genuinely call for it: a missing test suite (step 2), an ambiguous
top-level views folder (step 4), and creating a brand new top-level folder
(step 4).

## Types → folders

The requested **type** maps to a **top-level folder under `src/`**, pluralized:

| Asked for                     | Folder                                              | Renderable? |
| ----------------------------- | --------------------------------------------------- | ----------- |
| component (default)           | `src/components/`                                   | yes         |
| page / view / screen / layout | the project's one top-level views folder (see note) | yes         |
| context                       | `src/contexts/`                                     | no          |
| hook                          | `src/hooks/`                                        | no          |

**`page` / `view` / `screen` / `layout` are synonyms** — all mean a top-level,
composed view (as opposed to a small reusable `component`). A project keeps ONE
folder for these, under some name (`pages/`, `views/`, `screens/`, or
`layouts/`). So don't blindly create `pages/` because the user said "page": if a
`views/` (or `screens/`, …) folder already exists, they almost certainly mean
that one. Step 4 resolves it.

These top-level view folders are **siblings of `components/`, never nested inside
it** — nesting invites `components → views → components` import cycles through the
barrels.

## Procedure

### 1. Determine name + type

Read the request. Infer the **type** from the noun ("a **page** called LandingPage"
→ a top-level view; "a **context** called Theme" → context; a `use`-prefixed name
→ hook). Default to **component** when no type is stated. Infer the **Name**
(PascalCase for renderables/contexts; `use`-prefixed camelCase for hooks). Ask
only if the type is truly ambiguous.

### 2. Check for a test suite

Look in the app's `package.json` for a test runner (`vitest` or `jest`) in
devDependencies plus a `test` script. Also check for a config (`vite.config.*`
`test` block, `vitest.config.*`, or `jest.config.*`).

- **Present** → you will scaffold an adjacent test (step 6).
- **Missing** → STOP and tell the user there is no test suite, and **offer to set
  one up** (see "Setting up a test suite"). Then:
  - user accepts → set it up, then continue **with** the test.
  - user says keep going anyway → continue **without** any test file (skip every
    test step below).

### 3. Detect styling

Check the app for a styling library: Tailwind (`tailwindcss` dep / `tailwind.config.*`
/ `@tailwind` in CSS) or Bootstrap (`bootstrap` dep). If neither, assume CSS
Modules. Either way, **every renderable still gets its own `.module.css`** (with
Tailwind/Bootstrap present, the component may also use utility `className`s).
Non-renderables (context, hook) get **no** CSS.

### 4. Resolve the top-level folder

For **component / context / hook**, the folder is just the pluralized type:
`components/`, `contexts/`, `hooks/`.

For **page / view / screen / layout** (synonyms), find the project's existing
top-level views folder among `pages/`, `views/`, `screens/`, `layouts/`:

- exactly one exists → **use it**, even if its name differs from the word the user
  said (request "page" + existing `views/` → use `views/`);
- none exist → you are establishing the convention; since that creates a new
  top-level folder anyway (below), confirm the folder name with the user (default
  to pluralizing the word they used);
- more than one exists → **ask** which one.

Then, with the folder decided:

- **Exists** → append the new item to its aggregate `index.ts` barrel.
- **Does NOT exist** → confirm with the user that a new `<folder>/` should be
  created. If yes:
  1. create the folder,
  2. give it an import alias `@<folder>` → `src/<folder>` (follow the **add-alias**
     skill: add both bare + wildcard entries to the app's `tsconfig.app.json`
     `paths`, and turn on `resolve.tsconfigPaths` in `vite.config.ts` if needed),
  3. create its aggregate `src/<folder>/index.ts` barrel.

### 5. Scaffold the item

Create the per-item folder with the files from the matching template below, then
**append** the item's public export(s) to the folder's aggregate `index.ts`
barrel (never delete the existing lines).

### 6. Adjacent test (only if a suite exists)

Add the test from the matching template, with **explicit imports** (detected
runner + `@testing-library/react`).

The baseline asserts the component **renders with no props** — a firm project
rule: every component must work with zero required props (give props sensible
defaults rather than weaken the test). Keep that assertion.

Check whether the app mounts everything inside context providers — inspect
`src/main.tsx` (how `<App />` is rendered) and the root of `src/App.tsx` for
wrapping providers like `<AuthProvider>` / `<ThemeProvider>`.

- **They exist** → a new renderable always renders inside them, so wrap the test
  subject in those same providers (the "Renderable that depends on a context"
  shape) with a single render assertion. Skip the `throws-without-provider` test
  for a fresh shell — it doesn't use the context yet, so it wouldn't throw.
- **None** → strict baseline: render the component directly, no wrapping.

Only wrap in providers that genuinely wrap the whole app — never invent a
dependency the component doesn't have.

### 7. Report

State the name, type, folder, every file created, whether a new folder + alias
were created, and whether a test was included (or why not).

## Templates

Each template is written with a **concrete sample name** — `Widget` (renderable),
`Theme` (context), `useExample` (hook). To use one, copy it and **replace the
sample name everywhere it appears** with the requested name. (Sample names are
used on purpose: a placeholder like `<Name>` collides with JSX's `<` and is hard
to substitute correctly.) `<folder>` in a path = the folder resolved in step 4.
Write `export const` arrow components; let the project's formatter settle quote
style and spacing.

### Renderable — sample name `Widget`

`<folder>/Widget/Widget.tsx`

```tsx
import styles from "./Widget.module.css";

export const Widget = () => (
  <div className={styles.container}>
    <h1>Widget</h1>
  </div>
);
```

`<folder>/Widget/Widget.module.css`

```css
.container {
}
```

`<folder>/Widget/index.ts`

```ts
export { Widget } from "./Widget";
```

`<folder>/Widget/Widget.test.tsx` (only if a suite exists)

```tsx
import { describe, it, expect } from "vitest";
import { render } from "@testing-library/react";

import { Widget } from "./Widget";

describe("<Widget />", () => {
  it("renders without props", () => {
    const { container } = render(<Widget />);
    expect(container).toBeInTheDocument();
  });
});
```

### Renderable that depends on a context (evolved test — for reference)

The skill only scaffolds the strict baseline above. When a renderable actually
needs a context to work, the developer evolves its test into this shape: alias the
real component, wrap it in the required provider as the test subject, and add a
test that it throws WITHOUT the provider. Sample: a `Widget` that needs
`ThemeProvider`.

```tsx
import { describe, it, expect } from "vitest";
import { render } from "@testing-library/react";

import { Widget as WidgetBase } from "./Widget";
import { ThemeProvider } from "@contexts";

const Widget = () => (
  <ThemeProvider>
    <WidgetBase />
  </ThemeProvider>
);

describe("<Widget />", () => {
  it("renders without props", () => {
    const { container } = render(<Widget />);
    expect(container).toBeInTheDocument();
  });

  it("throws without <ThemeProvider />", () => {
    const renderWithoutThemeProvider = () => render(<WidgetBase />);
    expect(renderWithoutThemeProvider).toThrow();
  });
});
```

### Context — sample name `Theme`

`contexts/Theme/Theme.tsx`

```tsx
import { createContext, useContext, type ReactNode } from "react";

export type ThemeValue = {
  // describe the context value here
};

const ThemeContext = createContext<ThemeValue | null>(null);

export const ThemeProvider = ({ children }: { children: ReactNode }) => {
  const value: ThemeValue = {};

  return (
    <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>
  );
};

export const useTheme = () => {
  const context = useContext(ThemeContext);
  if (context === null) {
    throw new Error("useTheme must be used within a ThemeProvider");
  }
  return context;
};
```

`contexts/Theme/index.ts`

```ts
export { ThemeProvider, useTheme } from "./Theme";
export type { ThemeValue } from "./Theme";
```

`contexts/Theme/Theme.test.tsx` (only if a suite exists)

```tsx
import { describe, it, expect } from "vitest";
import { render } from "@testing-library/react";

import { ThemeProvider } from "./Theme";

describe("<ThemeProvider />", () => {
  it("renders without props or context", () => {
    const { container } = render(
      <ThemeProvider>
        <div />
      </ThemeProvider>,
    );
    expect(container).toBeInTheDocument();
  });
});
```

### Hook — sample name `useExample`

`hooks/useExample/useExample.ts`

```ts
export const useExample = () => {
  return {};
};
```

`hooks/useExample/index.ts`

```ts
export { useExample } from "./useExample";
```

`hooks/useExample/useExample.test.ts` (only if a suite exists)

```ts
import { describe, it, expect } from "vitest";
import { renderHook } from "@testing-library/react";

import { useExample } from "./useExample";

describe("useExample", () => {
  it("returns its state without props or context", () => {
    const { result } = renderHook(() => useExample());
    expect(result.current).toBeDefined();
  });
});
```

## Setting up a test suite (when offered + accepted)

Match the runner already implied by the project; default to **vitest**. Install
dev dependencies: `vitest`, `@testing-library/react`, `@testing-library/jest-dom`,
`jsdom`. Then:

- add a `test` block to `vite.config.ts` (`environment: 'jsdom'`,
  `setupFiles: ['./src/test-setup.ts']`) with `/// <reference types="vitest/config" />`
  at the top;
- create `src/test-setup.ts` containing `import '@testing-library/jest-dom';`
- add a `"test": "vitest"` script to `package.json`.

Tests use explicit imports (above), so vitest `globals` stays off.
