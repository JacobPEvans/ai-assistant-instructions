---
mode: 'agent'
tools: ['codebase', 'usages', 'problems', 'changes', 'terminalSelection', 'terminalLastCommand', 'fetch', 'findTestFiles', 'githubRepo', 'editFiles', 'runCommands', 'search']
description: 'Systematically clean up git repositories by identifying and safely removing stale branches'
---

# Git Repository Cleanup Workflow

Your goal is to systematically clean up git repositories by identifying and safely removing stale branches
while preserving important development history and maintaining clean environments.

## Prerequisites

Always load the generic `copilot-instructions.md` file at the beginning of each conversation for consistent
workflow standards and context.

## Assessment Methodology

### Step 1: Repository Context Assessment

1. Identify the current working directory and confirm it's a git repository
2. Check current branch status: `git status`
3. List all local branches with details: `git branch -v`
4. List all remote branches: `git branch -r`
5. Show branch tracking relationships: `git branch -vv`

### Step 2: Pull Request Analysis

1. List all pull requests: `gh pr list --state all`
2. Check for open pull requests: `gh pr list --state open`
3. Correlate closed/merged PRs with existing remote branches

### Step 3: Merge Status Verification

1. Check which branches are merged into main: `git branch --merged main`
2. Check which branches are NOT merged: `git branch --no-merged main`
3. Verify remote branch merge status: `git branch -r --merged origin/main`

## Safe Cleanup Process

### Preparation Commands

```powershell
# Show comprehensive branch status
git status
git branch -vv
git branch -r
gh pr list --state all
```

### Branch Analysis Commands

```powershell
# Check merge status
git branch --merged main
git branch -r --merged origin/main

# Show branch activity with dates
git for-each-ref --format='%(refname:short) %(upstream:track) %(committerdate)' refs/remotes | sort -k3
```

### Safe Deletion Process

1. **Verify merge status**: Ensure branches are fully merged
2. **Confirm PR status**: All related PRs should be closed/merged
3. **Delete remote branches**: Use specific branch names
4. **Clean local references**: Remove stale tracking branches

```powershell
# Template for deleting remote branches (replace with actual branch names)
git push origin --delete branch-name-1 branch-name-2 branch-name-3

# Clean up local remote references
git remote prune origin

# Verify cleanup
git branch -r
```

## Safety Checks

Before deleting any branch, verify:

- ✅ Branch is merged into main: `git branch -r --merged main`
- ✅ Related PR is closed/merged: `gh pr list --state all`
- ✅ No active development: Check recent commits
- ✅ Follows naming conventions per `copilot-instructions.md`

## VS Code Integration

### Branch Management in VS Code

1. **Command Palette**: `Ctrl+Shift+P` → "Git: Checkout to..." shows all branches
2. **Source Control Panel**: Displays current branch and changes
3. **Git Graph Extension**: Visual branch history and relationships
4. **GitLens Extension**: Enhanced git information and blame

### Recommended Extensions

- **Git Graph**: Visual branch timeline and merge history
- **GitLens**: Comprehensive git integration
- **GitHub Pull Requests**: Manage PRs within VS Code

## Regular Maintenance Schedule

### Weekly Review

- Check for merged branches: `git branch -r --merged main`
- Review open PRs: `gh pr list --state open`
- Clean up obviously stale branches

### Monthly Deep Clean

1. Full branch audit: `git branch -a`
2. PR correlation analysis: `gh pr list --state all`
3. Systematic cleanup of merged branches
4. Remote reference pruning: `git remote prune origin`

## Automation Considerations

### GitHub Actions Opportunities

- Auto-delete merged feature branches after PR merge
- Weekly stale branch reporting
- Automated cleanup of branches older than X days
- PR merge validation before branch deletion

### Repository Settings

- Enable automatic branch deletion in GitHub repository settings
- Configure branch protection rules for main branch
- Set up required status checks before merging

## Expected Clean State

After cleanup, repository should contain:

- **Local branches**: `main` (and any active development branches)
- **Remote branches**: `origin/main`, `origin/HEAD` (and any active feature branches)
- **No stale branches**: All merged feature branches removed
- **Clean tracking**: No orphaned remote-tracking references
