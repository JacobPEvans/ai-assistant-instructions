# Claude Code Instructions

> **Start Here**: [AI Instructions Index](./.ai-instructions/INDEX.md)

## Quick Start

1. **Session auto-initializes** via SessionStart hook (loads checkpoint + validates environment)
2. **Need navigation?** See [INDEX.md](./.ai-instructions/INDEX.md)
3. **Starting a task?** Follow [5-Step Workflow](./.ai-instructions/INSTRUCTIONS.md#core-workflow)
4. **Manual context load?** Run `/load-context` if needed

## Key Commands

| Command | Purpose |
|---------|---------|
| `/load-context` | Load memory-bank state |
| `/commit` | Standardized commit |
| `/pull-request` | Create PR |
| `/review-docs` | Validate markdown |

## Key Concepts

| Concept | When to Use |
|---------|-------------|
| [Self-Healing](./.ai-instructions/concepts/self-healing.md) | Error recovery |
| [User Modes](./.ai-instructions/concepts/user-presence-modes.md) | Attended vs autonomous |
| [Hard Protections](./.ai-instructions/concepts/hard-protections.md) | Safety constraints |

## Settings

Claude Code settings: `.claude/settings.json`

## Hooks

This project uses Claude Code hooks for automatic session initialization:

| Hook | Trigger | Purpose |
|------|---------|---------|
| SessionStart | startup, resume, compact | Loads checkpoint, validates environment, shows task queue |

Hook script: `.claude/hooks/session-start.sh`

See [Session Initializer](./.ai-instructions/subagents/session-initializer.md) for the pattern this implements.

## See Also

- [Full Instructions](./.ai-instructions/INSTRUCTIONS.md)
- [Navigation Index](./.ai-instructions/INDEX.md)
- [Multi-Agent Patterns](./.ai-instructions/concepts/multi-agent-patterns.md)
