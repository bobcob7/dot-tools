---
name: context
description: Validate and create .context.md files for all directories
allowed-tools: Bash, Read, Write, Glob, Grep, Edit
---

Validate that all non-git-ignored directories have valid `.context.md` files.

## Steps

1. Find all directories that are not git-ignored:
   ```bash
   find . -type d -not -path './.git/*' | while read dir; do
     git check-ignore -q "$dir" 2>/dev/null || echo "$dir"
   done
   ```

2. For each directory found, check if `.context.md` exists

3. If `.context.md` exists, validate it has the required sections:
   - `## Purpose` - Describes the directory's role
   - `## Functionality` - Lists external features/capabilities
   - `## Files` - Documents files in the directory
   - `## TODO` - Outstanding tasks with priorities (P0-P3)

4. Report findings:
   - List directories missing `.context.md`
   - List directories with incomplete context files (missing sections)
   - List directories with valid context files

5. For directories missing context files, offer to create them:
   - Read the files in the directory
   - Analyze their purpose and functionality
   - Generate a `.context.md` with appropriate content

## Valid Context File Format

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
| `file1.ts` | Brief description |
| `file2.ts` | Brief description |

## TODO

| Priority | Task |
|----------|------|
| P0 | Critical tasks that block other work |
| P1 | Important tasks for core functionality |
| P2 | Nice-to-have improvements |
| P3 | Future/low-priority items |
```

## Options

- Run without arguments to scan and report
- When missing files are found, ask the user if they want to generate them
- Skip directories that only contain other directories (no source files)
