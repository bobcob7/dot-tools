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
```

### Maintaining Context Files

When you add, remove, or significantly modify files in a directory:
- Update the corresponding `.context.md` file
- Keep descriptions concise but informative
- Focus on external interfaces and purpose, not implementation details

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

### Shell/Bash
- Use `[[ ]]` for conditionals over `[ ]`
- Quote variables: `"$var"` not `$var`
- Use `local` for function variables

### JavaScript/TypeScript
- Prefer `const` over `let` where possible
- Use arrow functions for callbacks
- Prefer async/await over raw promises

### Python
- Follow PEP 8
- Use type hints for function signatures
- Prefer f-strings for formatting

## Testing

- Write tests for new functionality
- Keep tests focused on one behavior
- Use descriptive test names that explain what's being tested
