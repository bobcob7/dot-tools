---
name: update-context
description: Scan, validate, and update directory context using sudo-context MCP tools
argument-hint: "[directory or blank for full scan]"
allowed-tools: Bash, Read, Glob, Grep
---

Scan all directories in the project for context completeness and staleness. Update or create context using the `sudo-context` MCP tools (`upsert_context`, `query_context`, `check_context_status`).

If `$ARGUMENTS` specifies a directory, only process that directory. Otherwise, run a full scan.

## Required Sections

Every directory context must include these 8 sections:

| Section Key | Content |
|-------------|---------|
| `description` | Single-sentence summary of what this directory is |
| `purpose` | Why this directory exists and its role in the project |
| `strengths` | What this directory does well |
| `weaknesses` | Known limitations, tech debt, or design issues |
| `test_coverage` | What's tested, what's not, testing approach |
| `dependencies` | External and internal dependencies this directory relies on |
| `functionality` | Capabilities this directory provides externally |
| `files` | Markdown table of files with descriptions |

## Steps

### 1. Gather project info

Run these commands to collect metadata for `upsert_context` calls:

```bash
git rev-parse --short HEAD        # git_ref
git remote get-url origin         # derive repo name (owner/repo)
```

Store the project root as the absolute path to the repo root (`git rev-parse --show-toplevel`).

### 2. Check context status

If a specific directory was given in `$ARGUMENTS`, skip this step and go directly to step 4 (creating/updating that directory).

Otherwise, call `check_context_status` with the project root. This returns three lists:

- **needs_creation** — directories with no stored context
- **needs_deletion** — orphaned contexts (directory deleted or gitignored)
- **needs_update** — contexts where the stored `git_ref` is behind HEAD

### 3. Report findings

Present the three lists to the user in a summary table. For example:

```
Status          | Count | Directories
----------------|-------|------------
Needs creation  | 3     | lib/utils, lib/core, bin/tools
Needs update    | 2     | configs/claude, modules
Orphaned        | 1     | old/removed-dir
```

For orphaned contexts, note that there is no delete tool — the user must manually remove files from `.sudo-context/`.

### 4. Group directories by depth for parallel processing

Combine `needs_update` and `needs_creation` into a single work list. Sort by path depth, **deepest first** (e.g., `a/b/c` before `a/b` before `a`). Group directories at the same depth level together.

This ensures child directories are processed before parents, so parent context can reference child information.

### 5. Process each depth level with parallel subagents

For each depth level, starting from the deepest:

1. Create a **TaskCreate** entry for each directory at that depth level
2. Launch one **Task subagent** (`subagent_type: "general-purpose"`) per directory. All subagents at the same depth run **in parallel** (multiple Task tool calls in a single message)
3. **Wait** for all subagents at that depth to complete before proceeding to the next (shallower) level
4. Mark each task as completed as subagents finish

Each subagent receives the `project_root`, `repo`, `git_ref`, and the target directory, plus the instructions below for its category.

#### Subagent instructions for stale directories (needs_update):

1. Call `query_context` to get the existing sections
2. Read changed files using `git diff <stored_git_ref>..HEAD -- <directory>` to understand what changed
3. Read the directory's files with Glob and Read to understand current state
4. For each of the 8 required sections, decide if it needs updating based on the diff
5. Call `upsert_context` with only the sections that changed (merging preserves unchanged sections)

#### Subagent instructions for missing directories (needs_creation):

1. Use Glob to list files in the directory
2. Read key files to understand the directory's purpose
3. Generate all 8 required sections
4. Call `upsert_context` with all sections

### 6. Section writing guidelines

When generating section content:

- **description**: One sentence. Be specific. "Shell module for Claude Code installation and config" not "A module".
- **purpose**: 2-3 sentences. Explain why this exists and how it fits in the project.
- **strengths**: Bullet list. What works well — clean API, good test coverage, clear separation of concerns, etc.
- **weaknesses**: Bullet list. Be honest — tech debt, missing tests, tight coupling, unclear naming, etc. If none, say "None identified".
- **test_coverage**: Describe what's tested and how. If no tests exist, say "No tests" and note what should be tested.
- **dependencies**: Bullet list of external packages and internal modules this directory depends on.
- **functionality**: Bullet list of capabilities this directory provides to other parts of the project.
- **files**: Markdown table with `| File | Description |` header. One row per file.

### 7. Progress tracking

- Use TaskCreate at the start to create one task per directory that needs work
- Update tasks to `in_progress` when launching the subagent, `completed` when done
- After each depth level completes, report progress: "Depth 3 complete (4/12 directories done)"
- Use the same `git_ref` and `repo` for all `upsert_context` calls in one session
