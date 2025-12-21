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
└── domains/        # Allowed domains for web fetching
    └── webfetch.json
```

## Format

### Command Files (allow/ and deny/)

```json
{
  "commands": [
    "command-name",
    "command-name arg",
    ...
  ]
}
```

### Domains File (domains/)

```json
{
  "domains": [
    "example.com",
    ...
  ]
}
```

## Usage

Tools like Claude, Gemini, and Copilot can load these permissions by:

1. Reading all JSON files in `allow/` and `deny/` directories
2. Converting commands to tool-specific permission format
3. Applying them to the tool's permission system

For example, to convert to Claude's format:

- `"git status"` → `"Bash(git status:*)"`
- `"curl -X GET"` → `"Bash(curl -X GET:*)"`

## Maintenance

- Keep commands organized by domain (git, docker, python, etc.)
- Add new commands to appropriate category files
- Use specific command patterns where possible
- Document any tool-specific quirks in this README
