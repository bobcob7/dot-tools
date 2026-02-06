---
description: Testing conventions and best practices
---

# Testing

## Test Structure

- One assertion per test when practical
- Descriptive test names that explain the scenario
- Arrange-Act-Assert pattern

## Naming

Good test names describe:
- What is being tested
- Under what conditions
- Expected outcome

## What to Test

- Happy path behavior
- Edge cases (empty, null, boundary values)
- Error conditions
- Integration points

## What Not to Test

- Implementation details
- Third-party library internals
- Trivial getters/setters

## Mocking

- Mock external dependencies (APIs, databases)
- Don't mock the code under test
- Keep mocks minimal and focused

## Go-Specific

- See `go-standards.md` for full Go testing rules
- Always `t.Parallel()`, `t.Context()`, `io.Discard` logger
- Use moq-generated mocks from `moq_test.go` (same package)
- `require` for preconditions, `assert` for verifications

## Frontend-Specific

- See `typescript-standards.md` for full frontend testing rules
- Vitest + React Testing Library + @testing-library/jest-dom
- Always cleanup between tests via setup file
- Wrap components in required providers (Theme, Router, Redux)
