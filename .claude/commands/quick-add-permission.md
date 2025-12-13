---
description: Quickly add always-allow permissions to all AI tools
model: haiku
allowed-tools:
  - Bash(git fetch:*)
  - Bash(git pull:*)
  - Bash(git switch:*)
  - Bash(git checkout:*)
  - Bash(git status:*)
  - Bash(git worktree add:*)
  - Bash(git worktree list:*)
  - Bash(git branch:*)
  - Read(**)
  - Glob(**)
  - Write(./.claude/permissions/*.json)
  - Write(./.gemini/permissions/*.json)
  - AskUserQuestion
---

# Quick Add Permission

Quickly add one or more always-allow permissions to all AI tool permission lists (Claude, Gemini, etc.) with a fresh worktree off the latest main.

## Parameters

The command accepts optional permission(s) as arguments in flexible formats:

```bash
/quick-add-permission
/quick-add-permission "docker ps"
/quick-add-permission "docker ps" "docker logs" "kubectl get"
/quick-add-permission "Bash(docker ps:*)"  # Full format also supported
```

If no arguments provided, the command will prompt interactively.

### Input Format Detection

The command intelligently converts simple inputs to proper permission format:

- `"docker ps"` → `"Bash(docker ps:*)"`
- `"git status"` → `"Bash(git status:*)"`
- `"kubectl get pods"` → `"Bash(kubectl get pods:*)"`
- `"Read"` → `"Read(**)"`
- `"SlashCommand"` → `"SlashCommand(**)"`
- `"Bash(docker ps:*)"` → Used as-is (already formatted)
- `"WebFetch domain:*.example.com"` → `"WebFetch(domain:*.example.com)"`

## Steps

### 1. Sync Main Repository

**CRITICAL**: Ensure working from the latest main before creating worktree.

1.1. Check current location:

```bash
git worktree list
```

1.2. Switch to main repository directory (not a worktree) if needed.

1.3. Fetch and pull latest main:

```bash
git fetch --all --prune
git switch main
git pull
```

### 2. Create Worktree

2.1. Determine branch name using timestamp:

```bash
branch_name="chore/add-permissions-$(date +%Y%m%d-%H%M%S)"
```

2.2. Determine worktree directory:

```bash
worktree_path="../$(basename $(git rev-parse --show-toplevel))-add-permissions"
```

2.3. Create the worktree:

```bash
git worktree add "$worktree_path" -b "$branch_name" main
```

2.4. Change to worktree directory:

```bash
cd "$worktree_path"
```

### 3. Gather and Format Permission Input

3.1. If arguments were provided:

- Parse each argument
- Convert to proper permission format (see conversion rules below)
- Ask which list(s) to add to: allow, ask, or deny

3.2. If no arguments provided, prompt interactively:

- Ask for permission string(s) (one or more, newline-separated)
- Convert to proper permission format
- Ask which list(s) to add to: allow, ask, or deny

3.3. **Permission Format Conversion Rules:**

For each input, detect the type and convert:

**Already formatted (contains parentheses):**

- Input: `"Bash(docker ps:*)"`
- Output: `"Bash(docker ps:*)"` (use as-is)

**Bash commands (default for plain text):**

- Input: `"docker ps"`
- Output: `"Bash(docker ps:*)"`
- Input: `"kubectl get pods"`
- Output: `"Bash(kubectl get pods:*)"`

**Tool names (Read, Glob, Grep, Write, etc.):**

- Input: `"Read"`
- Output: `"Read(**)"`
- Input: `"SlashCommand"`
- Output: `"SlashCommand(**)"`

**Special formats (WebFetch, etc.):**

- Input: `"WebFetch domain:*.example.com"`
- Output: `"WebFetch(domain:*.example.com)"`

3.4. Display the converted format to user for confirmation before proceeding

### 4. Update Permission Files

4.1. Identify all AI tool permission directories:

```bash
find . -type d -name "permissions" | grep -E "\.(claude|gemini)/"
```

Expected structure:

- `.claude/permissions/allow.json`
- `.claude/permissions/ask.json`
- `.claude/permissions/deny.json`
- `.gemini/permissions/allow.json`
- `.gemini/permissions/deny.json`

4.2. For each permission to add:

**Read existing file:**

```bash
# Example for Claude allow list
cat .claude/permissions/allow.json
```

**Parse JSON and check for duplicates:**

- Extract existing permissions array
- Check if permission already exists
- Skip if duplicate

**Add new permission:**

- Insert into permissions array
- Maintain alphabetical ordering within logical sections
- Preserve JSON formatting

**Write updated file:**

```bash
# Write updated JSON back to file
```

4.3. Sync across all tools:

- If permission added to `.claude/permissions/allow.json`, also add to `.gemini/permissions/allow.json`
- Translate any tool-specific syntax if needed
- Maintain consistency across all AI tools

### 5. Verify Changes

5.1. Show diff of changes:

```bash
git diff
```

5.2. Verify JSON validity:

```bash
# For each modified JSON file
cat .claude/permissions/allow.json | jq empty
```

5.3. Count additions:

- Report how many permissions added to each file
- Report any skipped duplicates

### 6. Summary

Provide a summary including:

- Worktree location
- Branch name
- Permissions added (with list type)
- Files modified
- Next steps: "Ready to review changes, commit, and create PR"

## Permission Format Guidelines

### Common Permission Patterns

**Bash commands:**

- `Bash(command subcommand:*)` - e.g., `Bash(docker ps:*)`
- `Bash(command:*)` - e.g., `Bash(ls:*)`

**File operations:**

- `Read(**)` - Read any file
- `Glob(**)` - Search for files
- `Grep(**)` - Search file contents
- `Write(**)` - Write any file

**Web operations:**

- `WebFetch(domain:*.example.com)` - Fetch from domain
- `WebSearch` - Search the web

**Tool operations:**

- `TodoWrite`, `TodoRead`
- `SlashCommand(/command-name)`

### Alphabetical Ordering

Permissions should be ordered:

1. By tool type (Read, Glob, Grep, WebSearch, Bash, etc.)
2. Within Bash, by command name alphabetically
3. Within each command, by subcommand alphabetically

Example ordering:

```json
{
  "permissions": [
    "Read(**)",
    "Glob(**)",
    "Grep(**)",
    "WebSearch",
    "Bash(docker inspect:*)",
    "Bash(docker logs:*)",
    "Bash(docker ps:*)",
    "Bash(git status:*)",
    "Bash(npm list:*)"
  ]
}
```

## Important Notes

- Always create a fresh worktree from latest main
- Sync permissions across all AI tools automatically
- Maintain alphabetical ordering for readability
- Skip duplicates but report them
- Verify JSON validity before committing
- Leave worktree ready for user to review and commit

## Example Usage

### Add single permission via simple format

```bash
/quick-add-permission "docker ps"
# Converts to: Bash(docker ps:*)
```

### Add multiple bash commands

```bash
/quick-add-permission "docker ps" "docker logs" "docker inspect"
# Converts to three separate JSON array entries:
# [
#   "Bash(docker ps:*)",
#   "Bash(docker logs:*)",
#   "Bash(docker inspect:*)"
# ]
```

### Add tool permissions

```bash
/quick-add-permission "Read"
# Converts to: Read(**)

/quick-add-permission "SlashCommand"
# Converts to: SlashCommand(**)
```

### Add using full format (advanced)

```bash
/quick-add-permission "Bash(kubectl get:*)" "WebFetch(domain:*.k8s.io)"
# Uses as-is
```

### Add interactively (no arguments)

```bash
/quick-add-permission
# Then answer prompts for permission(s) and list type
```
