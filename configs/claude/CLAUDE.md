# User Preferences

## Directory Context

Projects use structured context stored via the `sudo-context` MCP server. This provides machine-readable context about every directory — what it does, its strengths/weaknesses, dependencies, test coverage, and file inventory.

### Exploring with Context (query_context)

**Before reading files in an unfamiliar directory**, call `query_context` to get structured context:

```
query_context(project_root=<abs_path>, directory=<relative_path>)
```

This returns sections including `description`, `purpose`, `functionality`, `files`, `strengths`, `weaknesses`, `test_coverage`, and `dependencies`. Use this to orient yourself before diving into code.

You can filter to specific sections for efficiency:

```
query_context(project_root=<abs_path>, directory="lib/utils", sections=["purpose", "files"])
```

### Auditing Context (check_context_status)

To understand what's documented vs not across the whole project:

```
check_context_status(project_root=<abs_path>)
```

Returns three lists: `needs_creation` (undocumented dirs), `needs_update` (stale docs), `needs_deletion` (orphaned docs). Use `/update-context` to fix these.

### Writing Context (upsert_context)

After modifying code in a directory, update its context:

```
upsert_context(project_root=<abs_path>, repo=<owner/repo>, git_ref=<short_ref>, directory=<path>, sections={...})
```

Sections merge — you only need to pass the sections that changed. The 8 required section keys are: `description`, `purpose`, `strengths`, `weaknesses`, `test_coverage`, `dependencies`, `functionality`, `files`.
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
