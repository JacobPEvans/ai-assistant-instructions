# Tool-Agnostic Permissions

This directory contains tool-agnostic permission configurations that can be used across Claude, Gemini, Copilot, and other AI assistants.

## Structure

```text
permissions/
├── allow/          # Commands that are allowed
│   ├── git.json
│   ├── gh.json
│   ├── nix.json
│   ├── docker.json
│   ├── python.json
│   ├── nodejs.json
│   ├── rust.json
│   ├── aws.json
│   ├── terraform.json
│   ├── system.json
│   ├── network.json
│   └── tools.json
├── deny/           # Commands that are denied
│   ├── dangerous.json
│   ├── network.json
│   ├── shell.json
│   └── git.json
├── ask/            # Commands that require explicit user confirmation
│   ├── python.json
│   └── gh.json
└── domains/        # Allowed domains for web fetching
    └── webfetch.json
```

## Format

### Command Files (allow/, ask/, and deny/)

**CRITICAL**: Commands should NOT include the `*` wildcard suffix. The Nix
formatter automatically appends `*` when generating tool-specific permissions.

**Correct format:**

```json
{
  "commands": [
    "git",
    "docker",
    "git merge",
    "npm run"
  ]
}
```

**Incorrect format (DO NOT USE):**

```json
{
  "commands": [
    "git *",       // WRONG - creates Bash(git * *)
    "docker *",    // WRONG - creates Bash(docker * *)
    "git merge *"  // WRONG - creates Bash(git merge * *)
  ]
}
```

### Why No Wildcard Suffix?

The Nix permission formatter (`formatters.nix`) automatically appends
a space-wildcard (`*`) when generating the final `Bash(cmd *)` format.
Adding a wildcard suffix in source files results in invalid
double-wildcard patterns:

- **Correct**: `"git"` → `"Bash(git *)"` (space enforces word boundary)
- **Wrong**: `"git *"` → `"Bash(git * *)"` (double wildcard)

The space format enforces word boundaries: `Bash(nix *)` matches `nix search`
but does NOT match `nix-env` (which is a separate binary).

The validation script (`scripts/validate-permissions.sh`) will reject any
commands ending with `:*` or a trailing wildcard to prevent this mistake.

### Special File Formats

**dangerous.json** in `deny/` includes both commands and file patterns:

```json
{
  "commands": ["rm -rf", "sudo rm"],
  "patterns": ["~/.ssh/*", "~/.aws/*"]
}
```

**webfetch.json** in `domains/` uses domains array:

```json
{
  "domains": [
    "github.com",
    "anthropic.com"
  ]
}
```

## Tool-Specific Conversion

The Nix formatter converts these tool-agnostic commands into tool-specific
formats:

**Claude Code:**

- Source: `"git"` → Output: `"Bash(git *)"`
- Source: `"git merge"` → Output: `"Bash(git merge *)"`

**Gemini CLI:**

- Source: `"git"` → Output: `"ShellTool(git)"`
- Source: `"git merge"` → Output: `"ShellTool(git merge)"`

## Maintenance

- Keep commands organized by domain (git, docker, python, etc.)
- Add new commands to appropriate category files
- Use specific command patterns where possible
- Document any tool-specific quirks in this README
