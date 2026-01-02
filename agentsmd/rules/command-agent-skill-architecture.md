# Command-Agent-Skill Architecture

Standardized three-tier architecture for organizing complex workflows in Claude Code.

## Purpose

Provides clear separation of concerns between:

- **Commands**: User-facing workflow orchestration
- **Sub-Agents**: Specialized task execution
- **Skills**: Reusable canonical patterns

This architecture prevents code/logic duplication and ensures maintainability.

## The Three Tiers

### Tier 1: Commands (`agentsmd/commands/`)

**What**: User-facing entry points that orchestrate workflows.

**Responsibilities**:

- Define the high-level workflow (phases, steps)
- Manage user interaction and approvals
- Invoke sub-agents at appropriate breakpoints
- Handle the "happy path" from start to finish

**What commands should NOT do**:

- Contain detailed implementation logic
- Duplicate patterns that belong in skills
- Perform complex operations directly (delegate to agents)

**Example structure**:

```markdown
---
description: Brief command summary
model: haiku
allowed-tools: Task, TaskOutput, TodoWrite, AskUserQuestion
---

# Command Name

Brief description of what this command does.

## Workflow

### Phase 1: Do Something

Invoke the `foo-analyzer` sub-agent to:
- Task 1
- Task 2
- Task 3

### Phase 2: User Approval

Ask user for approval...

### Phase 3: Execute

Invoke the `foo-syncer` sub-agent to:
- Apply changes
- Verify results
```

### Tier 2: Sub-Agents (`.claude/agents/`)

**What**: Specialized workers that perform focused, well-defined tasks.

**Responsibilities**:

- Execute a single cohesive task (analysis, transformation, sync, etc.)
- Reference skills for canonical patterns
- Generate detailed reports/outputs
- Handle edge cases and error scenarios

**What agents should NOT do**:

- Duplicate logic from skills (reference them instead)
- Try to do too many things (single responsibility)
- Make decisions that belong at command level

**Example structure**:

```markdown
---
name: agent-name
description: What this agent does
author: JacobPEvans
allowed-tools: [specific tools needed]
---

# Agent Name

Brief description.

## Purpose

What this agent accomplishes.

## Workflow

### Step 1: Do Thing

Detailed instructions...

**Reference Skill**: `agentsmd/skills/thing-pattern/SKILL.md`

Apply patterns from skill...

### Step 2: Do Next Thing

More instructions...

## Output Format

Detailed output structure...

## Integration Points

This agent is invoked by:
- `/command-name` - Phase X
- Other contexts...
```

### Tier 3: Skills (`agentsmd/skills/*/SKILL.md`)

**What**: Canonical patterns and rules for specific tasks.

**Responsibilities**:

- Document the "right way" to do something
- Provide decision trees and classification rules
- Define patterns that multiple agents/commands use
- Serve as single source of truth for a pattern

**What skills should NOT do**:

- Contain workflow orchestration (that's for commands)
- Execute operations (that's for agents)
- Be overly specific to one use case

**Example structure**:

```markdown
---
title: "Pattern Name"
description: "What this pattern covers"
version: "1.0.0"
author: "JacobPEvans"
---

# Pattern Name

Brief description.

## Purpose

Single source of truth for...

## Pattern/Rules

Detailed classification rules, decision trees, examples...

## Examples

Specific examples of applying the pattern...

## Commands Using This Skill

- `/command-name` - Purpose
- `agent-name` - How used

## Best Practices

Guidelines for using this pattern...
```

## Responsibility Boundaries

| Question | Answer |
| --- | --- |
| **What's the process?** | Command |
| **How do I do this task?** | Sub-Agent |
| **What's the right pattern?** | Skill |

### Example: Permission Sync

**Command** (`/sync-permissions`):

```text
The process:
1. Analyze permissions (invoke agent)
2. Get user approval
3. Apply changes (invoke agent)
```

**Agent** (`permissions-analyzer`):

```text
How to analyze:
1. Find all local settings files
2. Classify each permission (reference skill)
3. Deduplicate (reference skill)
4. Generate report
```

**Skill** (`permission-safety-classification`):

```text
The right pattern:
- Read-only operations → ALLOW
- Modifications → ASK
- Destructive operations → DENY
[detailed rules...]
```

## When to Use This Architecture

Use this three-tier pattern when:

- Workflow has multiple distinct phases
- Logic can be reused across commands
- User approval/interaction is needed
- Task is complex enough to benefit from separation

**Don't over-architect**: Simple commands with 1-2 steps don't need agents.

## Referencing Between Tiers

### Commands → Agents

```markdown
**Invoke agent**:

Use the Task tool to invoke the foo-analyzer agent (.claude/agents/foo-analyzer.md)
```

### Agents → Skills

```markdown
**Reference Skill**: `agentsmd/skills/pattern-name/SKILL.md`

Apply pattern-name rules:
- Rule 1
- Rule 2
```

### Skills → Related Skills

```markdown
## Related Skills

- [Permission Safety Classification](../skills/permission-safety-classification/SKILL.md) - Classification patterns
- [Permission Deduplication](../skills/permission-deduplication/SKILL.md) - Deduplication patterns
```

## Directory Structure

```text
agentsmd/
├── commands/              # Tier 1: User-facing commands
│   ├── sync-permissions.md
│   ├── init-worktree.md
│   └── ...
├── skills/                # Tier 3: Canonical patterns
│   ├── permission-safety-classification/
│   │   └── SKILL.md
│   ├── permission-deduplication/
│   │   └── SKILL.md
│   └── ...
└── rules/                 # Meta: Architecture docs
    └── command-agent-skill-architecture.md

.claude/
└── agents/                # Tier 2: Task executors
    ├── permissions-analyzer.md
    ├── permissions-syncer.md
    └── ...
```

## Best Practices

### Commands

1. **Be brief**: Delegate details to agents
2. **Define phases**: Clear breakpoints for user interaction
3. **Orchestrate**: Don't implement, invoke
4. **User-centric**: Focus on the user experience flow

### Sub-Agents

1. **Single responsibility**: One well-defined task
2. **Reference skills**: Don't duplicate canonical patterns
3. **Detailed output**: Return comprehensive reports
4. **Clear integration**: Document how/when invoked

### Skills

1. **Reusable**: Multiple commands/agents should use it
2. **Canonical**: Single source of truth for a pattern
3. **Examples-rich**: Show concrete applications
4. **Decision trees**: Help with classification/choices

## Anti-Patterns

### ❌ Command does too much

```markdown
## Steps

1. Find all files
2. Parse each file
3. Classify permissions
4. Deduplicate against patterns
5. Apply changes
6. Sync across tools
[50 more lines of detailed logic...]
```

**Fix**: Create agents for major phases, reference skills for patterns.

### ❌ Agent duplicates skill logic

```markdown
## Step 2: Classify Permission

If permission is read-only:
  - list, ls, show → ALLOW
If permission modifies:
  - update, set → ASK
[duplicating safety classification skill...]
```

**Fix**: Reference the skill instead:

```markdown
## Step 2: Classify Permission

**Reference Skill**: `permission-safety-classification/SKILL.md`

Apply classification rules from skill.
```

### ❌ Skill is too specific

```markdown
# Sync Permissions for Claude Settings

This skill explains how to sync Claude permissions...
[only useful for one command]
```

**Fix**: Make skill generic about permission deduplication, not specific to one command.

## Migration Guide

Converting existing long-form commands:

1. **Identify phases** in the command
2. **Extract implementation details** into agents (1 per major phase)
3. **Extract reusable patterns** into skills
4. **Update command** to be brief orchestration
5. **Test the flow** end-to-end

## Examples

Well-architected commands following this pattern:

- `/sync-permissions` - Three-phase workflow with two agents and two skills
- `/init-worktree` - References worktree-management skill
- `/fix-pr-ci` - Uses subagent-batching skill

## Related Documentation

- [Skills Documentation](https://code.claude.com/docs/en/skills) - Official Anthropic docs
- [Sub-Agents Documentation](https://code.claude.com/docs/en/sub-agents) - Official Anthropic docs
- [Worktree Management Skill](../skills/worktree-management/SKILL.md) - Example skill
