---
description: Git workflow and commit conventions
---

# Git Workflow

## Commits

- Write commit messages in imperative mood: "Add feature" not "Added feature"
- First line max 72 characters
- Separate subject from body with blank line
- Use conventional commit prefixes: feat, fix, refactor, docs, test, chore

## Branches

- Keep branches focused on single features or fixes
- Rebase feature branches on main before merging when possible
- Delete branches after merging

## Safety

- Never force push to main/master
- Never commit secrets, credentials, or .env files
- Review diffs before committing
- Run tests before pushing
