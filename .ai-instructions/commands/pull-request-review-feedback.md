# Pull Request Review Feedback Management

Workflow for addressing PR review comments and resolving conversations.

> **Full Query Library**: [GitHub GraphQL Snippets](../_shared/snippets/github-graphql.md)

## Critical Rules

1. **NEVER suppress linters** - No `# noqa`, `# type: ignore`, `# pylint: disable`, or config changes
2. **Fix root cause** - Always fix the actual issue, not the symptom
3. **Resolve after fixing** - Only mark resolved AFTER implementing the fix

See [Hard Protections](../concepts/hard-protections.md) for why these rules are inviolable.

## Two-Step Process

### Step 1: Get Review Comments

```bash
gh api graphql -f query='
{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: PR_NUMBER) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          comments(first: 10) {
            nodes { body path line }
          }
        }
      }
    }
  }
}'
```

**Alternative (REST):**

```bash
gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments
```

### Step 2: Resolve Conversations

After fixing the issue:

```bash
gh api graphql -f query='
mutation {
  resolveReviewThread(input: {threadId: "PRRT_..."}) {
    thread { id isResolved }
  }
}'
```

## Batch Resolution

```bash
# Get unresolved IDs
UNRESOLVED=$(gh api graphql -f query='...' | jq -r \
  '.data.repository.pullRequest.reviewThreads.nodes[]
   | select(.isResolved == false) | .id')

# Resolve each
for id in $UNRESOLVED; do
  gh api graphql -f query="
  mutation {
    resolveReviewThread(input: {threadId: \"$id\"}) {
      thread { isResolved }
    }
  }"
done
```

## Variables

| Variable | Example | Where to Find |
|----------|---------|---------------|
| OWNER | JacobPEvans | GitHub URL path |
| REPO | ai-assistant-instructions | GitHub URL path |
| PR_NUMBER | 42 (integer) | PR URL |
| THREAD_ID | PRRT_kwDOPLZ... | Step 1 response |

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Empty reviewThreads | Verify PR exists |
| Mutation fails | Check THREAD_ID format (PRRT_...) |
| Variables not substituting | Escape inner quotes: `\"$VAR\"` |

## See Also

- [GitHub GraphQL Snippets](../_shared/snippets/github-graphql.md)
- [PR Resolver Subagent](../subagents/pr-resolver.md)
- [Hard Protections](../concepts/hard-protections.md)
- [Pull Request Command](./pull-request.md)
