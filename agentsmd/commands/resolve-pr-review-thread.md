---
title: "Resolve PR Review Thread"
description: "Resolve PR review threads with systematic implementation or explanation, then mark as resolved"
model: sonnet
type: "command"
version: "3.0.0"
allowed-tools: Task, TaskOutput, Bash(gh:*)
think: true
---

## Resolve PR Review Threads

Orchestrates resolution of GitHub PR review comments by delegating to the specialized `thread-resolver` subagent.

**Two resolution paths:**

1. **Technical**: Implement fix → Commit → Reply → Mark resolved
2. **Explanation**: Reply with rationale → Mark resolved

## Usage

```bash
/resolve-pr-review-thread              # Current PR only
/resolve-pr-review-thread all          # All open PRs with unresolved comments (batch size: 5)
```

## Workflow

### Single PR Mode

1. Get current PR number from context
2. Check for unresolved review threads
3. Launch `thread-resolver` subagent for this PR
4. Monitor completion and verify all threads marked resolved

### All Mode

1. List all open PRs in current repository
2. Filter PRs with unresolved threads
3. Launch parallel subagents in batches of 5
4. Wait for batch completion before starting next batch
5. Verify all threads marked resolved across all PRs

## Related

- **Agent**: [`thread-resolver`](../agents/thread-resolver.md) - Detailed comment interpretation and resolution logic
- **Rules**: [PR Comment Limits](../rules/pr-comment-limits.md) - 50-comment limit enforcement
- **Principles**: [Subagent Parallelization](../rules/subagent-parallelization.md) - Batching strategy
