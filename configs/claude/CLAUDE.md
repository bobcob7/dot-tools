# User Preferences

## Directory Context Files

When working in this codebase, use `.context.md` files to understand directory structure and purpose. These files provide essential documentation for each directory.

### Reading Context Files

Before modifying code in a directory, check for a `.context.md` file and read it to understand:
- The directory's purpose and relationship to the project
- Available functionality and APIs
- What each file does

### Creating Context Files

**When creating a new directory, always create a `.context.md` file** with these sections:

```markdown
# Directory Name

## Purpose

Describe the overall role of this directory and how it relates to the rest of the project.

## Functionality

High-level description of functionality this directory provides externally:
- Feature or capability 1
- Feature or capability 2

## Files

| File | Description |
|------|-------------|
| `file1.ts` | Brief description of what this file does |
| `file2.ts` | Brief description of what this file does |

## TODO

| Priority | Task |
|----------|------|
| P0 | Critical tasks that block other work |
| P1 | Important tasks for core functionality |
| P2 | Nice-to-have improvements |
| P3 | Future/low-priority items |

<!-- updated-at: <git-ref> -->
```

The `<!-- updated-at: ... -->` comment must always be the last line. Replace `<git-ref>` with the short output of `git rev-parse --short HEAD`. This tracks when the file was last updated so staleness can be detected via `git diff`.

The TODO section tracks outstanding work with priorities (P0 = critical, P3 = low). Update it when tasks are completed or new work is identified.

### Maintaining Context Files

When you add, remove, or significantly modify files in a directory:
- Update the corresponding `.context.md` file
- Keep descriptions concise but informative
- Focus on external interfaces and purpose, not implementation details
- Update the `<!-- updated-at: ... -->` ref to the current HEAD

## General

- Prefer concise responses over verbose explanations
- Use code comments sparingly - only when logic isn't self-evident
- Don't add emojis unless explicitly requested

## Code Style

- Use meaningful variable and function names
- Prefer early returns over nested conditionals
- Keep functions focused and small
- Follow existing project conventions when modifying code

## Git

- Write commit messages in imperative mood ("Add feature" not "Added feature")
- Keep commit messages concise but descriptive
- Don't amend commits unless explicitly asked

## Languages

### Go
- No blank lines inside functions
- Interfaces defined at the consumer, not the implementor
- All interfaces in a package go in `interfaces.go` — one file, not scattered
- Use moq for mock generation — generated into `moq_test.go` (same package)
- Unexported by default — only export what other packages need
- Unexported error sentinels (`errNotFound`, not `ErrNotFound`) unless needed externally
- Constructor injection, wire in `main()`
- Use `slog` for structured logging, pass `*slog.Logger` via constructor
- Track tool versions in `go.mod` via a `tools.go` file with `//go:build tools` tag

### TypeScript/React
- Named exports only — no default exports
- `strict: true` and `noUncheckedIndexedAccess: true` in tsconfig
- Prefer `const` over `let`
- Use arrow functions for callbacks
- Prefer async/await over raw promises
- CSS Modules for component styling
- Redux Toolkit for state management (createSlice, createAsyncThunk)

### Shell/Bash
- Use `[[ ]]` for conditionals over `[ ]`
- Quote variables: `"$var"` not `$var`
- Use `local` for function variables

### Python
- Follow PEP 8
- Use type hints for function signatures
- Prefer f-strings for formatting

## Testing

### General
- Write tests for new functionality
- Keep tests focused on one behavior
- Use descriptive test names that explain what's being tested

### Go Tests
- Always use `t.Parallel()` on tests and subtests
- Always use `t.Context()` instead of `context.Background()`
- Always use `slog.New(slog.NewJSONHandler(io.Discard, nil))` for loggers in tests
- Use `require` for preconditions, `assert` for verifications
- Use moq-generated mocks — never hand-write mocks

### Frontend Tests
- Vitest + React Testing Library + @testing-library/jest-dom
- Setup file with `cleanup()` after each test
- Wrap MUI components in ThemeProvider
- Wrap router components in MemoryRouter
- Test Redux slices by calling reducer directly with actions
