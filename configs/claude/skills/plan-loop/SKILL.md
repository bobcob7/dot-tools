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
   - List open PRs: gh pr list --state open --json headRefName --jq '.[].headRefName'
   - Find the first plan in the files table that:
     - Is NOT marked ~~DONE~~
     - Does NOT have an open PR with branch feat/<plan-name>
     - Has all dependencies marked ~~DONE~~
   - If no eligible plan exists (all are either done or have open PRs), output <promise>ALL PLANS COMPLETE</promise> and stop

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

6. **Review the PR:**
   - Run gh pr review --approve with a summary of what was implemented and verified
   - Do NOT wait for checks — do NOT merge the PR — leave it for manual review

7. **Verify iteration:**
   - Return to the default branch
   - Confirm you are back on the default branch
   - Confirm working tree is clean
   - Proceed to the next iteration
" --max-iterations 50 --completion-promise "ALL PLANS COMPLETE"
```

## Notes

- Each iteration implements exactly one plan
- Plans are selected in dependency order — blocked plans are skipped until their deps are done
- Plans with open PRs are skipped (already in flight, awaiting manual merge)
- Dependent plans remain blocked until their dependency PRs are merged (making deps ~~DONE~~ on the default branch)
- Independent plans can be implemented in parallel across iterations while earlier PRs await merge
- The loop terminates when all plans are either done or have open PRs, or after 50 iterations
- Each plan gets its own feature branch and PR
- PRs are agent-reviewed but NOT auto-merged — they require manual review
- Use `/cancel-ralph` to stop the loop early if needed
