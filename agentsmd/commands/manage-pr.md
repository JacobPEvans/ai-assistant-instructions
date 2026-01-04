---
title: "Manage PR"
description: "Complete workflow for creating, monitoring, and fixing pull requests until ready to merge"
model: sonnet
type: "command"
version: "1.0.0"
allowed-tools: Task, TaskOutput, Bash(gh:*), Bash(git:*), Bash(markdownlint-cli2:*), Read, TodoWrite
think: false
author: "JacobPEvans"
---

Manages YOUR PRs as author - create, monitor, fix, prepare for merge. For reviewing others' PRs, use `/review-pr`.

## Scope

**SINGLE PR** - One PR at a time, from argument or current branch.

## Critical Rules

1. **NEVER auto-merge** - Wait for explicit user approval
2. **ALL checks must pass** - Never merge with failures
3. **ALL conversations RESOLVED** - Use the pr-thread-resolution-enforcement skill to verify
4. **Run validation locally** before pushing
5. **User approves merge** - Only after checks pass AND conversations resolved
6. **Create PR immediately** when work complete - kicks off reviews
7. **Watch CI** - Run `gh pr checks <PR> --watch` after creation

## Phase 1: Create PR

1. Run local validation (`markdownlint-cli2 .`, project linters)
2. Verify clean: `git status`
3. Push: `git push -u origin $(git branch --show-current)`
4. Create PR using template:

```bash
gh pr create --title "<type>: <description>" --body "$(cat <<'EOF'
## Summary

<1-3 bullet points describing what changed and why>

## Changes

- <specific file or component change>
- <specific file or component change>

## Test Plan

- [ ] <verification step 1>
- [ ] <verification step 2>

## Related

Closes #<issue-number> (if applicable)
EOF
)"
```

**Step 5:** Wait for CI: `gh pr checks <PR_NUMBER> --watch`

## Phase 2: Resolution Loop

### 2.1 Health Check

Use the pr-health-check skill: `gh pr view <PR> --json state,mergeable,statusCheckRollup,reviews`

### 2.2 Fix Failed Checks

Identify → view logs → fix locally → validate → commit → push → wait → loop back to 2.1

### 2.3 Resolve Conversations

Use the pr-thread-resolution-enforcement skill. For batch: `/resolve-pr-review-thread`

## Phase 3: Pre-Handoff

Verify ALL pass before requesting review:

1. All checks pass: `gh pr checks <PR>`
2. Mergeable: `gh pr view <PR> --json mergeable`
3. Threads resolved (MUST return 0): Use the pr-thread-resolution-enforcement skill verification query

**Only if all three pass**: "PR #XX ready for review. All checks pass, conversations resolved."

## Phase 4: Merge (User Action)

User merges: `--squash` for small changes, `--rebase` for larger/multiple commits.

## Related

Use the github-cli-patterns skill for all `gh` commands.

Workflow: `/init-worktree` → `/resolve-issues` → `/manage-pr` → `/review-pr` → `/resolve-pr-review-thread` → merge.
