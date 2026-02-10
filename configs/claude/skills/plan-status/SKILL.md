---
name: plan-status
description: Show plan progress, find incomplete plans, and identify the next plan to implement. Use when asked about plan status, progress, or what to work on next.
argument-hint: "[plans directory path]"
allowed-tools: Read, Glob, Grep
---

Analyze the plans directory to report progress and identify the next plan to implement.

Use `$ARGUMENTS` as the plans directory if provided, otherwise default to `plans/`.

## How to determine plan status

Read `plans/.context.md` which contains the master list of all plans with their completion status and dependency order.

1. **Completed plans** have `~~DONE~~` next to their entry in the `.context.md` files table.
2. **Completed plans** also have `✅ COMPLETE` in their plan file title (line 1).
3. **Incomplete plans** lack both markers.

## Steps

1. Read `plans/.context.md` to get the full plan list, dependency graph, and completion status.
2. Identify all plans NOT marked `~~DONE~~` in the files table.
3. For each incomplete plan, read the first line of the plan file to confirm it does not contain `✅ COMPLETE`.
4. Check the dependency graph in `.context.md` to determine which incomplete plans have all dependencies satisfied (i.e., all plans they depend on are marked done).
5. Among the eligible plans (incomplete with all deps met), pick the one with the highest priority from the TODO table, or the lowest plan number if priorities are equal.

## Output Format

Report the following:

### Progress
- Total plans: X
- Completed: Y
- Remaining: Z

### Ready to Implement (deps satisfied)
List each eligible plan with its filename and description.

### Blocked (deps not yet met)
List each blocked plan and what it's waiting on.

### Next Plan
Recommend the single best plan to implement next, with rationale.
