---
name: review
description: Review code for quality, bugs, and improvements
argument-hint: "[file or directory]"
allowed-tools: Read, Glob, Grep
---

Review the code at `$ARGUMENTS` (or recent changes if no path given).

## Review Checklist

### Correctness
- Logic errors or edge cases
- Off-by-one errors
- Null/undefined handling
- Error handling completeness

### Security
- Input validation
- SQL injection, XSS, command injection
- Hardcoded secrets or credentials
- Insecure dependencies

### Performance
- Unnecessary iterations or computations
- N+1 queries
- Memory leaks
- Missing caching opportunities

### Maintainability
- Clear naming conventions
- Appropriate abstraction level
- Code duplication
- Complex conditionals that could be simplified

### Testing
- Test coverage for new code
- Edge cases tested
- Mocking done appropriately

## Output Format

Organize findings by severity:

### Critical
Issues that must be fixed (bugs, security vulnerabilities)

### Important
Issues that should be fixed (performance, maintainability)

### Suggestions
Nice-to-have improvements

For each issue:
- File and line number
- Description of the problem
- Suggested fix (with code if helpful)
