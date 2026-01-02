---
name: consolidate-issues
description: Reduce GitHub issue backlog through deduplication, linking, and closure. Use before creating new issues, when enforcement_mode is CONSOLIDATION, when issue:PR ratio exceeds 3:1, when AI-created issues reach 25, or when total issues approach 50.
---

<!-- markdownlint-disable-file MD013 -->

# Consolidate Issues

Reduces issue backlog to prevent AI-created issue spam and maintain healthy project hygiene.

## When to Use This Skill

- Before creating any new GitHub issue (always check limits first)
- When preflight returns `enforcement_mode: CONSOLIDATION`
- When issue:PR ratio exceeds 3:1
- When AI-created issues reach 25
- When total open issues approach 50
- Proactively during maintenance cycles

## Enforcement Modes

| Mode | Trigger | Action |
| ------ | --------- | -------- |
| NORMAL | All limits OK | Work normally |
| CONSOLIDATION | AI-created >= 25 or ratio > 3 | Run this skill first |
| PR_CREATION | Ratio > 5, PRs < 3 | Create PRs, not issues |
| PR_FOCUS | Open PRs >= 10 | Resolve PRs only |
| PAUSED | Total issues >= 50 | Run skipped entirely |

## Hard Limits

- **50 total issues**: Run paused
- **25 AI-created issues**: Skip issue creation
- **10 open PRs**: PR_FOCUS mode
- **3:1 ratio**: CONSOLIDATION mode

## Consolidation Workflow

### Step 1: Check Current Counts

```bash
TOTAL=$(gh issue list --state open --json number | jq length)
AI=$(gh issue list --state open --label ai-created --json number | jq length)
PRS=$(gh pr list --state open --json number | jq length)
RATIO=$((TOTAL / (PRS + 1)))
echo "Total: $TOTAL, AI: $AI, PRs: $PRS, Ratio: $RATIO:1"
```

### Step 2: Fetch All Open Issues

```bash
gh issue list --state open --limit 100 --json number,title,body,labels,createdAt
```

### Step 3: Close Duplicates

For each duplicate found:

```bash
gh issue edit <NUMBER> --add-label duplicate
gh issue close <NUMBER> --reason "not planned" \
  --comment "Duplicate of #<CANONICAL>. Closing."
```

### Step 4: Close Resolved Issues

Search for issues fixed by merged PRs:

```bash
gh pr list --state merged --limit 50 --json number,title,body
gh issue close <NUMBER> --reason completed \
  --comment "Resolved by PR #<PR>."
```

### Step 5: Link Related Issues

For related (non-duplicate) issues:

```bash
gh issue comment <NUMBER> --body "Related to #<OTHER>."
```

For 3+ related issues, create an umbrella issue.

### Step 6: Report to Slack

Post summary to Slack, not GitHub:

```bash
python3 scripts/auto-claude-notify.py cross_issue_update \
  --message "Consolidation: Closed N duplicates, K resolved by PRs"
```

## Pre-Issue Creation Check

Before ANY `gh issue create`:

```bash
TOTAL=$(gh issue list --state open --json number | jq length)
AI=$(gh issue list --state open --label ai-created --json number | jq length)

if [ "$TOTAL" -ge 50 ]; then
  echo "BLOCKED: Total issues ($TOTAL) >= 50"
  exit 1
fi

if [ "$AI" -ge 25 ]; then
  echo "BLOCKED: AI-created ($AI) >= 25. Run /consolidate-issues"
  exit 1
fi
```

## Best Practices

1. **Check before creating** - Always verify limits first
2. **Close aggressively** - When in doubt, close as duplicate/resolved
3. **Report to Slack** - Never create issues for status updates
4. **Focus on PRs** - PRs close issues; issues don't close themselves
