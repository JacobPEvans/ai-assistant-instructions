---
description: Orchestrate PR finalization across all repositories and report merge-readiness status
model: opus
author: JacobPEvans
allowed-tools: Task, TaskOutput, Bash(gh:*), Read, Grep, Glob, TodoWrite
---

# Ready Player One

**Purpose**: Finalize all open PRs across all owned repositories by fixing CI failures, resolving review threads, and reporting which PRs
are ready to merge versus blocked.

## Scope

**ALL OWNED REPOSITORIES** - This command orchestrates complete PR finalization workflow across all repos you own.

What this command DOES:

- Execute `/fix-pr-ci all` to resolve CI failures
- Execute `/resolve-pr-review-thread all` to resolve review threads
- Scan all repos for open PRs
- Determine merge-readiness status for each PR
- Generate JSON report of ready vs blocked PRs

What this command DOES NOT:

- Merge PRs automatically (only reports readiness)
- Create new PRs
- Close or archive PRs

## Related Documentation

- [Subagent Parallelization](../rules/subagent-parallelization.md) - Parallel execution patterns
- `/fix-pr-ci all` - CI failure resolution
- `/resolve-pr-review-thread all` - Review thread resolution

## How It Works

You are the **orchestrator**. You will:

1. Execute `/fix-pr-ci all` to fix CI failures
2. Execute `/resolve-pr-review-thread all` to resolve review threads
3. List all repositories and their open PRs
4. Check merge-readiness status for each PR
5. Generate JSON report with ready vs blocked PRs
6. Display human-readable summary

## Execution Steps

### Step 1: Fix CI Failures

Execute the CI fix command:

```bash
/fix-pr-ci all
```

Wait for completion. This command will fix all CI failures across all PRs.

### Step 2: Resolve Review Threads

Execute the thread resolution command:

```bash
/resolve-pr-review-thread all
```

Wait for completion. This command will resolve all pending review threads.

### Step 3: Scan All Open PRs

Use [GitHub CLI Patterns](../skills/github-cli-patterns/SKILL.md) for `gh repo list` and `gh pr list`.

### Step 4: Determine Merge-Readiness

Use [PR Health Check Skill](../skills/pr-health-check/SKILL.md) for merge-readiness criteria.
Use [PR Thread Resolution Enforcement Skill](../skills/pr-thread-resolution-enforcement/SKILL.md) for thread verification.

**Ready to merge**: OPEN, MERGEABLE, all checks SUCCESS, no unresolved threads, approved.
**Blocked**: Failing any of the above.

### Step 5: Generate JSON Report

```json
{
  "ready_to_merge": [{"repo": "owner/repo", "pr": 123, "title": "...", "url": "..."}],
  "blocked": [{"repo": "...", "pr": 456, "title": "...", "reason": "CI failing", "url": "..."}]
}
```

### Step 6: Display Summary

Report: repos scanned, PRs ready, PRs blocked with reasons. Save JSON to `/tmp/ready-player-one-{TIMESTAMP}.json`.

## Blocking Reasons

CI failing, merge conflicts, unresolved comments, changes requested, no approval, draft.

## Error Handling

Log errors, continue scanning, report partial results.

---

**Remember**: Orchestrate, scan, report. Never merge automatically.
