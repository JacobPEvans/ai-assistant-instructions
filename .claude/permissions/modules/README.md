# Modular Permissions System

This directory contains modular permission sets that reduce token overhead and improve maintainability of the permissions configuration.

## Purpose

Instead of maintaining a single monolithic `allow.json` with 400+ rules, the modular system organizes permissions into focused, reusable modules:

- **core.json**: Universal tools and commands safe for all contexts
- **Future modules**: Toolchain-specific permissions (python, rust, nodejs, docker, terraform, etc.)

## Structure

```text
permissions/
├── allow.json                 # Main permissions file (legacy, being phased out)
├── modules/
│   ├── README.md             # This file
│   └── core.json             # Universal safe commands
```

## Available Modules

### core.json

Universal commands and tools that should be available in all contexts:

- **Tools**: Read, Glob, Grep, WebSearch, TodoWrite, TodoRead, SlashCommand
- **Git**: All git commands (status, log, diff, show, branch, checkout, commit, push, pull, fetch, stash, worktree, etc.)
- **GitHub CLI**: PR and issue management (list, view, create, comment, etc.)
- **Unix utilities**: ls, cat, head, tail, grep, find, tree, mkdir, touch, ln, diff, sort, uniq, jq, yq, etc.
- **System utilities**: whoami, hostname, uname, date, uptime, which, ps, top, df, du
- **Network (read-only)**: curl (GET only), ping, nslookup, dig, host, netstat, lsof
- **Development tools**: claude doctor, check-jsonschema, markdownlint-cli2, pre-commit
- **Utilities**: env, type, time, timeout, ssh-add (list only)
- **WebFetch**: GitHub, Anthropic domains

### Future Modules (Placeholders)

- **python.json**: Python tools, pip, poetry, pytest, pyenv, virtualenv, conda
- **nodejs.json**: Node.js, npm, yarn, pnpm, nvm, fnm
- **rust.json**: Cargo, rustc, rustup
- **docker.json**: Docker, docker-compose, container registry commands
- **kubernetes.json**: kubectl, helm
- **terraform.json**: Terraform, terragrunt, infrastructure code
- **aws.json**: AWS CLI, aws-vault, cloud operations
- **nix.json**: Nix, nixfmt, direnv, devbox, devenv
- **ruby.json**: rbenv, Bundler, Ruby CLI
- **system.json**: System-level commands, brew, package managers

## How to Use

### Option 1: Include in allow.json

Copy the contents of a module directly into `allow.json` when that module is needed:

```json
{
  "permissions": [
    // ... core.json permissions ...
    "Bash(python3:*)",
    "Bash(pip list:*)"
    // ... other module permissions ...
  ]
}
```

### Option 2: Composition in Code

Applications loading permissions can compose modules programmatically:

```python
import json

def load_permissions(modules=['core']):
    """Load and merge permission modules."""
    permissions = []
    for module in modules:
        with open(f'.claude/permissions/modules/{module}.json') as f:
            data = json.load(f)
            permissions.extend(data['permissions'])
    return {"permissions": list(set(permissions))}
```

### Option 3: Configuration Selection

Specify modules in a config file based on project context:

```yaml
# .claude/config.yaml
permissions:
  modules:
    - core
    - python
    - nodejs
    - docker
```

## Maintenance

### Adding New Permissions

1. Identify the category (core, language, toolchain, etc.)
2. Add to appropriate module or create new module
3. Keep each module focused and cohesive
4. Update this README with module description

### Removing Permissions

1. Check if any workflows or commands depend on the permission
2. Remove from the appropriate module
3. Update documentation

### Migrating from Monolithic to Modular

1. Phase 1 (Current): Create core.json with universal commands
2. Phase 2: Extract language-specific commands (python.json, nodejs.json, etc.)
3. Phase 3: Extract toolchain-specific commands (docker.json, terraform.json, etc.)
4. Phase 4: Update tools to load modular permissions
5. Phase 5: Deprecate monolithic allow.json

## Benefits

- **Reduced Token Overhead**: Load only needed permissions instead of 400+ rules
- **Clarity**: Each module has a single, clear purpose
- **Reusability**: Modules can be combined for different contexts
- **Maintainability**: Smaller files are easier to review and update
- **Scalability**: New toolchains can add modules without cluttering core
- **Documentation**: Module README serves as discoverable reference
