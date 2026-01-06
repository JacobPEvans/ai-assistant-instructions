# Permission Files Validation Strategy

## Overview

This document explains the validation system that ensures permission files in
`agentsmd/permissions/` remain compatible with Claude Code and will never break
the generated `settings.json` configuration.

## Why This Matters

The nix-config repository generates `~/.claude/settings.json` by transforming
the permission files stored in this repository. If an invalid tool name (like
`MultiEdit`) ends up in the permissions, it will fail validation with cryptic
errors:

```text
'MultiEdit' does not match '^((Bash|BashOutput|Edit|...)|(mcp__.*)$'
```

**Critical Requirement**: This can NEVER happen. The validation system prevents
it through multiple layers.

## Multi-Layered Validation

### Layer 1: Source Validation (Local Development)

**When**: Before every commit
**How**: Pre-commit hook runs `scripts/validate-permissions.sh`
**What**: Validates all permission files in `agentsmd/permissions/`

Run the validation manually anytime:

```bash
bash scripts/validate-permissions.sh
```

### Layer 2: Pre-push Prevention (Local)

**When**: Before pushing to remote
**How**: Pre-commit hook at pre-push stage (existing linter)
**What**: Validates `.claude/` files with validation tools

### Layer 3: CI Enforcement (GitHub Actions)

**When**: On every PR and push to main
**How**: `.github/workflows/validate-cclint-schema.yml`
**What**:

- Validates permission files
- Checks configuration syntax
- Detects schema version changes
- Runs final validation

**When**: Every PR and push
**How**: `.github/workflows/cclint.yml` (updated)
**What**:

- Validates permissions first
- Then runs linting on `.claude/` files

### Layer 4: Schema Monitoring (Upstream Change Detection)

**What**: Detects when tool set changes
**Where**: `agentsmd/permissions/valid-tools.json` tracks current state
**When**: Automatically updated on every validation run
**Why**: Provides git history of schema changes

## What Gets Validated

### Validation Rules

✅ **PASS** - Permission files should contain:

- Valid JSON syntax
- A `commands` array (regular permission files)
- A `domains` array (domain/webfetch files)
- An `mcp` array (MCP-related files)
- Shell command prefixes: `git:*`, `docker:*`, `npm:*`, `kubectl:*`, etc.

❌ **FAIL** - Permission files should NOT contain:

- Tool names like `Edit`, `Bash`, `MultiEdit`, `Read`, `Write`, `Task`, etc.
- Invalid JSON syntax
- Missing required arrays

## File Types

### Regular Permission Files

**Location**: `agentsmd/permissions/allow/`, `ask/`, `deny/`
**Structure**:

```json
{
  "commands": [
    "git:*",
    "docker:*",
    "npm:*"
  ]
}
```

### Domain/WebFetch Files

**Location**: `agentsmd/permissions/domains/`
**Structure**:

```json
{
  "domains": [
    "github.com",
    "npmjs.com",
    "python.org"
  ]
}
```

### MCP Files

**Location**: `agentsmd/permissions/allow/`
**Structure**:

```json
{
  "mcp": [
    "mcp__plugin_greptile_greptile__*"
  ]
}
```

## Understanding Valid Tools

Valid Claude Code tools (v0.2.10):

```text
Bash         - Shell command execution
BashOutput   - Captured bash output
Edit         - File editing
ExitPlanMode - Exit planning mode
Glob         - File pattern matching
Grep         - Text search
KillShell    - Terminate shell session
NotebookEdit - Jupyter notebook editing
Read         - File reading
SlashCommand - Slash command execution
Task         - Task/agent spawning
TodoWrite    - Todo list management
WebFetch     - Web content fetching
WebSearch    - Web searching
Write        - File writing
```

Plus: `mcp__.*` pattern for MCP tools

## How to Add New Permissions

### Step 1: Edit the appropriate file

Choose the right file based on the command's approval level:

- **Allow**: `agentsmd/permissions/allow/*.json` - Auto-approved commands
- **Ask**: `agentsmd/permissions/ask/*.json` - Requires confirmation
- **Deny**: `agentsmd/permissions/deny/*.json` - Blocked commands

### Step 2: Add your command

```json
{
  "commands": [
    "existing:*",
    "new:*"
  ]
}
```

### Step 3: Run validation locally

```bash
bash scripts/validate-permissions.sh
```

### Step 4: Commit and push

If validation passes, commit and push normally. The pre-commit hook will
validate again.

## Handling Validation Errors

### Error: Invalid JSON syntax

**Message**:

```text
❌ ERROR: Invalid JSON syntax: agentsmd/permissions/allow/tools.json
```

**Solution**: Check the JSON syntax in the file

```bash
jq . agentsmd/permissions/allow/tools.json
```

### Error: Missing commands array

**Message**:

```text
❌ ERROR: agentsmd/permissions/allow/tools.json: Missing required 'commands' array
```

**Solution**: Ensure the file has a `commands` array:

```json
{
  "commands": [
    "git:*"
  ]
}
```

### Error: Tool name instead of command

**Message**:

```text
❌ ERROR: agentsmd/permissions/allow/tools.json (line 52): Tool name in commands array
  Command: 'MultiEdit'
  ERROR: Tool names like 'MultiEdit' belong in .claude/settings.json
  HINT: Use shell commands like 'git:*', 'npm:*', 'docker:*'
```

**Solution**: Remove the tool name. Tool names should NOT be in permission files

- they belong in `.claude/settings.json` (which is auto-generated by nix-config)

## Detecting Schema Changes

The validation system tracks tool set changes:

### What's tracked

File: `agentsmd/permissions/valid-tools.json`

```json
{
  "timestamp": "2026-01-07T00:00:00Z",
  "cclint_version": "0.2.10",
  "valid_tools": [
    "Bash",
    "BashOutput"
  ],
  "mcp_pattern": "mcp__.*",
  "note": "Valid tools as of version 0.2.10"
}
```

### When schema changes

If the tool set releases a new version with different tools:

1. **Local**: Run validation locally to see what changed
2. **CI**: GitHub Actions will detect the change and post a comment on PRs
3. **Manual**: You can always check git history:

   ```bash
   git log agentsmd/permissions/valid-tools.json
   ```

## Advanced: How It Works Internally

### Validation Script

**File**: `scripts/validate-permissions.sh`

**Process**:

1. Get list of valid tools (hardcoded for reliability)
2. Load all JSON files from `agentsmd/permissions/`
3. For each file:
   - Validate JSON syntax
   - Check for required array (`commands`, `domains`, or `mcp`)
   - Scan commands for tool names
4. Generate `valid-tools.json` with current state
5. Report any errors

### Pre-commit Hook

**File**: `.pre-commit-config.yaml`

**Hook**:

```yaml
- id: validate-permissions
  stages: [commit]
  files: ^agentsmd/permissions/.*\.json$
```

Runs on every commit that touches permission files.

### CI Workflows

**File 1**: `.github/workflows/validate-cclint-schema.yml`

- Validates permissions
- Checks configuration syntax
- Detects schema changes

**File 2**: `.github/workflows/cclint.yml` (updated)

- Runs validation first
- Then runs validation on `.claude/` files

## Troubleshooting

### Pre-commit hook not running

```bash
# Reinstall pre-commit hooks
pre-commit install --install-hooks

# Run hooks manually
pre-commit run --all-files
```

### Validation script fails

```bash
# Run manually to see detailed output
bash scripts/validate-permissions.sh

# Check for jq availability
which jq

# Check npm availability
npm --version
```

### CI workflows failing

1. Check the Actions tab in GitHub
2. Look for detailed error messages in job logs
3. Upload artifacts contain validation reports
4. Review recent changes to `agentsmd/permissions/`

## Integration with nix-config

The nix-config repository uses permissions from this repo:

1. **Source**: `agentsmd/permissions/*.json` (validated here)
2. **Consumer**: `modules/home-manager/ai-cli/common/permissions.nix`
   (in nix-config)
3. **Output**: `~/.claude/settings.json` (generated by nix)

**Guarantee**: If permissions validate here, nix-config will generate valid
settings.json.

## Performance Notes

- Validation script runs in < 1 second
- Validates all 24 permission files at once
- No external network calls (hardcoded tool list)
- Pre-commit hook is fast enough for interactive development

## Related Documentation

- `CLAUDE.md` - AI agents configuration
- `agentsmd/permissions/STRATEGY.md` - Permission architecture
- `.cclintrc.jsonc` - Configuration for validation tools
- [carlrannaberg/cclint](https://github.com/carlrannaberg/cclint) - Official
  validation tool repository
