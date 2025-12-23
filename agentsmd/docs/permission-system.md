# Permission System Integration with nix-config

This document describes how permission definitions in this repository integrate with the unified permission system in nix-config.

## Overview

Permissions for all AI tools (Claude, Gemini, Copilot, OpenCode) are **source-defined in this
repository** (Option B from Issue #135). The nix-config repository reads these JSON definitions and
applies tool-specific formatters to generate configuration files for each tool.

**Key principle**: Single source of truth in JSON + tool-specific formatters = unified but flexible
permission system.

## Architecture

```text
ai-assistant-instructions (THIS REPO)
├── .claude/permissions/        # Claude permission source
│   ├── allow.json             # Main allow list
│   ├── ask.json               # Ask-first list
│   ├── deny.json              # Deny list
│   └── modules/               # Modular permission sets
│       ├── core.json
│       ├── python.json
│       ├── nodejs.json
│       └── ... (specialized modules)
│
└── .gemini/permissions/        # Gemini permission source
    ├── allow.json             # Allow list (no modules yet)
    └── deny.json              # Deny list

                    ↓ (nix-config reads at build time)

nix-config
├── modules/ai-cli/            # AI CLI integration
│   ├── permissions.nix        # Permission formatter module
│   └── formatters/
│       ├── claude.nix         # Bash(cmd:*) format
│       ├── gemini.nix         # run_shell_command(cmd) format
│       └── copilot.nix        # shell(cmd) format
│
└── home-manager/
    └── home.nix               # Applied to user environment
```

## Permission Format

### Claude Permissions

**File**: `.claude/permissions/allow.json` (and ask.json, deny.json)

**Format**: `"Bash(command:*)"` pattern

```json
{
  "permissions": [
    "Read(**)",
    "Glob(**)",
    "Bash(git status:*)",
    "Bash(git commit:*)",
    "WebFetch(domain:github.com)"
  ]
}
```

**Syntax:**

- `Tool(pattern:*)` - Tool name + colon-separated pattern + `:*` wildcard
- `WebFetch(domain:DOMAIN)` - Domain-based filtering for web fetches
- `Read(**), Glob(**), Grep(**)` - Built-in file operation tools
- Patterns support wildcards: `:*` matches all variations of a command

### Gemini Permissions

**Files**: `.gemini/permissions/allow.json`, `.gemini/permissions/deny.json`

**Format**: Tool-specific (different from Claude)

```json
{
  "allowedTools": [
    "read_file",
    "glob_tool",
    "grep_tool",
    "run_shell_command(git status)",
    "run_shell_command(git commit)",
    "web_fetch"
  ]
}
```

**Syntax:**

- `read_file`, `glob_tool`, `grep_tool` - Built-in file tools
- `run_shell_command(FULL_COMMAND)` - Full shell command specification
- `web_fetch` - Broad web fetch permission (no domain filtering yet)

**Important Limitation:**

Unlike Claude's `:*` wildcard pattern, Gemini's `run_shell_command()` format does not support
wildcards or prefix matching. Each command variation with different arguments requires a separate
permission entry. For example:

- Claude: `"Bash(pip install:*)"` - allows `pip install <any-package>`
- Gemini: Requires separate entries like:
  - `"run_shell_command(pip install numpy)"`
  - `"run_shell_command(pip install pandas)"`
  - etc.

This means Gemini permissions are more restrictive and require more granular specification. When
defining permissions, be aware that the permissions are not truly equivalent across tools.

## Tool-Specific Formatters (in nix-config)

The nix-config repository defines formatters that convert Claude's JSON format to tool-specific formats:

### Claude Formatter

```nix
# modules/ai-cli/formatters/claude.nix
/*
  Pass through - Claude format is source format
  Input: "Bash(git status:*)"
  Output: "Bash(git status:*)"
*/
```

### Gemini Formatter

```nix
# modules/ai-cli/formatters/gemini.nix
/*
  Convert Bash(cmd:*) → run_shell_command(cmd)
  Input: "Bash(git status:*)"
  Output: "run_shell_command(git status)"

  Convert Read(**) → read_file
  Convert Glob(**) → glob_tool
  Convert WebFetch(domain:*) → web_fetch
*/
```

### Copilot Formatter (Future)

```nix
# modules/ai-cli/formatters/copilot.nix
/*
  Convert to Copilot shell flags
  Input: "Bash(git status:*)"
  Output: "shell(git status)"
*/
```

## Modular Permission System (Claude)

Claude permissions are organized into focused modules to reduce token overhead and improve maintainability.

### Module Structure

```text
.claude/permissions/
├── allow.json           # Full permissions (composed from modules)
├── ask.json             # Ask-first list
├── deny.json            # Deny list
└── modules/
    ├── core.json        # Universal safe commands
    ├── webfetch.json    # Domain allowlist
    ├── python.json      # Python toolchain
    ├── nodejs.json      # Node.js toolchain
    ├── rust.json        # Rust toolchain
    ├── docker.json      # Docker toolchain
    ├── kubernetes.json  # Kubernetes toolchain
    ├── terraform.json   # Terraform/IaC
    ├── aws.json         # AWS CLI
    ├── nix.json         # Nix ecosystem
    ├── system.json      # Package managers
    ├── asdf.json        # Version managers
    ├── redis.json       # Redis CLI
    └── orb.json         # Orbstack
```

Each module contains related permissions for a specific toolchain or category.

### How Modules Work

The main `allow.json` is generated by composing modules:

```json
{
  "permissions": [
    // From core.json:
    "Read(**)",
    "Glob(**)",
    "Bash(git status:*)",

    // From python.json:
    "Bash(python --version:*)",
    "Bash(pip list:*)",

    // From nodejs.json:
    "Bash(npm --version:*)",
    "Bash(npm run:*)",

    // ... more module contents
  ]
}
```

**Benefits:**

- **Reduced token overhead**: Load only needed modules
- **Better organization**: Logically grouped permissions
- **Easier maintenance**: Smaller files are easier to review
- **Modularity**: Compose custom permission sets for specific projects

## Integration with nix-config

### How nix-config Reads Permissions

When nix-config builds (via `darwin-rebuild switch`):

1. The flake input reads this repository:

   ```nix
   inputs.ai-assistant-instructions = {
     url = "github:JacobPEvans/ai-assistant-instructions";
     flake = false;  # Raw files, not a flake
   };
   ```

2. The permissions formatter module reads the JSON files:

   ```nix
   let
     sourcePermissions = builtins.fromJSON
       (builtins.readFile "${inputs.ai-assistant-instructions}/.claude/permissions/allow.json");
   in
   # Apply tool-specific formatters
   ```

3. Tool-specific formatters transform the permissions:

   ```nix
   # For Gemini (simplified example):
   let
     toGeminiFormat = perm:
       if lib.hasPrefix "Bash(" perm
       then lib.replaceStrings ["Bash(" ":*)"] ["run_shell_command(" ")"] perm
       else if perm == "Read(**)" then "read_file"
       else if perm == "Glob(**)" then "glob_tool"
       else if perm == "Grep(**)" then "grep_tool"
       else if lib.hasPrefix "WebFetch(domain:" perm then "web_fetch"
       else perm;
   in map toGeminiFormat sourcePermissions
   ```

   **Note**: This is a simplified example. The actual implementation in nix-config may include
   additional logic for handling edge cases and validation.

4. Generated config files are placed in `~/.gemini/`, `~/.claude/`, etc.

### Keeping Permissions in Sync

After changing permissions in this repo:

```bash
# Commit and push changes
git add .claude/permissions/ .gemini/permissions/
git commit -m "feat: add new permissions for X toolchain"
git push

# Trigger nix-config rebuild
cd ~/git/nix-config/main
git pull  # Gets latest flake input
darwin-rebuild switch
```

## Adding New Permissions

### For Claude

1. **Identify the category** (core, language, platform, system)
2. **Add to appropriate module** or create new module if category doesn't exist
3. **Use the format**: `"Bash(command:*)"` or `"Tool(pattern:*)"`
4. **Update allow.json** by recomposing modules (or add directly if urgent)

Example - adding Python permission:

```json
// .claude/permissions/modules/python.json
{
  "permissions": [
    "Bash(python3 -m venv:*)",  // Add here
    "Bash(pip install:*)"
  ]
}
```

### For Gemini

1. Add to `.gemini/permissions/allow.json`
2. **Use Gemini format**: `"run_shell_command(full command)"`
3. Keep in sync with Claude by translating the command
4. **Remember**: Gemini doesn't support wildcards, so you may need multiple entries for different command variations

Example:

```json
// .gemini/permissions/allow.json
{
  "allowedTools": [
    // Note: These are more restrictive than Claude's wildcard versions
    // Claude's "Bash(python3 -m venv:*)" allows any venv name
    // Gemini would need separate entries for each specific venv path
    "run_shell_command(python3 -m venv .venv)",
    "run_shell_command(python3 -m venv venv)",

    // Similarly, pip install would need entries for each package
    "run_shell_command(pip install numpy)",
    "run_shell_command(pip install pandas)"
  ]
}
```

### Keeping Tools in Sync

After adding a permission to one tool:

1. **Translate to other tools**: Convert the command to each tool's native format
2. **Update both Claude and Gemini**: Both should have equivalent permissions
3. **Commit together**: Keep all permissions synced in one commit
4. **Manually verify**: Until automated tooling exists, manually check that equivalent permissions are defined for each supported tool

**Future Enhancement**: A `/sync-permissions` command may be added to automate detection of
mismatches between tools. Until such tooling exists, manual verification is required.

## Maintenance Guidelines

### Regular Tasks

- **Monthly**: Review for outdated commands (e.g., Python 2 commands)
- **Per PR**: Ensure new permissions are added to all affected tools
- **Per release**: Audit for security implications of new permissions

### Adding New Toolchains

When adding support for a new toolchain (e.g., Go):

1. Create new module in `.claude/permissions/modules/go.json`
2. Add to `.claude/permissions/allow.json` (compose modules)
3. Add equivalent permissions to `.gemini/permissions/allow.json`
4. Update this documentation
5. Create PR with clear description of new toolchain
6. Update nix-config to include the new formatter if needed

### Removing Permissions

When removing a permission (rare):

1. Check all workflows and automation that use it
2. Remove from all affected tools (Claude, Gemini)
3. Document reason in commit message
4. Notify users if permission is commonly used

## Testing

### Verify Permission Formats

```bash
# Validate Claude permission JSON
jq . .claude/permissions/allow.json

# Validate Gemini permission JSON
jq . .gemini/permissions/allow.json
```

### After nix-config Update

After running `darwin-rebuild switch`:

```bash
# Check generated Claude config
cat ~/.claude/settings.json | jq .permissions | head

# Check generated Gemini config
cat ~/.gemini/config.yaml | grep -A5 "allowedTools"
```

## Permission Denial (Explicitly Disallowed)

Permissions that are **explicitly denied** are listed in deny.json files and take precedence:

- `.claude/permissions/deny.json` - Commands forbidden for Claude
- `.gemini/permissions/deny.json` - Commands forbidden for Gemini

Examples of explicitly denied commands:

- `Bash(rm -rf /*)` - Recursive delete system directories
- `Bash(git commit --no-verify:*)` - Bypass security hooks
- `Read(.env*)` - Environment variable files with secrets

## Related Issues & PRs

- **Issue #135**: Unify permission definitions with nix-config

## Future Improvements

- [ ] Implement `/sync-permissions` command to automate detection of permission mismatches between tools
- [ ] Migrate Gemini to modular structure (gemini/modules/)
- [ ] Create unified tool-agnostic schema (Option C)
- [ ] Add Copilot permission formatting
- [ ] Add OpenCode permission formatting
- [ ] Automated permission audit (identify unused/dangerous perms)
- [ ] Permission version tracking (diff across tool releases)
