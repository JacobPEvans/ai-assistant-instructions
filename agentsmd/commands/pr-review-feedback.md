---
description: How to programmatically resolve PR review threads using GitHub's GraphQL API
model: haiku
type: "command"
allowed-tools: Task, TaskOutput, Bash(gh:*)
---

# Resolving PR Review Conversations

Programmatically resolve PR review threads using GitHub's GraphQL API.

## Quick Workflow

1. Get unresolved threads: `gh api graphql` with `reviewThreads` query
2. For each thread: Implement fix or prepare explanation
3. Reply to comment with details (commit hash or rationale)
4. Mark resolved: `gh api graphql` mutation `resolveReviewThread`

## Detailed API Reference

See **[GitHub GraphQL Skill](../../.claude/skills/github-graphql/SKILL.md)** for:

- Complete query and mutation examples
- Node ID vs numeric ID handling
- Working examples from real PRs
- Error handling and troubleshooting
- Multi-line format requirements
- Reply patterns and verification

## Key Fields

| Operation | GraphQL Field | Purpose |
|-----------|---------------|---------|
| Get threads | `reviewThreads.nodes[].id` | Thread ID for resolution |
| Check status | `isResolved` | Skip resolved threads |
| Find comment | `path`, `line` | Where to find code |
| Get comment text | `comments.nodes[].body` | What reviewer said |
| Author | `comments.nodes[].author.login` | Who commented |

## Related

- **Skill**: [GitHub GraphQL API](../../.claude/skills/github-graphql/SKILL.md) - Canonical patterns
- **Rule**: [PR Comment Limits](../rules/pr-comment-limits.md) - 50-comment limit
- **Agent**: [thread-resolver](../agents/thread-resolver.md) - Detailed comment interpretation
