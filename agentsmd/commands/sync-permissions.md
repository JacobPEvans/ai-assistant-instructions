---
description: Merge local AI permission settings into repository-wide permissions
model: haiku
allowed-tools: Task, TaskOutput, TodoWrite, AskUserQuestion
---

# Sync Permissions

Scan local AI settings across all repos/worktrees, analyze permissions, and merge approved changes into repository permissions.

## Workflow

### Phase 1: Discovery & Analysis

Invoke `permissions-analyzer` agent to scan home directory, classify permissions, and deduplicate against existing patterns.

### Phase 2: User Approval

Review analysis report. Ask user to approve, modify, or cancel.

### Phase 3: Execution

**Only after approval**, invoke `permissions-syncer` agent to apply changes, sync across tools, and cleanup local files.

## Architecture

Command → Agent → Skill pattern:

- Agents: `permissions-analyzer`, `permissions-syncer`
- Skills: `permission-safety-classification`, `permission-deduplication`

See [Command/Agent/Skill Architecture](../rules/command-agent-skill-architecture.md).
