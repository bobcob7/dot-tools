---
description: Error handling best practices
---

# Error Handling

## General Principles

- Handle errors at the appropriate level
- Don't swallow errors silently
- Provide meaningful error messages
- Log errors with context for debugging

## Patterns

### Early Return on Error
```javascript
function process(data) {
  if (!data) {
    return { error: "Data is required" };
  }
  // happy path continues...
}
```

### Try-Catch Boundaries
- Catch at boundaries (API handlers, event handlers)
- Let errors bubble up from internal functions
- Don't wrap every function in try-catch

### Error Types
- Use specific error types/classes when available
- Include relevant context in error messages
- Don't expose internal details to end users

## Go-Specific

- Unexported sentinel errors: `errNotFound` (not `ErrNotFound`) unless externally needed
- Wrap with context: `fmt.Errorf("doing X: %w", err)`
- Match with `errors.Is` / `errors.As` at handler boundaries
- Map domain errors to ConnectRPC codes in handlers:
  ```go
  if errors.Is(err, errNotFound) {
      return nil, connect.NewError(connect.CodeNotFound, err)
  }
  ```

## Anti-patterns to Avoid

- Empty catch blocks
- Catching and re-throwing without adding context
- Using exceptions for control flow
- Overly broad catch statements
