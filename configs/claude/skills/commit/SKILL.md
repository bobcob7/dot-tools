---
name: commit
description: Create a well-formatted git commit with staged changes
disable-model-invocation: true
allowed-tools: Bash, Read, Glob, Grep
---

Create a git commit for the currently staged changes.

## Steps

1. Run `git status` to see staged and unstaged changes
2. Run `git diff --cached` to review what will be committed
3. Analyze the changes and determine:
   - Type of change (feat, fix, refactor, docs, test, chore)
   - Brief summary of what changed
   - Why it changed (if not obvious)

4. Create a commit message following this format:
   - First line: type and concise summary (max 72 chars)
   - Blank line
   - Body: explain what and why (wrap at 72 chars)

5. Run `git commit -m "..."` with the message
6. Show `git log -1` to confirm

## Commit Types

- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code restructuring without behavior change
- `docs`: Documentation only
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependencies, config

## Examples

Good:
```
feat: add user authentication via OAuth

Implements OAuth2 flow with Google and GitHub providers.
Tokens are stored securely in httpOnly cookies.
```

Bad:
```
updated stuff
```
