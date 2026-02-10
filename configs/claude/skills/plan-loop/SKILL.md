---
name: plan-loop
description: Automatically implement all remaining plans using ralph-loop. Loops through plans in dependency order, creating PRs for each.
allowed-tools: Bash, Read, Glob, Grep, Edit, Write, Skill
---

Start a ralph-loop that iterates through all incomplete plans, implementing them one at a time.

## Prerequisites

- A `plans/.context.md` file must exist in the current project
- The ralph-loop plugin must be enabled
- The repo must be on the default branch with a clean working tree

## Steps

1. **Verify preconditions:**
   - Confirm `plans/.context.md` exists
   - Run `git status` to ensure working tree is clean
   - Determine the default branch name (`main` or `master`)

2. **Check for remaining work:**
   - Run `/plan-status` to confirm there are incomplete plans with satisfied dependencies
   - If all plans are complete, report that and stop

3. **Start the ralph-loop** with the following invocation:

```
/ralph-loop "
You are implementing plans from the plans/ directory, one per iteration.

## Each iteration:

1. **Sync to latest:**
   - Check out the default branch and pull latest
   - Run git status to confirm clean state

2. **Find the next plan:**
   - Read plans/.context.md
   - Find the first plan in the files table that is NOT marked ~~DONE~~ and whose dependencies (from the dependency graph) are ALL marked ~~DONE~~
   - If no eligible plan exists, output <promise>ALL PLANS COMPLETE</promise> and stop

3. **Read and implement the plan:**
   - Read the full plan file
   - Create a feature branch: git checkout -b feat/<plan-name> (e.g., feat/19a-move-document-rpc)
   - Implement everything the plan specifies
   - Run all verification steps listed in the plan

4. **Mark the plan complete:**
   - Prepend the plan file title with ✅ COMPLETE (first heading line)
   - In plans/.context.md, add ~~DONE~~ around the description in the files table for this plan
   - In plans/.context.md, strike through the corresponding TODO entry if one exists

5. **Commit and create PR:**
   - Stage all changes
   - Commit with message: feat: Implement <plan-name> - <short description>
   - Push the branch
   - Create a PR with gh pr create, referencing the plan file in the description
   - Return to the default branch

6. **Verify iteration:**
   - Confirm you are back on the default branch
   - Confirm working tree is clean
   - Proceed to the next iteration
" --max-iterations 50 --completion-promise "ALL PLANS COMPLETE"
```

## Notes

- Each iteration implements exactly one plan
- Plans are selected in dependency order — blocked plans are skipped until their deps are done
- The loop terminates when all plans are complete or after 50 iterations
- Each plan gets its own feature branch and PR
- Use `/cancel-ralph` to stop the loop early if needed
