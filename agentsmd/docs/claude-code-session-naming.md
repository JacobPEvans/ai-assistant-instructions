# Claude Code Session Naming and Management

This guide explains how to use Claude Code's native session naming and
management features for better organization and continuity of development
work.

## Overview

Claude Code automatically creates sessions for each conversation. These sessions are identified by:

- **Session ID**: A unique UUID assigned by Claude Code
- **Working Directory**: The path where the session was started
- **Timestamp**: When the session was created
- **Optional Name**: A user-defined descriptive name

With native naming features, you can rename sessions and resume them by
name, making it easier to pick up previous work or track multiple concurrent
development streams.

## Quick Start

### Naming the Current Session

Inside a Claude Code session, use the `/rename` command to give your
session a descriptive name:

```text
/rename feature-xyz-implementation
```

This makes the session easy to find later. Use clear, concise names like:

- `auth-refactor-phase-1`
- `performance-optimization`
- `fix-memory-leak`
- `docs-update-2025-q1`

### Resuming Named Sessions

#### From Command Line

Resume a session by name or search:

```bash
claude --resume "feature-xyz"
```

This opens an interactive picker showing matching sessions. You can:

- Press `Enter` to resume the selected session
- Type to filter sessions
- Use arrow keys to navigate

Resume the most recent session:

```bash
claude --continue
```

#### Interactive Picker

Without a search term, browse all sessions:

```bash
claude --resume
```

This shows all available sessions, sorted by most recent first, with:

- Session name (if set)
- Working directory
- Last activity date/time

## Session Storage

Sessions are stored in your home directory:

```text
~/.claude/projects/
```

Each directory represents a working directory where you've had sessions. Inside each, session files are created and organized by timestamp.

### Finding Your Sessions

List all your sessions programmatically:

```bash
ls -la ~/.claude/projects/
```

Each directory name encodes the working directory path:

```text
-Users-jevans-git-ai-assistant-instructions-main
-Users-jevans-git-ai-assistant-instructions-feat-dark-mode
-Users-jevans-git-nix-config-main
```

## Integration with Git Workflows

### Naming Sessions by Branch

When starting a Claude Code session for a git branch, use a session name that matches:

```bash
# On branch: feat/add-dark-mode
claude -c
```

Then rename the session:

```text
/rename dark-mode-feature
```

For automated naming in scripts:

```bash
#!/bin/bash
# Get current git branch
BRANCH=$(git branch --show-current 2>/dev/null || echo "no-repo")

# Start Claude Code with branch context
claude --system-prompt "You are working on branch: $BRANCH"
```

### Linking Sessions to Issues

When working on a specific GitHub issue, include the issue number in the
session name:

```text
/rename issue-95-session-naming
```

This creates a clear mapping between sessions and the work being done.

### Feature Branch Sessions

For feature development with multiple branches:

```bash
# Feature branch: feat/auth-service
cd ~/git/myapp/feat/auth-service
claude --continue  # Resumes previous work on this branch
```

Once the feature is complete, clean up the old session by working on a new branch or removing the worktree.

## Best Practices

### Session Naming Conventions

Use a consistent naming pattern in your team:

**Recommended Format**:

```text
[context]-[description]-[optional-number]
```

**Examples**:

- `issue-95-session-naming`
- `feat-auth-refactor-phase1`
- `fix-memory-leak`
- `docs-api-migration-2025`
- `perf-query-optimization`

### When to Rename Sessions

Rename a session:

- **Immediately after starting** when doing focused work
- **When changing focus** within a long session (create a new session for clarity)
- **For ongoing work** that spans multiple days

### Session Lifecycle

1. **Start**: Begin work, automatically creates a session
2. **Rename**: Give it a clear name with `/rename`
3. **Resume**: Pick up where you left off with `claude --resume <name>`
4. **Archive**: Old sessions remain accessible but don't clutter your active list

Sessions are never automatically deleted. Old sessions remain available for reference.

## Advanced Usage

### Per-Directory Session Defaults

While Claude Code doesn't have built-in per-directory configuration files
yet, you can create a workflow:

1. **Create a `.claude-session` file** in your project root (for
   documentation):

```json
{
  "project": "ai-assistant-instructions",
  "recommended_session_names": [
    "docs-updates",
    "issue-resolution",
    "code-review"
  ],
  "usage_notes": "Rename session to match the issue or feature being worked on"
}
```

This documents the expected naming convention without modifying Claude Code's
behavior.

1. **Use shell aliases** for quick session resumption:

```bash
# Add to ~/.zshrc or ~/.bashrc
alias claude-docs="claude --resume docs-updates"
alias claude-issues="claude --resume issue-resolution"
alias claude-review="claude --resume code-review"
```

### Tracking Session Context

Use Claude Code's built-in features to maintain context:

```text
/rename <branch-name>-<task>
```

The `/remind` command (if available) can add notes:

```text
I'm working on Issue #95: Claude Config session naming
Current focus: Writing documentation
```

### Integration with Git Branches

Create a shell function to start Claude with automatic branch context:

```bash
#!/bin/bash
# Add to ~/.zshrc or ~/.bashrc

function claude-branch() {
    local branch=$(git branch --show-current 2>/dev/null || echo "no-repo")
    local session_name="${branch/\//-}"
    echo "Starting Claude Code session for: $session_name"
    claude --system-prompt "You are working on git branch: $branch"
}
```

Usage:

```bash
cd ~/git/ai-assistant-instructions
git checkout -b feat/session-docs
claude-branch
```

Then rename the session to something more descriptive:

```text
/rename feat-session-docs
```

## Troubleshooting

### Can't Find a Previous Session

If you can't find a session with `claude --resume`:

1. Check if the session exists:

   ```bash
   ls ~/.claude/projects/
   ```

1. Search with a partial name:

   ```bash
   claude --resume "keyword"
   ```

1. Browse all sessions:

   ```bash
   claude --resume
   ```

### Session Not Persisting

Sessions are saved automatically. If a session seems to disappear:

1. Verify it was saved:

   ```bash
   ls -la ~/.claude/projects/*<directory-name>*
   ```

1. Restart Claude Code to ensure persistence takes effect

1. Use `--fork-session` if you want to create a new session from an
   existing one:

   ```bash
   claude --resume <session-name> --fork-session
   ```

### Organizing Many Sessions

If you have many sessions, adopt these strategies:

1. **Name by project**:
   - `ai-instructions-issue-95`
   - `ai-instructions-docs-update`

1. **Name by time period**:
   - `2025-q1-planning`
   - `2025-12-architecture-review`

1. **Archive old sessions** by noting which are no longer active

## Related Resources

- [Claude Code Docs - CLI Reference](https://code.claude.com/docs/en/cli-reference)
- [Worktrees Guide](../rules/worktrees.md) - For managing git worktrees alongside sessions
- [Branch Hygiene](../rules/branch-hygiene.md) - For syncing branches with sessions

## Summary

Claude Code's native session naming provides:

- **`/rename`** - Name your current session
- **`claude --resume <name>`** - Resume a session by name
- **`claude --continue`** - Resume the most recent session
- **`claude --resume`** - Interactive picker of all sessions
- **`~/.claude/projects/`** - Local session storage

Combining these features with git branch names and issue numbers creates a
powerful session management workflow that improves continuity and tracking
across your development work.
