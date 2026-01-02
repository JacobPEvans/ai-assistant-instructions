---
description: Merge local AI permission settings into repository-wide permissions
model: haiku
allowed-tools: Task, TaskOutput, TodoWrite, AskUserQuestion
---

# Sync Permissions

Scan local AI settings across all repos/worktrees, analyze permissions, and merge approved changes into repository permissions.

## Supported Tools

| AI Tool | Config Location | Sync Status |
| --- | --- | --- |
| Claude | `agentsmd/permissions/` | Fully supported |
| Gemini | `.gemini/permissions/` | Fully supported |
| Copilot | `.github/copilot-instructions.md` | Not yet supported (permissions are **not** synced) |

Currently, only Claude and Gemini permissions are discovered and synced. Copilot support is planned but not yet implemented.

## Workflow

### Phase 1: Discovery & Analysis

Invoke `permissions-analyzer` agent to scan home directory, classify permissions, and deduplicate against existing patterns.

**Currently scans:**

- Claude settings from `~/.claude/settings.local.json` in all repos/worktrees
- Gemini settings from `~/.gemini/settings.json` in all repos/worktrees

### Phase 2: User Approval

Review analysis report. Ask user to approve, modify, or cancel.

### Phase 3: Execution

**Only after approval**, invoke `permissions-syncer` agent to apply changes, sync across tools, and cleanup local files.

**Sync strategy:**

- Merge permissions using a union approach
- When same permission exists in both tools with different classifications, prioritize Claude classification
- When permission exists only in Gemini, preserve and propagate to Claude
- Result: identical permission sets across all supported tools

## Architecture

Command → Agent → Skill pattern:

- Agents: `permissions-analyzer`, `permissions-syncer`
- Skills: `permission-safety-classification`, `permission-deduplication`

See [Command/Agent/Skill Architecture](../rules/command-agent-skill-architecture.md).
