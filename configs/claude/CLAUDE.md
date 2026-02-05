# User Preferences

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
