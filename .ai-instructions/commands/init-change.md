---
description: Initialize a new change with worktree cleanup and fresh branch
model: haiku
allowed-tools: Bash(git worktree list:*), Bash(git worktree remove:*), Bash(git worktree prune:*), Bash(git worktree add:*), Bash(git fetch:*), Bash(git pull:*), Bash(git branch:*), Bash(git switch:*), Bash(git checkout:*), Bash(git status:*), Bash(gh pr list:*), Bash(gh pr view:*), Bash(gh issue view:*), Bash(pwd:*), Bash(ls:*)
---

# Init Change

Initialize a new change by cleaning up stale worktrees, syncing main, and creating a fresh worktree.

## Parameters

The command accepts a change identifier:

- Issue number (e.g., `#123` or `123`)
- PR number (e.g., `#456` or `456`)
- Short descriptive name (e.g., `fix-login-bug`)

## Steps

### 1. Record Starting Location

1.1. Note the current working directory path.

1.2. Identify if currently in a worktree or the main repository:

```bash
git worktree list
```

### 2. Clean Up Stale Worktrees

2.1. List all worktrees:

```bash
git worktree list
```

2.2. For each worktree (excluding the main repo):

- Check if its branch has a merged PR
- Check if its branch no longer exists on remote

2.3. Remove stale worktrees:

```bash
git worktree remove <path>
```

2.4. Prune worktree references:

```bash
git worktree prune
```

### 3. Sync Main Repository

3.1. Switch to the main repository directory (not a worktree).

3.2. Switch to the default branch (main or master):

```bash
git switch main
```

3.3. Fetch and pull latest:

```bash
git fetch --all --prune
git pull
```

3.4. Clean up merged local branches:

```bash
# List merged branches
git branch --merged main

# Delete each merged branch individually (skip main/master/develop)
git branch -d <branch-name>
```

### 4. Create New Worktree

4.1. Determine branch name based on parameter:

- Issue `#123` → `issue-123` or `feat/issue-123`
- PR `#456` → Check out the existing PR branch
- Name `fix-login-bug` → `fix/login-bug` or `feat/login-bug`

4.2. Determine worktree directory name:

- Use pattern: `../<repo-name>-<identifier>`
- Example: `../ai-assistant-instructions-issue-123`

4.3. Create the worktree:

```bash
git worktree add <path> -b <branch-name> main
```

### 5. Complete Setup

5.1. Change to the new worktree directory.

5.2. Verify the setup:

```bash
git status
pwd
```

5.3. Report:

- Worktrees cleaned up (if any)
- New worktree location
- New branch name
- Ready to begin work

### 6. Begin Planning (if applicable)

If the input was a GitHub issue, detailed spec, or comprehensive change request:

6.1. Fetch the full context (issue body, spec contents, etc.)

6.2. Begin to **plan** the implementation by analyzing requirements and existing code

6.3. Draft an implementation approach before writing any code

## Worktree Naming Convention

| Input | Branch Name | Worktree Directory |
|-------|-------------|-------------------|
| `#123` (issue) | `feat/issue-123` | `../<repo>-issue-123` |
| `#456` (PR) | (existing branch) | `../<repo>-pr-456` |
| `fix-bug` | `fix/fix-bug` | `../<repo>-fix-bug` |
| `add-feature` | `feat/add-feature` | `../<repo>-add-feature` |

## Important Notes

- Always return to the main repo before creating new worktrees
- Worktrees share the same `.git` directory - commits are immediately visible
- Each worktree must have a unique branch
