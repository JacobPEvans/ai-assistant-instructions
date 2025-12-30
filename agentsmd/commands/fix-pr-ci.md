---
description: Fix CI failures on open PRs in the current repository
model: sonnet
author: JacobPEvans
allowed-tools: Task, TaskOutput, TodoWrite, Bash(gh:*), Bash(git:*), Bash(git worktree remove:*), Read, Glob, Grep
---

# Fix PR CI Failures

**Purpose**: Fix CI failures on open PRs in the **current repository only**.

## Scope Parameter

| Usage | Scope | Batch Size |
| ----- | ----- | ---------- |
| `/fix-pr-ci` | Current PR only | 1 |
| `/fix-pr-ci all` | All open PRs with failing CI | 5 |

**CURRENT REPOSITORY ONLY** - This command never crosses into other repositories.

What this command DOES:

- List all open PRs in the current repository
- Find PRs with failing CI checks
- Create worktrees for each PR needing fixes
- Launch parallel subagents per PR
- Verify PRs are mergeable
- Clean up worktrees when done

What this command DOES NOT:

- Cross into other repositories
- Affect PRs in your other projects

## Related Documentation

- [Worktrees](../rules/worktrees.md) - Worktree structure and usage
- [Subagent Parallelization](../rules/subagent-parallelization.md) - Parallel execution patterns
- [Merge Conflict Resolution](../rules/merge-conflict-resolution.md) - How to resolve conflicts properly

## How It Works

You are the **orchestrator**. You will:

1. Identify the current repository from `gh repo view`
2. Determine scope (single PR or all PRs)
3. Find PRs with failing CI checks
4. Create worktrees for each failing PR
5. Launch subagents (parallel for `all` mode)
6. Monitor completion with TaskOutput
7. Verify PRs are mergeable
8. Clean up worktrees
9. Report final status

## Execution Steps

### Step 1: Identify Repository and Scope

```bash
# Get current repo info
gh repo view --json nameWithOwner --jq '.nameWithOwner'

# For single PR mode: get current branch's PR
gh pr view --json number,headRefName,title,statusCheckRollup,mergeable

# For all mode: get all open PRs with CI status
gh pr list --json number,headRefName,title,statusCheckRollup,mergeable
```

### Step 2: Filter for Failing CI

Use [PR Health Check Skill](../skills/pr-health-check/SKILL.md) patterns to identify PRs needing fixes.

PRs need fixing when:

- Any check has `conclusion: "FAILURE"`
- OR `mergeable != "MERGEABLE"`

See skill for detailed health check queries and interpretation.

### Step 3: Create Worktrees

For each PR with failing CI:

```bash
# Sanitize branch name for safe path usage
BRANCH_NAME="<branch-name-from-gh>"
SAFE_BRANCH_DIR="$(printf '%s\n' "$BRANCH_NAME" | tr -c 'A-Za-z0-9._-/' '_')"
git worktree add "$HOME/git/<repo-name>/$SAFE_BRANCH_DIR" "$BRANCH_NAME"
```

### Step 4: Launch Subagents

**Single PR mode**: Launch one subagent.

**All mode**: Launch subagents in batches of MAX 5.

**Subagent Prompt**:

```text
Fix CI for PR #{NUMBER} in {OWNER}/{REPO}
Worktree: {PATH}
Branch: {BRANCH}
Failing: {CHECK_NAMES}

Steps:
1. cd {PATH}
2. gh run list --limit 5 --json databaseId,name,conclusion (identify failing run ID)
3. gh run view {RUN_ID} --log-failed (use ID from step 2 to get failure details)
4. Fix root cause (NEVER disable checks)
5. Test locally if possible
6. git commit -m "fix: resolve CI failure"
7. git push

Report: PR#{NUMBER} - FIXED/BLOCKED (reason)
```

### Step 5: Monitor and Validate

Wait for subagent completion:

```bash
# Use TaskOutput with block=true for each subagent
```

Verify each PR:

```bash
gh pr view NUMBER --json mergeable,statusCheckRollup
```

PR is complete when `mergeable: "MERGEABLE"` and all checks pass.

### Step 6: Clean Up

```bash
# Use sanitized branch directory
SAFE_BRANCH_DIR="$(printf '%s\n' "$BRANCH_NAME" | tr -c 'A-Za-z0-9._-/' '_')"
git worktree remove "$HOME/git/<repo-name>/$SAFE_BRANCH_DIR"
git worktree prune
```

### Step 7: Final Report

```text
## CI Fix Results

Repository: {OWNER}/{REPO}
PRs processed: {N}

FIXED: #{N}, #{N}...
BLOCKED: #{N} (reason)...
```

## Batching Strategy (All Mode)

Use [Subagent Batching Skill](../skills/subagent-batching/SKILL.md) for parallel execution patterns.

**CRITICAL: Maximum 5 subagents running at once** (see skill for rationale).

If > 5 PRs need processing:

1. Launch first 5 subagents in parallel (single message)
2. Wait for ALL 5 to complete using `TaskOutput` with `block=true`
3. Validate each completed using [PR Health Check Skill](../skills/pr-health-check/SKILL.md)
4. If any incomplete: retry that PR (max 2 retries per skill guidance)
5. Only after all 5 are validated, start next batch of 5
6. Never have more than 5 concurrent subagents

See [Subagent Batching Skill](../skills/subagent-batching/SKILL.md) for:

- Launch patterns
- Monitoring completion
- Error handling
- Final report template

## Error Handling

If subagent fails 3 times on same PR:

- Mark PR as "needs human review"
- Log the issue
- Continue with other PRs
- Don't let one failure block everything

## GraphQL Patterns

See **[GitHub GraphQL Skill](../skills/github-graphql/SKILL.md)** for query patterns and format requirements.

## Example Usage

```bash
# Fix CI on current PR only
/fix-pr-ci

# Fix CI on all open PRs in current repo
/fix-pr-ci all
```

---

**Remember**: Current repo only, fix root causes, verify completion.
