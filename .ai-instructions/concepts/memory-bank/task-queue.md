# Task Queue

This file is the orchestrator's input source. Tasks are added here and processed autonomously.

See [Autonomous Orchestration](../autonomous-orchestration.md) for the full system design.

## Queue Format

Tasks follow a strict format for machine parsing:

```markdown
### TASK-XXX: [Title]
- **Status**: pending | in_progress | blocked | completed
- **Priority**: critical | high | medium | low
- **Assigned**: [Subagent name or "orchestrator"]
- **Dependencies**: [TASK-XXX, TASK-YYY] or "none"
- **Context Files**:
  - [file path 1]
  - [file path 2]
- **Success Criteria**:
  - [ ] Criterion 1
  - [ ] Criterion 2
- **Notes**: [Any additional context]
```

## Active Tasks

<!-- Add new tasks below this line -->

### TASK-001: Implement SessionStart Hook System

- **Status**: pending
- **Priority**: high
- **Assigned**: orchestrator
- **Dependencies**: none
- **Context Files**:
  - .claude/commands/load-context.md
  - .ai-instructions/concepts/memory-bank/active-context.md
- **Success Criteria**:
  - [ ] Create `.claude/hooks/session-start.sh` script
  - [ ] Hook auto-loads memory-bank context on new session
  - [ ] Hook validates project prerequisites (node, npm, etc.)
  - [ ] Hook checks for uncommitted changes and alerts
  - [ ] Document hook installation in CLAUDE.md
- **Notes**: Replace manual /load-context with automatic session initialization.
  Research Claude Code hooks API for proper implementation.

### TASK-002: Custom Subagent Model Routing

- **Status**: pending
- **Priority**: medium
- **Assigned**: orchestrator
- **Dependencies**: none
- **Context Files**:
  - .ai-instructions/subagents/README.md
  - .ai-instructions/_shared/subagent-contract.md
- **Success Criteria**:
  - [ ] Define model routing rules in `_shared/model-routing.md`
  - [ ] Map subagent complexity to model tiers (Large/Medium/Small)
  - [ ] Add cost-awareness guidelines (prefer smaller models when sufficient)
  - [ ] Document model selection criteria
  - [ ] Update subagent contract with model routing reference
- **Notes**: Enable intelligent model selection based on task complexity.
  Consider: web-researcher→small, coder→medium, security-auditor→large.

### TASK-000: Example Task (Template)

- **Status**: pending
- **Priority**: medium
- **Assigned**: orchestrator
- **Dependencies**: none
- **Context Files**:
  - README.md
- **Success Criteria**:
  - [ ] Task completed successfully
- **Notes**: This is a template task for reference

## Completed Tasks

<!-- Completed tasks are moved here with completion timestamp -->

## Task Lifecycle

```mermaid
stateDiagram-v2
    [*] --> pending: Task Created
    pending --> in_progress: Orchestrator Assigns
    in_progress --> blocked: Dependency Missing
    blocked --> in_progress: Dependency Resolved
    in_progress --> completed: All Criteria Met
    completed --> [*]: Archived
```

## Priority Guidelines

| Priority | Criteria | Response Time |
|----------|----------|---------------|
| critical | Security issue, production down | Immediate |
| high | Blocking other work, PR feedback | Same session |
| medium | Normal development work | Next available |
| low | Nice to have, tech debt | When convenient |

## Parallel Execution

Per [Parallelism](../parallelism.md), independent tasks can run simultaneously:

```text
TASK-001 (pending, no deps) ─┬─► Run in parallel
TASK-002 (pending, no deps) ─┘
TASK-003 (pending, deps: TASK-001) ─► Wait for TASK-001
```
