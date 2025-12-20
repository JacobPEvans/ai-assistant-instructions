---
description: Initialize a clean worktree for new development work
model: haiku
allowed-tools: Task, TaskOutput, TodoWrite, Bash(awk:*), Bash(basename:*), Bash(cd:*), Bash(gh pr list:*), Bash(gh pr view:*), Bash(git branch:*), Bash(git checkout:*), Bash(git fetch:*), Bash(git pull:*), Bash(git rev-parse:*), Bash(git status:*), Bash(git switch:*), Bash(git worktree add:*), Bash(git worktree list:*), Bash(git worktree prune:*), Bash(git worktree remove:*), Bash(grep:*), Bash(head:*), Bash(ls:*), Bash(mkdir:*), Bash(pwd:*), Bash(tr:*)
---

# Init Worktree

**CRITICAL**: All development work MUST be done in a clean worktree. This command ensures isolation between concurrent sessions
and prevents accidental changes on main.

Initialize a clean worktree in `~/git/<repo-name>/<branch-name>/` for new development work.

## Related Documentation

- [Worktrees](../rules/worktrees.md) - Authoritative worktree structure and principles
- [Branch Hygiene](../rules/branch-hygiene.md) - Branch synchronization rules

## Usage

```bash
/init-worktree [description]
```

**Parameters:**

- `description` (optional): Brief description for branch/worktree naming (e.g., "fix login bug", "add dark mode")

If no description provided, will prompt for one.

## Prerequisites

This command creates worktrees using the structure:

```text
~/git/<repo-name>/
├── main/                    # Main branch worktree
├── feat/branch-name/        # Feature worktrees
└── fix/branch-name/         # Fix worktrees
```

The repository root (`~/git/<repo-name>/`) contains only the `.git` directory and worktree subdirectories. The `main` branch is itself a worktree at `main/`.

**First-time setup:**

If you have an existing repository at `~/git/<repo-name>/` (standard git checkout), this command will handle the conversion
automatically by detecting the current setup and creating new worktrees alongside your existing checkout. You can then migrate to the
worktree-only structure when ready.

**Note:** The root `.git` directory can be either a regular git directory or a bare repository - both work with this worktree structure.

## Steps

### 1. Validate Git Repository

1.1. Verify current directory is a git repository:

```bash
git rev-parse --is-inside-work-tree
```

If not a git repo, error and exit.

1.2. Get repository name:

```bash
basename $(git rev-parse --show-toplevel)
```

### 2. Remember Current State

2.1. Note current branch:

```bash
git rev-parse --abbrev-ref HEAD
```

2.2. Note current working directory:

```bash
pwd
```

**Purpose**: So user knows what branch they were on before cleanup/switch.

### 3. Clean Up Stale Worktrees

3.1. List all existing worktrees:

```bash
git worktree list
```

3.2. For each worktree (excluding main repository):

**Check if stale:**

```bash
# Get branch name from worktree
BRANCH=$(git worktree list | grep <path> | awk '{print $3}' | tr -d '[]')

# Check if branch is merged
git branch --merged main | grep -q "^  $BRANCH$"

# Check if remote branch exists
git branch -r | grep -q "origin/$BRANCH"
```

**Stale criteria** (remove if ANY true):

- Branch has been merged into main
- Branch no longer exists on remote
- Worktree has no active changes (clean working tree)

3.3. Remove stale worktrees:

```bash
git worktree remove <path>
```

3.4. Prune administrative files:

```bash
git worktree prune
```

**Report**: Number of worktrees cleaned up.

### 4. Switch to Main and Sync

4.1. Ensure we're in the main repository (not a worktree):

```bash
# Get main worktree path
MAIN_PATH=$(git worktree list | head -1 | awk '{print $1}')
cd "$MAIN_PATH"
```

4.2. Switch to main branch:

```bash
git switch main
```

4.3. Fetch and sync:

```bash
git fetch --all --prune
git pull
```

4.4. Clean up local merged branches:

```bash
# List merged branches (excluding main/master/develop)
git branch --merged main | grep -v -E "main|master|develop" | grep -v "^\*"

# Delete each one
git branch -d <branch-name>
```

### 5. Generate Branch and Worktree Names

5.1. Convert description to branch name:

**Naming rules:**

- Lowercase
- Replace spaces with hyphens
- Remove special characters
- Prefix with `feat/` (default) or `fix/` if description contains "fix"/"bug"

**Examples:**

- "add dark mode" → `feat/add-dark-mode`
- "fix login bug" → `fix/login-bug`
- "Update README" → `feat/update-readme`

5.2. Generate worktree directory name:

**Format**: `~/git/<repo-name>/<branch-name>/`

**Examples:**

- `~/git/ai-assistant-instructions/feat/add-dark-mode/`
- `~/git/nix-config/fix/login-bug/`

### 6. Create Worktree

6.1. Ensure repo directory exists:

```bash
mkdir -p ~/git/<repo-name>
```

6.2. Create the worktree:

```bash
git worktree add ~/git/<repo-name>/<branch-name> -b <branch-name> main
```

**Example:**

```bash
git worktree add ~/git/ai-assistant-instructions/feat/add-dark-mode -b feat/add-dark-mode main
```

### 7. Switch to Worktree

7.1. Change to the new worktree directory:

```bash
cd ~/git/<repo-name>/<branch-name>
```

7.2. Verify setup:

```bash
pwd
git status
git branch
```

### 8. Summary Report

Provide a clear summary including:

```text
✅ Worktree initialized successfully!

📊 Summary:
- Previous branch: <original-branch>
- Stale worktrees cleaned: <count>
- New worktree: ~/git/<repo-name>/<branch-name>
- New branch: <branch-name>
- Based on: main (synced with origin)

📍 Current location: ~/git/<repo-name>/<branch-name>
🚀 Ready for development!

Next steps:
1. Make your changes
2. Commit your work
3. Push and create PR: gh pr create
```

## Directory Structure

After running this command, your worktrees will be organized:

```text
~/git/
├── ai-assistant-instructions/
│   ├── main/                           # Main branch (read-only for development)
│   ├── feat/add-dark-mode/             # Feature worktree
│   └── fix/permissions/                # Fix worktree
└── nix-config/
    ├── main/                           # Main branch
    ├── feat/update-packages/           # Feature worktree
    └── fix/homebrew/                   # Fix worktree
```

## Important Notes

- **Isolation**: Each worktree is completely isolated - changes in one don't affect others
- **Shared git**: All worktrees share the same `.git` directory - commits are immediately visible
- **Clean slate**: Always starts from latest `main`, ensuring no conflicts with other sessions
- **Automatic cleanup**: Removes old worktrees whose branches are merged/deleted

## When to Use

**Always use `/init-worktree` when starting new work:**

- New features
- Bug fixes
- Refactoring
- Documentation updates
- Any changes requiring commits

**Skip only for:**

- 1-line typo fixes directly on main (rare exception)
- Reading/exploring code (no changes)
