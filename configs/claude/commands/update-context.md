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

```bash
git rev-parse --short HEAD        # git_ref
git remote get-url origin         # derive repo name (owner/repo)
git rev-parse --show-toplevel     # project_root
```

### 2. Check context status

If `$ARGUMENTS` specifies a directory, skip to step 4.

Call `check_context_status` with the project root. Returns:

- **needs_creation** — directories with no stored context
- **needs_deletion** — orphaned contexts (directory deleted or gitignored)
- **needs_update** — contexts where the stored `git_ref` is behind HEAD

### 3. Report findings

Present the three lists to the user as a summary table. For orphaned contexts, note that the user must manually remove files from `.sudo-context/`.

### 4. Group by depth and process with parallel subagents

Combine `needs_update` and `needs_creation` into a single work list. Sort by path depth, **deepest first** (`a/b/c` before `a/b` before `a`). Group directories at the same depth level.

For each depth level, starting from the deepest:

1. Create a **TaskCreate** entry for each directory at that depth level
2. Launch one **Task subagent** (`subagent_type: "general-purpose"`) per directory — all subagents at the same depth run **in parallel** (multiple Task tool calls in one message)
3. **Wait** for all subagents at that depth to complete before the next (shallower) level
4. Mark tasks completed as subagents finish

Each subagent receives `project_root`, `repo`, `git_ref`, and the target directory.

#### For stale directories (needs_update):

1. Call `query_context` to get existing sections
2. Run `git diff <stored_git_ref>..HEAD -- <directory>` to see what changed
3. Read directory files with Glob and Read
4. Decide which of the 8 sections need updating based on the diff
5. Call `upsert_context` with only changed sections (merging preserves the rest)

#### For missing directories (needs_creation):

1. Glob to list files, Read key files
2. Generate all 8 required sections
3. Call `upsert_context` with all sections

### 5. Section writing guidelines

- **description**: One sentence. Be specific.
- **purpose**: 2-3 sentences. Why it exists and how it fits.
- **strengths**: Bullet list of what works well.
- **weaknesses**: Bullet list. Be honest. "None identified" if clean.
- **test_coverage**: What's tested, how. "No tests" if none.
- **dependencies**: Bullet list of external and internal deps.
- **functionality**: Bullet list of capabilities provided externally.
- **files**: Markdown table `| File | Description |`, one row per file.

### 6. Progress tracking

- Use TaskCreate at the start for one task per directory
- Update tasks to `in_progress` when launching, `completed` when done
- Report progress after each depth level: "Depth 3 complete (4/12 directories done)"
