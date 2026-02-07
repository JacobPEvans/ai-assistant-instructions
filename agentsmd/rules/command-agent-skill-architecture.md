# Agent-Skill Architecture

Standardized two-tier architecture for organizing complex workflows in Claude Code.

## Purpose

Provides clear separation of concerns between:

- **Sub-Agents**: Specialized task execution
- **Skills**: Reusable canonical patterns (auto-create slash commands via plugins)

This architecture prevents code/logic duplication and ensures maintainability.

## The Two Tiers

### Tier 1: Sub-Agents (`.claude/agents/`)

**What**: Specialized workers that perform focused, well-defined tasks.

**Responsibilities**:

- Execute a single cohesive task (analysis, transformation, sync, etc.)
- Reference skills for canonical patterns
- Generate detailed reports/outputs
- Handle edge cases and error scenarios

**What agents should NOT do**:

- Duplicate logic from skills (reference them instead)
- Try to do too many things (single responsibility)

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

**Reference Skill**: the thing-pattern skill

Apply patterns from skill...

### Step 2: Do Next Thing

More instructions...

## Output Format

Detailed output structure...
```

### Tier 2: Skills (Plugin Skills + `agentsmd/skills/`)

**What**: Canonical patterns and rules for specific tasks. Plugin skills auto-create slash commands.

**Responsibilities**:

- Document the "right way" to do something
- Provide decision trees and classification rules
- Define patterns that multiple agents use
- Serve as single source of truth for a pattern

**What skills should NOT do**:

- Execute complex operations (that's for agents)
- Be overly specific to one use case

**Example structure**:

```markdown
---
name: skill-name
description: Pattern description
---

# Pattern Name

Brief description.

## Purpose

Single source of truth for...

## Pattern/Rules

Detailed classification rules, decision trees, examples...

## Examples

Specific examples of applying the pattern...

## Best Practices

Guidelines for using this pattern...
```

## Responsibility Boundaries

| Question | Answer |
| --- | --- |
| **How do I do this task?** | Sub-Agent |
| **What's the right pattern?** | Skill |

### Example: Permission Sync

**Skill** (`/sync-permissions` - auto-creates slash command):

```text
The pattern:
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
- Read-only operations -> ALLOW
- Modifications -> ASK
- Destructive operations -> DENY
[detailed rules...]
```

## Referencing Between Tiers

### Agents -> Skills

```markdown
**Reference Skill**: the pattern-name skill

Apply pattern-name rules:
- Rule 1
- Rule 2
```

### Skills -> Related Skills

```markdown
## Related Skills

- permission-safety-classification skill - Classification patterns
- permission-deduplication skill - Deduplication patterns
```

## Directory Structure

```text
agentsmd/
├── skills/                # Canonical patterns
│   ├── permission-safety-classification/
│   │   └── SKILL.md
│   ├── permission-deduplication/
│   │   └── SKILL.md
│   └── ...
└── rules/                 # Meta: Architecture docs
    └── command-agent-skill-architecture.md

.claude/
└── agents/                # Task executors
    ├── permissions-analyzer.md
    ├── permissions-syncer.md
    └── ...
```

## Best Practices

### Sub-Agents

1. **Single responsibility**: One well-defined task
2. **Reference skills**: Don't duplicate canonical patterns
3. **Detailed output**: Return comprehensive reports
4. **Clear integration**: Document how/when invoked

### Skills

1. **Reusable**: Multiple agents should use it
2. **Canonical**: Single source of truth for a pattern
3. **Examples-rich**: Show concrete applications
4. **Decision trees**: Help with classification/choices

## Anti-Patterns

### Agent duplicates skill logic

```markdown
## Step 2: Classify Permission

If permission is read-only:
  - list, ls, show -> ALLOW
If permission modifies:
  - update, set -> ASK
[duplicating safety classification skill...]
```

**Fix**: Reference the skill instead:

```markdown
## Step 2: Classify Permission

**Reference Skill**: the permission-safety-classification skill

Apply classification rules from skill.
```

### Skill is too specific

```markdown
# Sync Permissions for Claude Settings

This skill explains how to sync Claude permissions...
[only useful for one agent]
```

**Fix**: Make skill generic about permission deduplication, not specific to one agent.

## Related Documentation

- Skills Documentation (code.claude.com) - Official Anthropic docs
- Sub-Agents Documentation (code.claude.com) - Official Anthropic docs
- worktree-management skill - Example skill
