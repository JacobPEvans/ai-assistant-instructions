# Permission System Integration with nix-config

> **⚠️ OUTDATED DOCUMENTATION**: This document describes the old permission system structure
> (`.claude/permissions/`).
>
> **For current documentation**, see:
>
> - [agentsmd/permissions/STRATEGY.md](../permissions/STRATEGY.md) - Current hierarchical
>   permission architecture
> - [nix-config/modules/home-manager/ai-cli/common/permissions.nix](https://github.com/JacobPEvans/nix) -
>   Current nix-config integration
>
> The permission system was refactored in PR #372 (Dec 2025) to use a unified structure at
> `agentsmd/permissions/` with tool-agnostic JSON files that nix-config transforms into
> tool-specific formats.

## New Architecture (Post-PR #372)

```text
ai-assistant-instructions (THIS REPO)
└── agentsmd/permissions/       # Unified permission source (tool-agnostic)
    ├── allow/                  # Auto-approved commands
    │   ├── core.json           # Essential tool wildcards (git:*, docker:*, etc.)
    │   ├── git.json            # Specific git commands
    │   ├── python.json         # Python toolchain
    │   └── ... (13 files)
    ├── ask/                    # Requires confirmation
    │   ├── git.json            # Dangerous git operations
    │   ├── package-managers.json  # npm:*, pip:*, cargo:* (blanket wildcards)
    │   └... (10 files)
    ├── deny/                   # Permanently blocked
    │   ├── dangerous.json      # rm -rf /, sensitive file reads
    │   ├── git.json            # Hook bypass attempts
    │   └── ... (4 files)
    └── domains/
        └── webfetch.json       # Allowed WebFetch domains

                    ↓ (nix-config reads at build time)

nix-config
├── modules/home-manager/ai-cli/common/
│   ├── permissions.nix         # Reads agentsmd/permissions/
│   └── formatters.nix          # Tool-specific formatters
│       ├── claude.formatShellCommand = cmd: "Bash(${cmd}:*)"
│       ├── gemini.formatShellCommand = cmd: "ShellTool(${cmd})"
│       └── copilot.formatShellCommand = cmd: "shell(${cmd})"
```

## Key Changes

1. **Single source of truth**: `agentsmd/permissions/` replaces both `.claude/permissions/` and
   `.gemini/permissions/`
2. **Tool-agnostic format**: JSON files contain plain commands (`"git status"`) - nix-config adds
   tool-specific wrappers
3. **Hierarchical security**: Deny > Ask > Allow precedence with coarse-to-specific patterns
4. **Modular organization**: Permissions split into focused files (git.json, python.json, etc.)

See [STRATEGY.md](../permissions/STRATEGY.md) for complete documentation.

---

## Historical Documentation (Pre-PR #372)

This section preserved for reference only. The system described below was replaced in December 2025.

### Old Architecture

```text
ai-assistant-instructions (THIS REPO)
├── .claude/permissions/        # Claude permission source (DELETED)
│   ├── allow.json             # Main allow list
│   ├── ask.json               # Ask-first list
│   ├── deny.json              # Deny list
│   └── modules/               # Modular permission sets
│       ├── core.json
│       ├── python.json
│       ├── nodejs.json
│       └── ... (specialized modules)
│
└── .gemini/permissions/        # Gemini permission source (DELETED)
    ├── allow.json             # Allow list
    └── deny.json              # Deny list
```

The rest of this document describes the old system and is preserved for historical reference only.
