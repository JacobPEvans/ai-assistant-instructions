# Subagent Parallelization Patterns

Guide for launching parallel subagents in complex commands.

## When to Parallelize

Use parallel subagents when:

- Processing multiple independent items (PRs, issues, files)
- Tasks have no data dependencies between items
- Discovery phase is complete (you know all items upfront)
- Each item can succeed or fail independently

Do NOT parallelize when:

- Later items depend on earlier results
- Shared resources could cause conflicts
- You need to aggregate results before proceeding
- The total count is unknown upfront

## Launch Pattern

Launch all subagents in a **SINGLE message** with multiple Task tool calls.

### Correct Pattern

```text
# In ONE message, launch multiple Task tools:

Task 1: Process item A
Task 2: Process item B
Task 3: Process item C

[All three launch simultaneously]
```

### Incorrect Pattern

```text
# DON'T launch one at a time:

Message 1: Task for item A
[Wait for response]
Message 2: Task for item B
[Wait for response]

[Sequential - defeats the purpose]
```

## Batching Strategy

| Item Count | Approach |
| ---------- | -------- |
| 1-5 | Launch all at once |
| 6-10 | Launch all, monitor closely |
| 11-20 | Batch of 10, wait for completion, next batch |
| 21+ | Batch of 10 with explicit rate limiting |

### Why Batch?

- System resources are finite
- Too many concurrent agents can overwhelm APIs
- Better error isolation in smaller batches
- Easier to identify which batch caused issues

## Subagent Prompt Template

Each subagent prompt should include:

```text
[TASK]: {Clear description of what to do}

[CONTEXT]:
- Item: {identifier}
- Location: {path or URL}
- Current state: {relevant status}

[INSTRUCTIONS]:
1. {Step 1}
2. {Step 2}
3. {Step 3}

[CRITICAL RULES]:
- {Rule 1}
- {Rule 2}

[REPORT FORMAT]:
When complete, report:
- Status: {SUCCESS/PARTIAL/FAILED}
- Actions taken: {list}
- Issues encountered: {list or "none"}
```

## Monitoring Completion

After launching subagents:

1. Collect all agent IDs from Task tool responses
2. For each agent ID, use `TaskOutput` with `block=true`
3. Record the result from each
4. Aggregate results for final report

## Error Handling

### Per-Item Failures

When a subagent fails on one item:

1. Log the failure with details
2. Mark item as "needs human review"
3. Continue processing other items
4. Include in final failure summary

### Retry Strategy

| Attempt | Action |
| ------- | ------ |
| 1 | Normal execution |
| 2 | Retry with same parameters |
| 3 | Retry with simplified approach, then mark as "needs human review" |

After 3 attempts on the same item, mark as "needs human review" and continue with remaining items. Don't let one failure block everything.

## Final Report Template

```text
## [Command Name] Results

**Summary**: {N} items processed, {N} succeeded, {N} failed

### Succeeded ({N})
- Item 1: {brief description of what was done}

### Partial ({N})
- Item 2: {what worked} / {what didn't}

### Failed ({N})
- Item 3: {error reason}

### Next Steps
- {Any required follow-up actions}
```
