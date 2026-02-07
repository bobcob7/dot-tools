---
description: TypeScript and React standards and conventions
---

# TypeScript Standards

## Code Style

- **Named exports only** — no default exports
- `strict: true` and `noUncheckedIndexedAccess: true` in tsconfig
- No `any` — use `unknown` and narrow
- Explicit return types on exported functions
- No non-null assertions (`!`) — handle the null case
- Use `===` exclusively

## Types

- **Interface** for object shapes, **type** for unions/intersections
- Props interfaces named `{ComponentName}Props`
- Prefer `readonly` arrays and objects
- Avoid enums — use `as const` objects or string literal unions

## React

- Function components only
- CSS Modules for component styling (one `.module.css` per component)
- MUI as base component library, themed to match project palette
- Use `sx` prop sparingly — prefer CSS Modules

## State Management

- Redux Toolkit with `createSlice` and `createAsyncThunk`
- One slice per domain
- ConnectRPC for type-safe API calls

## Testing

- **Vitest** + **React Testing Library** + **@testing-library/jest-dom**
- Test setup at `src/test/setup.ts` with cleanup after each test:
  ```ts
  import "@testing-library/jest-dom/vitest";
  import { cleanup } from "@testing-library/react";
  import { afterEach } from "vitest";
  afterEach(() => { cleanup(); });
  ```
- Wrap MUI components in `ThemeProvider`
- Wrap router components in `MemoryRouter` with `Routes`/`Route`
- Wrap Redux components in `Provider` with a test store
- Test Redux slices by calling reducer directly with actions
- Test behavior, not implementation
