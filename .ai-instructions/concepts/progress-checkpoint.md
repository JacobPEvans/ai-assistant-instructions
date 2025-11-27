# Concept: Progress Checkpoint System

This document defines the cross-session context bridging pattern inspired by
[Anthropic's research on long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents).

## Core Problem

AI agents work in discrete sessions with no memory between context windows. Each new session begins with zero knowledge
of previous work. Complex projects spanning hours or days require a reliable mechanism to bridge these gaps.

## Solution: Progress Checkpoints

The progress checkpoint is a structured file that captures the complete state of work at any point, enabling any future
agent to immediately understand and resume work without re-reading the entire codebase.

## Checkpoint File Location

```text
.ai-instructions/concepts/memory-bank/progress-checkpoint.md
```

## Checkpoint Structure

```markdown
# Progress Checkpoint

**Last Updated**: [ISO 8601 timestamp]
**Session ID**: [Unique identifier for traceability]
**Phase**: [Current workflow phase: research | planning | testing | implementation | finalization]

## Executive Summary

[2-3 sentences: What was accomplished, what's in progress, what's blocked]

## Current Task

**Task ID**: TASK-XXX
**Objective**: [Clear goal]
**Status**: [in_progress | blocked | near_complete]
**Completion**: [X]%

### Completed Steps

- [x] Step 1: [What was done]
- [x] Step 2: [What was done]

### Remaining Steps

- [ ] Step 3: [What needs to be done]
- [ ] Step 4: [What needs to be done]

### Active Blockers

[List any blockers, or "None"]

## Files Modified This Session

| File | Changes | Status |
|------|---------|--------|
| [path] | [description] | modified/created/deleted |

## Key Decisions Made

| Decision | Rationale | Confidence | Reversible |
|----------|-----------|------------|------------|
| [choice] | [why] | [X]% | Yes/No |

## Context for Next Session

### Must Read

- [file1.md] - [why it's essential]
- [file2.ts] - [why it's essential]

### Can Skip

- [file3.md] - [already processed, summarized below]

### Summary of Skippable Content

[Condensed summary of files that don't need re-reading]

## Recovery Instructions

If resuming from this checkpoint:

1. [First action to take]
2. [Second action to take]
3. [Validation step before continuing]

## Git State

**Branch**: [current branch]
**Last Commit**: [hash] - [message]
**Uncommitted Changes**: [Yes/No - if yes, list files]
**Ahead/Behind Remote**: [X ahead, Y behind]
```

## When to Create Checkpoints

| Trigger | Checkpoint Type |
|---------|----------------|
| Workflow phase transition | Full checkpoint |
| Before complex operation | Pre-operation checkpoint |
| Every 30 minutes of work | Incremental checkpoint |
| Before context compaction | Pre-compaction checkpoint |
| On `/checkpoint` command | Manual checkpoint |
| On `/handoff` command | Session handoff checkpoint |
| On error recovery | Error state checkpoint |

## Checkpoint Types

### Incremental Checkpoint

Lightweight, captures only changes since last checkpoint:

```markdown
# Incremental Checkpoint

**Parent Checkpoint**: [timestamp of last full checkpoint]
**Delta Since Parent**: [what changed]
**Files Touched**: [list]
**Decisions Made**: [list]
```

### Session Handoff Checkpoint

Complete state for session transitions (used by `/handoff` command):

```markdown
# Session Handoff Checkpoint

[Full checkpoint structure above]

## Handoff Notes

**Recommended Next Action**: [specific first action for next session]
**Estimated Remaining Work**: [rough scope]
**Risk Areas**: [what might go wrong]
**Dependencies**: [external blockers]
```

## Integration with Memory Bank

The progress checkpoint complements other memory-bank files:

| File | Purpose | Checkpoint Relationship |
|------|---------|------------------------|
| `active-context.md` | Current working state | Checkpoint is MORE detailed |
| `progress-tracking.md` | High-level milestones | Checkpoint is MORE granular |
| `task-queue.md` | Task backlog | Checkpoint tracks CURRENT task deeply |
| `project-brief.md` | Project overview | Checkpoint assumes this is read |

## Automatic Checkpoint Behavior

The orchestrator automatically creates checkpoints:

1. **Pre-Subagent Call**: Before spawning any subagent
2. **Post-Subagent Return**: After receiving subagent results
3. **On Error**: When any error occurs (enables recovery)
4. **On Timeout Warning**: When approaching context limits
5. **On Phase Transition**: When moving between workflow steps

## Checkpoint Validation

Before resuming from a checkpoint, validate:

```text
1. Git state matches checkpoint expectations
2. Modified files exist and have expected content
3. No conflicting work from other sessions
4. Dependencies are still available
5. External APIs are still accessible
```

If validation fails, trigger [Self-Healing](./self-healing.md) reconciliation.

## Context Efficiency

Checkpoints enable aggressive context optimization:

1. **Skip Re-Reading**: Files summarized in checkpoint don't need re-reading
2. **Targeted Loading**: Only load files listed in "Must Read"
3. **Decision Reuse**: Don't re-evaluate decisions already made
4. **State Trust**: Trust git state over re-analyzing code

## Example Checkpoint

```markdown
# Progress Checkpoint

**Last Updated**: 2025-01-15T14:30:00Z
**Session ID**: sess_abc123
**Phase**: implementation

## Executive Summary

Implemented user authentication module with JWT tokens. Login endpoint complete and tested.
Registration endpoint 80% complete, needs email validation. Blocked on SMTP configuration.

## Current Task

**Task ID**: TASK-042
**Objective**: Implement user authentication system
**Status**: in_progress
**Completion**: 70%

### Completed Steps

- [x] Created auth module structure (src/auth/)
- [x] Implemented JWT token generation
- [x] Created login endpoint with tests
- [x] Created registration endpoint (partial)

### Remaining Steps

- [ ] Add email validation to registration
- [ ] Configure SMTP for verification emails
- [ ] Add password reset flow
- [ ] Integration tests

### Active Blockers

- SMTP credentials not available in environment

## Files Modified This Session

| File | Changes | Status |
|------|---------|--------|
| src/auth/jwt.ts | Token generation utilities | created |
| src/auth/login.ts | Login endpoint | created |
| src/auth/register.ts | Registration (partial) | created |
| tests/auth/login.test.ts | Login tests (passing) | created |

## Key Decisions Made

| Decision | Rationale | Confidence | Reversible |
|----------|-----------|------------|------------|
| Use JWT over sessions | Stateless, scales better | 90% | Yes |
| bcrypt for passwords | Industry standard | 95% | No (data migration) |
| 15-min token expiry | Balance security/UX | 75% | Yes |

## Context for Next Session

### Must Read

- src/auth/register.ts - Continue implementation
- .env.example - Understand required SMTP vars

### Can Skip

- src/auth/jwt.ts - Complete, well-documented
- src/auth/login.ts - Complete, tested

### Summary of Skippable Content

JWT module exports `generateToken(userId)` and `verifyToken(token)`.
Login accepts POST /auth/login with {email, password}, returns {token, user}.

## Recovery Instructions

If resuming from this checkpoint:

1. Check if SMTP_HOST is now in environment
2. If yes: Complete email validation in register.ts
3. If no: Queue SMTP configuration task, continue with password reset

## Git State

**Branch**: feature/user-auth
**Last Commit**: a1b2c3d - feat(auth): add login endpoint with JWT
**Uncommitted Changes**: Yes - src/auth/register.ts
**Ahead/Behind Remote**: 3 ahead, 0 behind
```

## See Also

| Related | Purpose |
|---------|---------|
| [Autonomous Orchestration](./autonomous-orchestration.md) | Checkpoint integration |
| [Self-Healing](./self-healing.md) | Checkpoint recovery |
| [Memory Bank](./memory-bank/README.md) | Context persistence |
| [Workflow Transitions](../commands/workflow-transitions.md) | Phase-based checkpoints |
