---
mode: 'agent'
tools: ['codebase', 'usages', 'problems', 'changes', 'terminalSelection', 'terminalLastCommand', 'fetch', 'findTestFiles', 'githubRepo', 'editFiles', 'runCommands', 'search']
description: 'Systematically clean up git repositories by identifying and safely removing stale branches'
---

# Git Repository Cleanup Workflow

**AGENT INSTRUCTIONS**: You are tasked with systematically cleaning up a git repository by identifying and
safely removing stale branches while preserving important development history and maintaining clean environments.
Follow this workflow step-by-step and execute all commands directly using the available tools.

## Prerequisites

1. **Load context**: Read `.github/copilot-instructions.md`, `.copilot/PROJECT.md`, and `.copilot/WORKSPACE.md` if available
2. **Verify location**: Confirm your terminal is in the correct repository directory

## Execution Steps

### Phase 1: Assessment

Execute these commands in sequence:

```bash
# Repository status and branch information
git status
git branch -v
git branch -r
git branch -vv
git remote -v

# Pull request analysis
gh pr list --state all
gh pr list --state open
gh pr list --state closed

# Merge status verification
git branch --merged main
git branch --no-merged main
git branch -r --merged origin/main

# Branch activity with dates (PowerShell)
git for-each-ref --format='%(refname:short) %(upstream:track) %(committerdate)' refs/remotes
```

### Phase 2: Decision Matrix

For each remote branch, verify ALL criteria before deletion:

| Branch Name | Merged? | PR Status | Last Commit Age | Action |
|-------------|---------|-----------|-----------------|--------|
| `origin/branch1` | ✅ | Closed/Merged | > 7 days | DELETE |
| `origin/branch2` | ❌ | Open | Recent | KEEP |

**Safety Criteria (ALL must be true to delete):**

- ✅ Branch appears in `git branch -r --merged origin/main`
- ✅ Related PR shows "MERGED" or "CLOSED" in `gh pr list --state all`
- ✅ Branch is not protected (main, master, develop, etc.)
- ✅ Last commit is older than 7 days (unless specified otherwise)

**STOP CONDITIONS (DO NOT delete if any are true):**

- ❌ Branch shows in `git branch --no-merged main`
- ❌ Related PR is still open
- ❌ You are uncertain about the branch's purpose

### Phase 3: Safe Cleanup

Only for branches that meet ALL safety criteria:

```bash
# Delete remote branches (replace with actual names)
git push origin --delete branch-name-1 branch-name-2

# Clean up local references
git remote prune origin

# Verify cleanup
git branch -r
git status
```

### Phase 4: Final Report

Provide a summary including:

- **Total branches analyzed**: X
- **Branches deleted**: List with reasons
- **Branches kept**: List with reasons
- **Warnings/concerns**: Any uncertainties
- **Expected final state**: Only `origin/main` and `origin/HEAD` should remain (plus any active feature branches)

## Expected Clean State

After cleanup:

- **Local branches**: `main` (and active development branches)
- **Remote branches**: `origin/main`, `origin/HEAD` (and active feature branches)
- **No stale branches**: All merged feature branches removed
- **Clean tracking**: No orphaned remote-tracking references

---

**CRITICAL**: When in doubt, document uncertainty and ask for clarification rather than making assumptions.
