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
3. Launch `pr-thread-resolver` subagent for this PR
4. **VERIFY** using the pr-thread-resolution-enforcement skill
5. Only report completion if verification returns 0 unresolved threads

### All Mode

1. List all open PRs in current repository
2. Filter PRs with unresolved threads
3. Launch parallel subagents in batches of 5
4. Wait for batch completion before starting next batch
5. **VERIFY EACH BATCH** using the pr-thread-resolution-enforcement skill
6. Only proceed to next batch if all PRs in current batch verify to 0 unresolved threads

## Verification Requirement

After the pr-thread-resolver agent completes (single or batch), MUST verify using the pr-thread-resolution-enforcement skill:

```bash
# Verification query (must return 0)
gh api graphql --raw-field \
  'query=query { repository(owner: "{OWNER}", name: "{REPO}") { pullRequest(number: {NUMBER}) { reviewThreads(last: 100) { nodes { isResolved } } } } }' \
  | jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)] | length'
```

**Success**: Verification returns `0` → Report completion
**Failure**: Verification returns > `0` → Abort with error message listing remaining threads

## Related

- **Skill**: pr-thread-resolution-enforcement - Canonical enforcement patterns (REQUIRED)
- **Skill**: github-graphql - GraphQL mutation patterns
- **Agent**: pr-thread-resolver - Detailed comment interpretation and resolution logic
- **Rule**: pr-comment-limits - 50-comment limit enforcement
- **Rule**: subagent-parallelization - Batching strategy
