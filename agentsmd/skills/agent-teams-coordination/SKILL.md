---
name: agent-teams-coordination
description: Decision tree for choosing coordination mechanism
version: "1.0.0"
author: JacobPEvans
---

# Agent Teams Coordination

## Decision Tree

Choose the coordination mechanism based on your task structure:

| Scenario | Mechanism | Why |
| -------- | --------- | --- |
| Single focused task | Task tool directly | No overhead needed |
| Single task + specific subagent | Task tool with `subagent_type` | Built-in delegation |
| 2+ independent parallel tasks | dispatching-parallel-agents skill | Simple parallel execution |
| 2+ tasks needing peer communication | Agent Teams (native) | Full messaging + coordination |
| Autonomous continuous work | ralph-loop plugin | Sustained agent loop |
| Multi-repo parallel execution | Agent Teams + per-repo teammates | Distributed across worktrees |

## Key Constraints

**One teammate per worktree**: File write conflicts occur with multiple teammates in the same directory. Assign each worktree to a single team member.

**Message communication**: Use `type: "message"` for peer-to-peer communication.
Reserve `type: "broadcast"` for critical team-wide alerts only—broadcasting
duplicates messages to every teammate.

**Task limits**: Keep 5-6 tasks per teammate max for readability and token efficiency. Larger task lists become unwieldy.

## Feature Detection

Agent Teams is a native Claude Code feature—no setup required. Check if
available in your conversation. If unavailable, the system falls back to
subagent batching via the Task tool with explicit `subagent_type` parameters.

## References

- **Official API docs**: [code.claude.com/docs/en/agent-teams](https://code.claude.com/docs/en/agent-teams)
- **Parallel execution**: dispatching-parallel-agents skill (Superpowers plugin)
- **Autonomous loops**: ralph-loop, ralph-wiggum (Ralph Loop plugin)
- **Orchestration patterns**: agent-orchestration plugin
