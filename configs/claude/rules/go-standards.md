---
description: Go language standards and conventions
---

# Go Standards

## Code Style

- **No blank lines inside functions** — keep function bodies as a single dense block
- `gofumpt` for formatting (stricter than `gofmt`)
- Prefer early returns over deep nesting
- Keep functions under ~40 lines where practical
- Context is always the first parameter: `func Foo(ctx context.Context, ...)`
- No `init()` functions — wire everything explicitly
- No package-level mutable state

## Visibility

- **Unexported by default** — only export what other packages need
- Exported functions require a godoc comment
- Unexported helpers do not need comments unless non-obvious

## Interfaces

- **Define interfaces where consumed, not where implemented**
- **All interfaces for a package live in `interfaces.go`** — one file, not scattered
- Keep interfaces small — one or two methods is ideal

## Error Handling

- Unexported sentinel errors: `errNotFound`, not `ErrNotFound` (unless needed externally)
- Wrap errors with context: `fmt.Errorf("getting document %s: %w", id, err)`
- Match errors at handler boundaries with `errors.Is` / `errors.As`
- Map domain errors to ConnectRPC status codes in handlers

## Mocking — Moq

- Use [moq](https://github.com/matryer/moq) — never hand-write mocks
- Generated into `moq_test.go` in the **same package**
- Single directive per `interfaces.go`: `//go:generate moq -out moq_test.go . iface1 iface2`
- No `-pkg`, no `-skip-ensure`, no `mocks/` subdirectory

## Testing

- `t.Parallel()` on all tests and subtests
- `t.Context()` instead of `context.Background()`
- `slog.New(slog.NewJSONHandler(io.Discard, nil))` for test loggers
- `require` for preconditions, `assert` for verifications
- testify + subtests, table-driven when appropriate

## Dependency Injection

- Manual constructor injection
- Wire the full graph in `cmd/server/main.go`
- Keep constructors simple — no side effects

## Tool Management

- Track Go tools in `internal/tools/tools.go` with `//go:build tools` tag
- Versions pinned in `go.mod`, installed via `GOBIN=$(GOBIN) go install`
- `make generate` is the single entry point for all code generation
