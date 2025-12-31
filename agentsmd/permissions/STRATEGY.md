# Permission Architecture Strategy

## Overview

This document explains the hierarchical permission system used by Claude Code and other AI
assistants. The system uses a **permission level hierarchy** (Deny > Ask > Allow) where more
restrictive permission levels override less restrictive ones, providing both convenience and
security.

## Permission Levels

Claude Code resolves permission conflicts using a **three-tier hierarchy**:

```text
Deny  (most restrictive)  → Blocks execution immediately
Ask   (middle tier)       → Prompts user for confirmation
Allow (least restrictive) → Executes silently
```

**Key principle**: A more restrictive permission level always overrides a less restrictive one, regardless of pattern specificity.

## Coarse-to-Specific Pattern

This system uses a **coarse-to-specific layering approach**:

### Coarse Allows (Convenience Layer)

The `allow/` directory contains broad, tool-level patterns that grant wide access:

```json
{
  "commands": [
    "git:*",              // All git commands allowed
    "docker:*",           // All docker commands allowed
    "npm:*",              // All npm commands allowed
    "pip:*",              // All pip commands allowed
    "cargo:*",            // All cargo commands allowed
    "kubectl:*",          // All kubectl commands allowed
    "terraform:*",        // All terraform commands allowed
    "aws:*"               // All aws commands allowed
  ]
}
```

This provides **convenience**: common tools work without friction, and the AI can be productive with minimal permission prompts.

### Specific Asks (Control Layer)

The `ask/` directory contains specific command patterns that require confirmation:

```json
{
  "commands": [
    "git merge:*",             // Dangerous: can create merge conflicts
    "git reset:*",             // Dangerous: can lose work
    "git rebase:*",            // Dangerous: rewrites history
    "git cherry-pick:*",       // Dangerous: cherry-picks specific commits
    "git worktree remove:*",   // Dangerous: removes working trees
    "docker exec:*",           // Dangerous: executes in running container
    "docker run:*",            // Dangerous: creates new container
    "npm install:*",           // Requires confirmation: modifies dependencies
    "pip install:*",           // Requires confirmation: modifies dependencies
    "cargo install:*",         // Requires confirmation: modifies system
    "rm:*",                    // Dangerous: deletes files
    "mv:*",                    // Dangerous: moves/renames files
    "cp:*",                    // Dangerous: overwrites files
    "chmod:*",                 // Dangerous: changes permissions
    "chown:*"                  // Dangerous: changes ownership
  ]
}
```

This provides **control**: when the AI tries `git merge`, it triggers an Ask confirmation even though `git:*` is allowed.

### How Precedence Works

Example: User has these permissions configured:

```text
Allow:
  - git:*
  - docker:*

Ask:
  - git merge:*
  - docker exec:*

Deny:
  - git commit --no-verify:*
  - docker run -v /root:*
```

When AI executes commands:

| Command | Match | Result | Reason |
| --- | --- | --- | --- |
| `git status` | Allow `git:*` (only) | Allowed | Only Allow matches, most specific |
| `git log` | Allow `git:*` (only) | Allowed | Only Allow matches |
| `git merge main` | Allow `git:*` + Ask `git merge:*` | **Ask** | Ask is stricter, overrides Allow |
| `git reset HEAD~1` | Allow `git:*` + Ask `git reset:*` | **Ask** | Ask is stricter |
| `git commit --no-verify` | Deny `git commit --no-verify:*` | **Deny** | Deny overrides all |
| `docker ps` | Allow `docker:*` (only) | Allowed | Only Allow matches |
| `docker exec <container>` | Allow `docker:*` + Ask `docker exec:*` | **Ask** | Ask is stricter |
| `docker run -v /root:/root` | Deny `docker run -v /root:*` | **Deny** | Deny overrides all |

## File Organization

```text
agentsmd/permissions/
├── allow/
│   ├── core.json              # Essential tools: git, gh, standard utilities
│   ├── languages.json         # Language tooling: cargo, go, ruby, nodejs, python, rust
│   ├── infrastructure.json    # Infrastructure: docker, kubernetes, terraform, aws
│   ├── tools.json             # Development tools: brew, nix, asdf, mise, etc.
│   └── services.json          # Services: redis, server tools
│
├── ask/
│   ├── git.json               # Git: merge, reset, rebase, cherry-pick, worktree remove
│   ├── dangerous-operations.json  # rm, mv, cp, chmod, chown, sed, awk
│   ├── package-managers.json  # npm install, pip install, poetry install, cargo install
│   ├── containers.json        # docker exec, docker run, docker context create
│   ├── cloud.json             # AWS: ec2 terminate, s3 cp, etc.
│   └── system.json            # osascript, system_profiler, defaults write
│
├── deny/
│   ├── sensitive-files.json   # .env*, .ssh/*, .aws/credentials, .kube/config
│   ├── destructive.json       # rm -rf /, sudo rm, mkfs, fdisk, dd
│   ├── privilege-escalation.json  # sudo -i, sudo su, sudo bash
│   └── git-hook-bypass.json   # git commit --no-verify, removing hooks
│
└── domains/
    └── webfetch.json          # Allowed fetch domains for WebFetch tool
```

## Common Ask Patterns

These commands are consistently placed in the Ask list because they're powerful but potentially dangerous:

### Git Commands

- `git merge:*` - Can create merge conflicts or merge unwanted changes
- `git reset:*` - Can lose work if reset to wrong commit
- `git rebase:*` - Rewrites history, dangerous if not careful
- `git cherry-pick:*` - Can create conflicts or duplicate commits
- `git worktree remove:*` - Can delete working tree if wrong path given

### Package Management

- `npm install:*` - Modifies package.json and node_modules
- `pip install:*` - Modifies site-packages and Python environment
- `poetry install:*` - Modifies poetry.lock
- `cargo install:*` - Modifies ~/.cargo/bin

### File Operations

- `rm:*` - Deletes files (can be permanent)
- `mv:*` - Moves/renames files (can overwrite)
- `cp:*` - Copies files (can overwrite)
- `chmod:*` - Changes permissions
- `chown:*` - Changes ownership

### Container Operations

- `docker exec:*` - Executes code in running container
- `docker run:*` - Starts new container (resource commitment)
- `docker context create:*` - Creates new context

### System Operations

- `osascript:*` - Executes AppleScript (OS automation)
- `system_profiler:*` - Reads system information
- `defaults read/write:*` - Modifies system defaults

## Token Efficiency

This hierarchical approach significantly reduces token usage:

**Before** (individual permissions):

```text
Bash(git status:*)
Bash(git log:*)
Bash(git diff:*)
Bash(git show:*)
Bash(git branch:*)
... 45 more git commands
```

**Result**: ~451 individual permissions, massive RATIONALE.md

**After** (hierarchical with coarse + specific):

```text
Allow:
  - git:*
  - docker:*
  - npm:*
  ... (30-40 patterns)

Ask:
  - git merge:*
  - git reset:*
  - docker exec:*
  ... (80-100 patterns)
```

**Result**: ~120 total patterns, streamlined documentation

**Token savings**: ~80-85% reduction in permission list size

## Implementation Notes

1. **Coarse Allow patterns** should match tool names: `git:*`, `docker:*`, `npm:*`
2. **Specific Ask patterns** should match dangerous subcommands: `git merge:*`, `docker exec:*`
3. **Deny patterns** should be as specific as possible to avoid false positives
4. **Tool-agnostic format**: These files use simple command lists, not Claude-specific syntax
5. **nix-config formatting**: The nix-config repo converts these to tool-specific formats during build

## Precedence Reference

When Claude Code encounters multiple matching permissions:

1. **Check Deny first** - If ANY deny rule matches, execution is blocked
2. **Check Ask second** - If ANY ask rule matches (and not denied), prompt user
3. **Check Allow third** - If ANY allow rule matches (and not denied/asked), execute silently
4. **Default behavior** - If no rules match, behavior depends on Claude Code defaults

**Pattern matching**: Patterns use glob-style matching. More specific patterns (e.g.,
`git merge:*`) match before less specific (e.g., `git:*`), but permission level still
wins (Ask > Allow despite specificity differences).

## Future Enhancements

Potential improvements to this system:

1. **Permission templates**: Pre-built permission sets for common scenarios (e.g., "TypeScript Developer", "DevOps Engineer")
2. **Context-aware permissions**: Different permission levels based on task type or project
3. **Audit logging**: Detailed tracking of which permissions were used and when
4. **Permission suggestions**: Automatic suggestions to promote Ask to Deny based on patterns
5. **Tool-specific customization**: Different permission levels for different AI tools (Claude, Gemini, Copilot)
