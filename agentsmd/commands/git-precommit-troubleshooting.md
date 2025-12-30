---
description: Troubleshoot pre-commit hook failures and auto-fixes
model: haiku
allowed-tools: Bash(git:*), Read, Glob, Grep
---

# Pre-Commit Hook Troubleshooting

Diagnose and fix pre-commit hook issues that occur when committing code.

---

## Error: Pre-Commit Hooks Modified Files

This error looks like:

```text
trim trailing whitespace.................................................Passed
fix end of files.........................................................Passed
markdownlint-cli2........................................................Failed
- hook id: markdownlint-cli2
- files were modified by this hook
```

**What happened:** Pre-commit hooks auto-corrected formatting issues (trailing whitespace,
newlines, markdown formatting, etc.). The fixes weren't committed automatically.

### Why This Happens

Pre-commit hooks run BEFORE your commit. If they auto-fix files, your staged changes no longer
match your working directory. Git stops to let you review the changes.

### Fix: Simple Case

Stage the auto-fixed files and amend the commit:

```bash
# Stage all auto-fixed files
git add -A

# Include the fixes in the previous commit
git commit --amend --no-edit

# Try your operation again (push, rebase, etc.)
git push origin <branch>
```

### Fix: Continuing After Rebase

If this happens during a rebase operation:

```bash
# Discover paths
MAIN_PATH=$(git worktree list | grep '\[main\]' | awk '{print $1}')

cd "$MAIN_PATH"
git add -A
git commit --amend --no-edit
git push origin main
```

### Debugging: Hook Loop

If the hooks keep modifying files in a loop:

```bash
# See what changed
git diff

# See what the hook is trying to fix
git diff HEAD~1
```

The hook may be trying to fix something it can't fully resolve. Check the actual file changes
to understand what's happening.

### Common Hooks and What They Fix

| Hook | Fixes |
| --- | --- |
| `trim-trailing-whitespace` | Removes spaces at end of lines |
| `end-of-file-fixer` | Ensures files end with newline |
| `markdownlint-cli2` | Fixes markdown formatting |
| `prettier` | Reformats code/JSON/YAML |
| `eslint` with --fix | Fixes JavaScript/TypeScript issues |

---

## DO NOT

- Do NOT use `git commit --no-verify` to skip hooks
- Do NOT force-push over hook auto-fixes
- Do NOT assume the hook is wrong - it's usually a legitimate formatting issue
