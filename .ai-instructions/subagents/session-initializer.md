# Subagent: Session Initializer

The Session Initializer is a specialized subagent that handles the **first context window** of any session. It runs
before the main orchestrator takes over, ensuring all necessary context is loaded and the environment is validated.

This pattern is inspired by [Anthropic's research on effective harnesses](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
which recommends "a different prompt for the very first context window."

## Header

| Field | Value |
|-------|-------|
| Model Tier | Small |
| Context Budget | 5k tokens |
| Write Permissions | Memory-bank files only |
| Timeout | 2 min |
| User Interactive | No |

## Purpose

Unlike regular subagents that perform tasks, the Session Initializer **prepares the environment** for all subsequent
work. It is the critical bridge between sessions, ensuring no context is lost across context windows.

## Invocation

The Session Initializer runs automatically:

1. **On new session start** (via SessionStart hook)
2. **After context compaction** (when context overflows)
3. **On explicit `/resume` command**

## Responsibilities

### 1. Checkpoint Recovery

```text
1. Check if progress-checkpoint.md exists
2. If exists: Parse last checkpoint
3. Validate git state matches checkpoint
4. Load "Must Read" files into context
5. Skip files marked as "Can Skip"
6. Apply summarized knowledge from checkpoint
```

### 2. Environment Validation

```text
1. Verify project prerequisites (node, npm, etc.)
2. Check for uncommitted changes
3. Validate branch state (ahead/behind remote)
4. Confirm required environment variables exist
5. Test external API connectivity if needed
```

### 3. Context Preparation

```text
1. Load project-brief.md (always)
2. Load technical-context.md (always)
3. Load active task from task-queue.md
4. Load relevant checkpoint data
5. Prepare handoff summary for orchestrator
```

### 4. State Reconciliation

If checkpoint state doesn't match reality:

```text
1. Trust file system state over checkpoint
2. Log discrepancy for review
3. Update checkpoint to reflect current state
4. Prepare reconciliation notes for orchestrator
```

## Input Contract

```markdown
## Session Initialization Request

**Trigger**: [new_session | context_overflow | explicit_resume]
**Previous Session ID**: [ID or "none"]
**Expected Branch**: [branch name or "any"]
**Required Validations**: [list of checks]
```

## Output Contract

```markdown
## Session Initialization Result

**Status**: ready | needs_attention | blocked
**Session ID**: [new unique ID]
**Previous Session**: [ID or "none"]

### Environment Status

| Check | Result | Notes |
|-------|--------|-------|
| Git state | ✓/✗ | [details] |
| Prerequisites | ✓/✗ | [details] |
| Uncommitted changes | ✓/✗ | [details] |
| Remote sync | ✓/✗ | [details] |

### Context Loaded

- [file1.md] - [summary]
- [file2.md] - [summary]

### Active Task

**Task ID**: TASK-XXX
**Status**: [from checkpoint]
**Completion**: [X]%
**Next Action**: [specific first action]

### Reconciliation Notes

[Any discrepancies found and how they were resolved]

### Handoff to Orchestrator

[Concise briefing for the orchestrator to begin work immediately]
```

## Decision Matrix

| Situation | Action |
|-----------|--------|
| No checkpoint exists | Start fresh, create initial checkpoint |
| Checkpoint valid, git matches | Resume from checkpoint |
| Checkpoint valid, git ahead | Update checkpoint with new commits |
| Checkpoint valid, git diverged | Trust git, reconcile checkpoint |
| Uncommitted changes present | Alert in output, proceed cautiously |
| Prerequisites missing | List missing, mark as `needs_attention` |
| Environment vars missing | List missing, mark as `blocked` |

## Failure Modes

| Failure | Recovery |
|---------|----------|
| Checkpoint corrupted | Start fresh, log warning |
| Git state unrecoverable | Alert user, halt initialization |
| Prerequisites install fails | Document, mark as blocked |
| Memory-bank missing | Create default structure |

## Integration Points

### With SessionStart Hook

The Session Initializer is invoked by the SessionStart hook:

```bash
# .claude/hooks/session-start.sh (example)
#!/bin/bash
# This hook triggers the Session Initializer subagent
echo "Initializing session..."
# The hook itself just triggers; the subagent does the work
```

### With Orchestrator

After initialization:

```text
Session Initializer → Handoff Summary → Orchestrator
                   → Active Task      →
                   → Context Loaded   →
```

### With Progress Checkpoint

```text
Read: progress-checkpoint.md
Write: progress-checkpoint.md (update session ID, validation status)
```

## Example Output

```markdown
## Session Initialization Result

**Status**: ready
**Session ID**: sess_20250115_143000
**Previous Session**: sess_20250115_120000

### Environment Status

| Check | Result | Notes |
|-------|--------|-------|
| Git state | ✓ | Branch: feature/auth, 3 ahead |
| Prerequisites | ✓ | Node 20.x, npm 10.x |
| Uncommitted changes | ✓ | 1 file (src/auth/register.ts) |
| Remote sync | ✓ | Up to date with origin |

### Context Loaded

- project-brief.md - Authentication system for web app
- technical-context.md - Node.js, Express, PostgreSQL
- progress-checkpoint.md - 70% complete on TASK-042

### Active Task

**Task ID**: TASK-042
**Status**: in_progress
**Completion**: 70%
**Next Action**: Complete email validation in register.ts

### Reconciliation Notes

None - checkpoint matches git state exactly.

### Handoff to Orchestrator

Ready to continue TASK-042 (user authentication). Login complete, registration
needs email validation. SMTP credentials now available in environment. Proceed
with email validation implementation, then password reset flow.
```

## See Also

| Related | Purpose |
|---------|---------|
| [Progress Checkpoint](../concepts/progress-checkpoint.md) | Checkpoint format |
| [Context Compactor](./context-compactor.md) | Context management |
| [Autonomous Orchestration](../concepts/autonomous-orchestration.md) | Post-initialization workflow |
| [Subagent Contract](../_shared/subagent-contract.md) | Standard contract |
