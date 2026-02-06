# Agent Teams Setup

Enable Agent Teams to coordinate work across multiple teammates on parallel tasks.

## Enable Agent Teams

Agent Teams are experimental and disabled by default. Add to your `settings.json`:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

## Project Integration Notes

Agent Teams integrates seamlessly with our worktree-based development. Each teammate operates in its own isolated worktree, enabling parallel work without conflicts.

Commands that support agent teams include `/auto-claude`, `/fix-pr-ci all`,
`/resolve-pr-review-thread all`, and `/ready-player-one` (future). All other
commands work without requiring Agent Teams enabled via subagent-batching—there
are no breaking changes.

## Already Installed Related Plugins

This project includes plugins that power agent team workflows:

- **superpowers**: Dispatching-parallel-agents and subagent-driven-development patterns
- **agent-orchestration**: Multi-agent coordination infrastructure
- **ralph-loop**: Autonomous continuous development loop

## Official Documentation

For full Agent Teams API reference, troubleshooting, and advanced patterns, see: [code.claude.com/docs/en/agent-teams](https://code.claude.com/docs/en/agent-teams)

## Token Cost Consideration

Running N teammates costs approximately N times the tokens of single-agent
operation. Enable Agent Teams when parallelism benefits (faster completion,
reduced wall-clock time, better task isolation) outweigh token cost. For
sequential work, single-agent operation remains more efficient.
