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

```javascript
// Good
test("formatDate returns ISO string for valid Date object")
test("parseUser throws when email is missing")

// Bad
test("formatDate works")
test("test1")
```

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
