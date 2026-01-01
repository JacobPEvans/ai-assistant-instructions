---
description: Orchestrate PR finalization across all repositories and report merge-readiness status
model: opus
author: JacobPEvans
allowed-tools: Task, TaskOutput, Bash(gh:*)
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

Get your GitHub username:

```bash
OWNER=$(gh api user --jq .login)
```

List all repositories:

```bash
gh repo list "$OWNER" --limit 1000 --json name --jq '.[].name'
```

For each repo, get all open PRs:

```bash
gh pr list --repo "$OWNER/$REPO" \
  --json number,title,headRefName,mergeable,statusCheckRollup,reviewDecision \
  --jq '.[]'
```

### Step 4: Determine Merge-Readiness

For each PR, use [PR Health Check Skill](../skills/pr-health-check/SKILL.md) for comprehensive merge-readiness validation.

Get unresolved review threads using [GitHub GraphQL Skill](../skills/github-graphql/SKILL.md) patterns.
Also verify thread resolution using [PR Thread Resolution Enforcement Skill](../skills/pr-thread-resolution-enforcement/SKILL.md).

Quick summary - a PR is **READY TO MERGE** when (see PR Health Check Skill for details):

- `state == "OPEN"`
- `mergeable == "MERGEABLE"`
- All required checks `SUCCESS`
- No unresolved review threads (verified via Thread Resolution Enforcement Skill)
- `reviewDecision` APPROVED or not required

A PR is **BLOCKED** when failing any of the above (see PR Health Check Skill for detailed criteria)

### Step 5: Generate JSON Report

Create a JSON report with this structure:

```json
{
  "ready_to_merge": [
    {
      "repo": "owner/repo1",
      "pr": 123,
      "title": "Add feature X",
      "url": "https://github.com/owner/repo1/pull/123"
    }
  ],
  "blocked": [
    {
      "repo": "owner/repo2",
      "pr": 456,
      "title": "Fix bug Y",
      "reason": "CI failing: lint, test",
      "url": "https://github.com/owner/repo2/pull/456"
    },
    {
      "repo": "owner/repo3",
      "pr": 789,
      "title": "Update docs",
      "reason": "unresolved review comments",
      "url": "https://github.com/owner/repo3/pull/789"
    }
  ]
}
```

### Step 6: Display Human-Readable Summary

After generating the JSON, display a summary:

```text
## Ready Player One - PR Finalization Report

Total repositories scanned: {N}
Total open PRs: {N}

✅ READY TO MERGE ({N} PRs):
- {OWNER}/{REPO}#{NUMBER}: {TITLE}
  https://github.com/{OWNER}/{REPO}/pull/{NUMBER}
...

🚫 BLOCKED ({N} PRs):
- {OWNER}/{REPO}#{NUMBER}: {TITLE}
  Reason: {REASON}
  https://github.com/{OWNER}/{REPO}/pull/{NUMBER}
...

---
JSON output saved to: /tmp/ready-player-one-{TIMESTAMP}.json
```

## Keep It Simple

### For Orchestrator (YOU)

- Use `gh` CLI for PR scanning
- Generate JSON report with structured data
- Verify merge-readiness using multiple signals
- That's it!

## Blocking Reasons

Common reasons a PR might be blocked:

1. **"CI failing: {check names}"** - One or more CI checks are failing
2. **"merge conflicts"** - PR has conflicts with base branch
3. **"unresolved review comments"** - Review threads not resolved
4. **"changes requested"** - Reviewer requested changes
5. **"no approval"** - PR requires approval but hasn't received one
6. **"draft"** - PR is in draft state

## Output Format

The JSON report follows this schema:

```typescript
interface Report {
  ready_to_merge: Array<{
    repo: string;      // "owner/repo"
    pr: number;        // PR number
    title: string;     // PR title
    url: string;       // Full GitHub URL
  }>;
  blocked: Array<{
    repo: string;      // "owner/repo"
    pr: number;        // PR number
    title: string;     // PR title
    reason: string;    // Why it's blocked
    url: string;       // Full GitHub URL
  }>;
}
```

## Error Handling

If sub-commands fail:

- Log the error
- Continue with PR scanning
- Report partial results
- Include error in summary

If PR status check fails:

- Mark PR as blocked with reason "status check failed"
- Continue with other PRs
- Don't let one failure block reporting

## Example Usage

```bash
/ready-player-one
```

The orchestrator will:

1. Fix all CI failures across all repos
2. Resolve all review threads across all repos
3. Scan all open PRs
4. Determine merge-readiness
5. Generate JSON report
6. Display summary

No user interaction needed - fully autonomous workflow!

## Performance Optimization

- Sub-commands run in sequence (CI fixes first, then reviews)
- PR scanning happens in parallel per repo
- Report generation is fast (single pass over data)
- Typical runtime: 5-30 minutes depending on number of repos/PRs

## Use Cases

**Daily standup**: Run at start of day to see what's ready to merge

**Before deployment**: Verify all PRs are in good state

**After bulk updates**: Check status after fixing multiple PRs

**Release preparation**: Ensure all PRs are merge-ready

---

**Remember**: Orchestrate, scan, report. Never merge automatically. Provide actionable intelligence about PR status.
