---
name: plan-create
description: Create an agent-executable implementation plan for a feature or project. Generates plans/.context.md and individual plan files.
argument-hint: "<feature description or project goal>"
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Create a set of implementation plans for `$ARGUMENTS`. Each plan must be self-contained and completable by a single agent in one context window.

## Steps

### 1. Understand the project

- Read `CLAUDE.md`, `.context.md`, and any existing `plans/` directory
- Identify the tech stack, conventions, and existing architecture
- If `plans/.context.md` already exists, read it and build on existing plans

### 2. Decompose the work

Break the feature into the smallest plans that:
- Can each be implemented in a single agent session
- Have clear input (what exists) and output (what to create/modify)
- Are ordered by dependency (no circular deps)

Use numbered plans: `01-short-name.md`, `02-short-name.md`, etc.

For complex features (5+ sub-tasks), create a **meta-plan** first (e.g., `15-frontend-breakdown.md`) that decomposes into sub-plans with letter suffixes (e.g., `15a-setup.md`, `15b-api-clients.md`).

### 3. Create `plans/.context.md`

```markdown
# Plans

## Purpose

[One sentence: what these plans implement]

## Functionality

- [Capability 1 these plans deliver]
- [Capability 2 these plans deliver]

## Dependency Order

\`\`\`
Phase 1: [Category]
  01-plan-name ──────────────┐
                              │
Phase 2: [Category]           │
  02-plan-name ──────────────┤ (depends on 01)
  03-plan-name ──────────────┘ (standalone)
\`\`\`

## Files

| File | Description |
|------|-------------|
| `01-plan-name.md` | Brief description of what this plan implements |
| `02-plan-name.md` | Brief description of what this plan implements |

## TODO

| Priority | Task |
|----------|------|
| P0 | Execute plan 01 (critical path) |
| P1 | Execute plans 02–03 (next phase) |
```

Conventions:
- Use ASCII art for the dependency graph, showing phases and arrows
- Mark completed plans with `~~DONE~~` in the Files table description
- Strike through completed TODO rows with `~~text~~`
- Use priorities P0 (critical), P1 (important), P2 (nice-to-have)

### 4. Create individual plan files

Each plan file follows this structure:

```markdown
# Plan NN: [Feature Name]

## Context

[What exists now and why this plan is needed. 2-3 sentences.]

**Depends on:** [Plan numbers or "Nothing"]
**Blocks:** [Plan numbers or "Nothing"]

## Current State

- [What relevant code/infrastructure already exists]
- [What's missing that this plan addresses]

## Scope

[One paragraph: exactly what this plan adds or changes]

## Files to Create/Modify

### `path/to/file.ext`

[What to do in this file]

\`\`\`language
// Key code snippets — enough for an agent to implement
\`\`\`

### `path/to/another-file.ext`

[Repeat for each file]

## Verification

\`\`\`bash
[Commands the agent should run to verify the implementation]
\`\`\`

## Acceptance Criteria

- [Specific, testable condition 1]
- [Specific, testable condition 2]
- [All verification commands pass]
```

### 5. Plan file conventions

**Code snippets:** Provide enough code for the agent to implement without guessing. Include:
- Function signatures with types
- Key logic (algorithms, error handling)
- Interface definitions
- SQL queries, proto definitions, config structures

**Don't include:**
- Boilerplate imports the agent can infer
- Every line of implementation — describe non-obvious parts, let the agent fill in the rest

**Verification section** should always include project-specific commands:
- Build/compile commands
- Lint commands
- Test commands (unit, integration, e2e as applicable)

**Acceptance criteria** should be specific enough that pass/fail is unambiguous.

### 6. Meta-plan structure (for complex features)

When a feature has 5+ sub-tasks, create a meta-plan:

```markdown
# Plan NN: [Feature] Breakdown

## Context

[Feature overview and why it needs decomposition]

**Depends on:** [Prerequisites]
**Blocks:** Nothing

## Sub-Plan Dependency Graph

\`\`\`
NNa-sub-plan ────────────────────┐
                                  │
NNb-sub-plan ────────────────────┤ (standalone)
                                  │
NNc-sub-plan ──── (depends on NNb)
                                  │
NNd-sub-plan ──── (depends on NNa, NNc)
\`\`\`

## Sub-Plans

| Plan | Title | Depends On |
|------|-------|------------|
| NNa | Sub-feature A | Nothing |
| NNb | Sub-feature B | Nothing |
| NNc | Sub-feature C | NNb |
| NNd | Sub-feature D | NNa, NNc |

## What's NOT in Scope

- [Explicit exclusion 1 — why]
- [Explicit exclusion 2 — why]
```

### 7. Review and validate

Before finishing:
- Verify every plan has a dependency path that starts from either "Nothing" or an already-completed plan
- Verify no circular dependencies exist
- Verify the `.context.md` dependency graph matches individual plan headers
- Verify each plan's scope is achievable in one agent session (rule of thumb: 1-5 files to create/modify)

## Notes

- Plans are designed for `/plan-loop` (automated ralph-loop) and `/plan-status` (progress checking)
- Completion is tracked by adding `✅ COMPLETE` to the plan title and `~~DONE~~` in `.context.md`
- Prefer many small plans over fewer large ones — agents work best with focused scope
- Keep plans in a flat `plans/` directory, using number prefixes for ordering
