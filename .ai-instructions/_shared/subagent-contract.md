# Shared: Subagent Contract

All subagents follow this standard contract. Individual subagent files define only their unique behavior.

## Header Fields

Every subagent specifies:

| Field | Values | Description |
|-------|--------|-------------|
| Model Tier | Large / Medium / Small | Complexity level |
| Context Budget | 3k-15k tokens | Max context size |
| Write Permissions | Specific scopes | What the subagent can modify |
| Timeout | 2-30 min | Max execution time |

## Standard Input Contract

```markdown
## Task Assignment

**Task ID**: TASK-XXX
**Objective**: [Clear goal]
**Context Files**: [Relevant files]
**Constraints**: [Limitations]
**Timeout**: [Max time]
```

## Standard Output Contract

```markdown
## Task Result

**Task ID**: TASK-XXX
**Status**: success | partial | blocked | failed
**Summary**: [What was done]
**Files Modified**: [List]
**Errors**: [Any issues]
**Next Steps**: [Recommendations]
```

## Core Rules

1. **No Clarification** - Resolve ambiguity per [Self-Healing](../concepts/self-healing.md)
2. **Partial Over Blocking** - Return partial results rather than block
3. **Document Assumptions** - Log all decisions with confidence scores
4. **Respect Timeout** - Return best-effort result when time expires

## Standard Failure Recovery

All subagents use these recovery patterns:

| Failure | Recovery |
|---------|----------|
| Unclear requirements | Infer from context, document assumption |
| Missing files | Search alternatives, create if appropriate |
| Timeout reached | Return partial result with status |
| External API error | Retry 3x with backoff, then report |

For complex failures, see [Self-Healing](../concepts/self-healing.md).

## Timeout Reference

See [Timeout Budgets](./timeout-budgets.md) for all subagent timeouts.
