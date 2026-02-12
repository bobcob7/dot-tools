---
name: update-context
description: Scan, validate, and incrementally update .context.md files using git diff
allowed-tools: Bash, Read, Write, Glob, Grep, Edit
---

Scan all non-git-ignored directories for `.context.md` files. Detect staleness using stored git refs, and use `git diff` for incremental updates instead of regenerating from scratch.

## Steps

### 1. Scan directories

Find all non-git-ignored directories:
```bash
find . -type d -not -path './.git/*' | while read dir; do
  git check-ignore -q "$dir" 2>/dev/null || echo "$dir"
done
```

### 2. Classify each directory

For each directory, classify it into one of three categories:

- **Missing** — no `.context.md` file exists
- **Stale** — `.context.md` exists but has changes since last update
- **Up-to-date** — `.context.md` exists and no changes detected

To detect staleness, extract the `updated-at` ref from the bottom of the file:
```bash
grep -oP '(?<=<!-- updated-at: )\w+(?= -->)' "$dir/.context.md"
```

If a ref is found, check for changes:
```bash
git diff <ref>..HEAD -- "$dir"
```

If the diff is empty, the file is **up-to-date**. If there are changes, the file is **stale**.

If no ref is found (legacy file), treat it as **stale**.

### 3. Report findings

Get the current HEAD ref for later use:
```bash
git rev-parse --short HEAD
```

Print a summary:
- List **up-to-date** directories (no action needed)
- List **stale** directories with a brief note of what changed
- List **missing** directories

### 4. Update stale context files

For each **stale** directory:

1. Read the existing `.context.md`
2. Get the diff since the stored ref (or full directory listing if no ref):
   ```bash
   git diff <ref>..HEAD -- "$dir"
   ```
3. Read any new files that appear in the diff
4. Update only the affected sections:
   - **Files table** — add/remove/update entries for changed files
   - **Functionality** — update if the diff reveals new or removed capabilities
   - **Purpose** — update only if the directory's role fundamentally changed
   - **TODO** — update if completed tasks are visible in the diff
5. Update the `<!-- updated-at: <ref> -->` comment at the bottom to current HEAD

### 5. Generate missing context files

For each **missing** directory:

1. Skip directories that only contain subdirectories (no source files)
2. Read the files in the directory
3. Analyze their purpose and functionality
4. Generate a `.context.md` following the format below
5. Ask the user before creating each file

### 6. Validate all context files

After updates, validate that every `.context.md` has the required sections:
- `## Purpose`
- `## Functionality`
- `## Files`
- `## TODO`

## Context File Format

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

<!-- updated-at: abc1234 -->
```

The `<!-- updated-at: ... -->` comment must always be the last line. It stores the short git ref from when the file was last created or updated.

## Options

- Run without arguments to scan and report
- When missing files are found, ask the user if they want to generate them
- Skip directories that only contain other directories (no source files)
