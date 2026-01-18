# Subagent Parallelization

When running multiple subagents, follow the subagent-batching skill for patterns.

## Key Principles

- Launch subagents in a **single message** to run in parallel
- Don't launch sequentially unless there are true dependencies
- Use appropriate model tiers (Haiku/Sonnet for most tasks, Opus only when needed)
- Batch large sets and validate between batches
- Handle failures gracefully—one failure shouldn't block the rest
