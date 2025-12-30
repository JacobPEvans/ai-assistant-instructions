---
title: "Subagent Batching"
description: "Canonical patterns for parallel subagent execution with 5-agent limit and batch validation"
version: "1.0.0"
author: "JacobPEvans"
---

<!-- markdownlint-disable-file MD013 -->

Standardized patterns for launching and managing parallel subagents. All commands that process multiple items should use these batching patterns.

## Purpose

Ensures efficient parallel processing while preventing token exhaustion, API rate limiting, and context overflow. Provides single source of truth for subagent limits and batching strategy.

## Critical Limit

**MAXIMUM 5 SUBAGENTS RUNNING CONCURRENTLY** - This is a hard limit across ALL commands.

### Why 5?

- Prevents token exhaustion in parent conversation
- Ensures each subagent gets adequate context
- Allows proper validation between batches
- Keeps API rate limits in check
- Based on testing showing higher counts cause failures

## When to Parallelize

**Use parallel subagents when**:

- Processing multiple independent items (PRs, issues, files)
- Tasks have no data dependencies between items
- Discovery phase is complete (you know all items upfront)
- Each item can succeed or fail independently

**Do NOT parallelize when**:

- Later items depend on earlier results
- Shared resources could cause conflicts
- You need to aggregate results before proceeding
- The total count is unknown upfront

## Launch Pattern

### Correct: Single Message, Multiple Tasks

Launch all subagents in **ONE message** with multiple Task tool calls.

```text
# In ONE message, launch 3 Task tools:
Task 1: Process item A
Task 2: Process item B
Task 3: Process item C

All three launch simultaneously in parallel.
```

### Incorrect: Sequential Messages

```text
# DON'T launch one at a time:
Message 1: Task for item A
[Wait for response]
Message 2: Task for item B
[Wait for response]

This defeats the purpose - sequential, not parallel.
```

## Batching Strategy

| Item Count | Approach |
| --- | --- |
| 1-5 | Launch all at once in single message |
| 6-10 | Batch of 5, wait for ALL to complete, validate, then next batch |
| 11+ | Same as above, strict batches of 5 with validation between each |

### Batch Execution Steps

1. **Launch batch** of MAX 5 subagents in parallel (single message)
2. **Wait for ALL** to complete using `TaskOutput` with `block=true`
3. **Validate each result** before proceeding
4. **Retry incomplete work** (max 2 retries per item)
5. **Only after validation**, start next batch of 5
6. **Never exceed 5** concurrent subagents

## Monitoring Completion

After launching subagents:

```bash
# Pattern for monitoring batch completion

# 1. Launch batch (collect agent IDs from response)
agent_ids=("a1b2c3d" "e4f5g6h" "i7j8k9l")

# 2. Wait for each to complete
for agent_id in "${agent_ids[@]}"; do
  # Use TaskOutput with block=true to wait for completion
  echo "Waiting for agent $agent_id..."
done

# 3. Validate all results
# 4. Proceed to next batch only if all succeeded
```

## Subagent Prompt Template

Each subagent prompt should include:

```text
[TASK]: Clear description of what to do

[CONTEXT]:
- Item: identifier or name
- Location: path or URL
- Current state: relevant status

[INSTRUCTIONS]:
1. Step 1
2. Step 2
3. Step 3

[CRITICAL RULES]:
- Rule 1
- Rule 2

[REPORT FORMAT]:
When complete, report:
- Status: SUCCESS/PARTIAL/FAILED
- Actions taken: list
- Issues encountered: list or "none"
```

## Error Handling

### Per-Item Failures

When a subagent fails on one item:

1. Log the failure with details
2. Mark item as "needs human review"
3. Continue processing other items in batch
4. Include in final failure summary

### Retry Strategy

| Attempt | Action |
| --- | --- |
| 1 | Normal execution |
| 2 | Retry with same parameters |
| 3 | Retry with simplified approach |

If item still fails after 3 attempts, mark as "needs human review" and continue with remaining items. Don't let one failure block everything.

## Final Report Template

```text
## [Command Name] Results

**Summary**: N items processed, N succeeded, N failed

### Succeeded (N)
- Item 1: brief description of what was done
- Item 2: brief description

### Partial (N)
- Item 3: what worked / what didn't

### Failed (N)
- Item 4: error reason
- Item 5: error reason

### Next Steps
- Any required follow-up actions
```

## Example Workflows

### Example 1: Process 3 PRs (All at Once)

```text
# All under 5-agent limit, launch all in one message

Step 1: Launch 3 pr-thread-resolver agents in single message
Step 2: Collect 3 agent IDs from response
Step 3: Use TaskOutput to wait for all 3 to complete
Step 4: Aggregate results
Step 5: Report summary
```

### Example 2: Process 8 PRs (Two Batches)

```text
# Over 5-agent limit, need batching

Batch 1:
- Launch 5 pr-thread-resolver agents in one message
- Wait for all 5 to complete with TaskOutput
- Validate all 5 succeeded

Batch 2:
- Launch remaining 3 agents in one message
- Wait for all 3 to complete
- Validate results

Final:
- Aggregate all 8 results
- Report summary
```

### Example 3: Process 15 PRs (Three Batches)

```text
# Significantly over limit, strict batching

Batch 1 (PRs 1-5):
- Launch 5 agents
- Wait for completion
- Validate

Batch 2 (PRs 6-10):
- Launch 5 agents
- Wait for completion
- Validate

Batch 3 (PRs 11-15):
- Launch 5 agents
- Wait for completion
- Validate

Final:
- Aggregate 15 results
- Report summary
```

## Commands Using This Skill

- `/fix-pr-ci all` - Fix CI on multiple PRs
- `/resolve-pr-review-thread all` - Resolve threads on multiple PRs
- `/sync-main all` - Sync main across multiple PR branches
- Any command processing multiple independent items

## Related Resources

- [Subagent Parallelization Rule](../../rules/subagent-parallelization.md) - Policy and rationale
- [Task Tool Documentation](https://docs.anthropic.com/claude/docs/tool-use) - Official Task tool reference

## Troubleshooting

### Issue: Parent conversation runs out of tokens

**Cause**: Too many concurrent subagents

**Solution**: Reduce batch size (never exceed 5)

### Issue: Some subagents don't complete

**Cause**: Context overflow or API rate limiting

**Solution**:

- Ensure batch size ≤ 5
- Add delays between batches if needed
- Use simpler prompts

### Issue: Results are inconsistent across batches

**Cause**: No validation between batches

**Solution**: Always validate batch results before starting next batch

## Best Practices

1. **Always respect the 5-agent limit** - Hard maximum, no exceptions
2. **Launch in single message** - Multiple Task calls in ONE message
3. **Validate between batches** - Don't proceed to next batch until current validates
4. **Handle failures gracefully** - One failure shouldn't block the rest
5. **Clear prompts** - Each subagent should have complete context
6. **Aggregate results** - Provide comprehensive final report
7. **Use TaskOutput blocking** - Wait for completion before validation
