# Modular Permissions System

This directory contains modular permission sets that reduce token overhead and improve maintainability of the permissions configuration.

## Purpose

Instead of maintaining a single monolithic `allow.json` with 400+ rules, the modular system organizes permissions into focused, reusable modules:

- **core.json**: Universal tools and commands safe for all contexts
- **webfetch.json**: Domain allowlist for WebFetch tool
- **Language modules**: Language-specific toolchains (python, nodejs, rust, go, ruby)
- **Platform modules**: Platform and infrastructure toolchains (docker, kubernetes, terraform, aws, nix)
- **System modules**: Package managers and environment tools (system, asdf, redis, orb)

## Structure

```text
permissions/
├── allow.json                 # Main permissions file (legacy, being phased out)
├── modules/
│   ├── README.md             # This file
│   ├── core.json             # Universal safe commands
│   ├── webfetch.json         # WebFetch domain allowlist
│   ├── python.json           # Python toolchain
│   ├── nodejs.json           # Node.js toolchain
│   ├── rust.json             # Rust toolchain
│   ├── go.json               # Go toolchain
│   ├── ruby.json             # Ruby toolchain
│   ├── docker.json           # Docker toolchain
│   ├── kubernetes.json       # Kubernetes toolchain
│   ├── terraform.json        # Terraform/Terragrunt
│   ├── aws.json              # AWS CLI toolchain
│   ├── nix.json              # Nix ecosystem
│   ├── system.json           # System package managers
│   ├── asdf.json             # Version management
│   ├── redis.json            # Redis CLI
│   └── orb.json              # Orbstack toolchain
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

### webfetch.json

Domain allowlist for the WebFetch tool:

- **Documentation sites**: github.com, githubusercontent.com, anthropic.com, readthedocs.io, mozilla.org
- **Package registries**: npmjs.com, pypi.org
- **Language docs**: python.org, rust-lang.org, typescriptlang.org
- **Infrastructure**: nixos.org, hashicorp.com, terraform.io, docker.com, kubernetes.io
- **AI/Dev tools**: openai.com, geminicli.com, google.dev
- **Community**: stackoverflow.com

### python.json

Python development toolchain:

- **Python**: python, python3 version and module execution
- **Package managers**: pip, pip3 (list, show, freeze)
- **Poetry**: poetry run, shell, show, version
- **Version management**: pyenv versions, global, local
- **Testing**: pytest and variants
- **Virtual environments**: venv, virtualenv
- **Conda**: conda, mamba, micromamba (info, list, env list, activate/deactivate)

### nodejs.json

Node.js development toolchain:

- **Node.js**: node version
- **npm**: version, list, run scripts (test, build, lint, dev, start), outdated, audit, view
- **Yarn**: version, run scripts
- **pnpm**: version, run scripts
- **Version managers**: nvm, fnm, nodenv (version, list, current, which)

### rust.json

Rust development toolchain:

- **Cargo**: version, build, test, run, check, fmt, clippy, clean, update, search, tree
- **Compiler**: rustc version
- **Toolchain**: rustup version, update, show, default

### go.json

Go development toolchain:

- **Version management**: goenv versions, version, which

### ruby.json

Ruby development toolchain:

- **Version management**: rbenv versions, version, which

### docker.json

Docker and container toolchain:

- **Docker**: version, ps, images, logs, inspect
- **Container operations**: start, stop, restart
- **Image operations**: build, pull, push, tag
- **Docker Compose**: compose commands
- **Docker utilities**: info, cp, context, network, system, volume

### kubernetes.json

Kubernetes toolchain:

- **kubectl**: version, get, describe, logs, port-forward, config, rollout
- **Helm**: version, list, repo, search

### terraform.json

Infrastructure as Code toolchain:

- **Terraform**: version, init, validate, fmt, plan, show, state, providers, output, graph
- **Terragrunt**: version, init, validate, plan, show, state, output, graph-dependencies, hclfmt

### aws.json

AWS cloud toolchain:

- **AWS CLI**: version, sts, s3, ec2, lambda, cloudformation, logs, dynamodb
- **aws-vault**: version, list

### nix.json

Nix ecosystem:

- **Nix**: version, config, search, flake operations, build, develop, shell, run, eval, repl, path-info, why-depends, hash, store operations
- **Legacy Nix**: nix-env, nix-shell, nix-instantiate, nix-store, nix-collect-garbage, nix-prefetch-url, nix-prefetch-git
- **Nix utilities**: nix-locate, nix-tree, nix-diff, nixfmt, statix, deadnix
- **Darwin**: darwin-rebuild (switch, build, list-generations, rollback)
- **Read permissions**: /nix/store paths

### system.json

System-level package managers and environment tools:

- **Homebrew**: brew (list, search, info, version, doctor, config, outdated, deps)
- **Devbox**: devbox (info, list, version)
- **Devenv**: devenv (info, version)
- **Direnv**: direnv (status, reload)
- **Cachix**: cachix (list)

### asdf.json

Version management toolchain:

- **asdf**: asdf (version, list, current, info, where, which, plugin list)
- **mise**: mise (version, list, current, doctor, env, where, which)

### redis.json

Redis database CLI:

- **redis-cli**: redis-cli (version, ping, info, get)

### orb.json

Orbstack container management:

- **orb**: orb (help, list, info)
- **orbctl**: orbctl (help, doctor, info, config get, version)

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

1. Phase 1 (Completed): Create core.json with universal commands and initial toolchain modules
2. Phase 2 (Completed): Standardize all modules to use consistent object format and complete language-specific modules
   (python.json, nodejs.json, rust.json, go.json, ruby.json)
3. Phase 3 (Completed): Extract platform and system toolchains (docker.json, kubernetes.json, terraform.json, aws.json, nix.json,
   system.json, asdf.json, redis.json, orb.json)
4. Phase 4: Update tools to load modular permissions
5. Phase 5: Deprecate monolithic allow.json

## Benefits

- **Reduced Token Overhead**: Load only needed permissions instead of 400+ rules
- **Clarity**: Each module has a single, clear purpose
- **Reusability**: Modules can be combined for different contexts
- **Maintainability**: Smaller files are easier to review and update
- **Scalability**: New toolchains can add modules without cluttering core
- **Documentation**: Module README serves as discoverable reference
- **Tool Integration**: Forms the basis for unified permission system with nix-config

## Integration with nix-config

These modular permissions are the **source of truth** for all AI tool permissions. The nix-config
repository reads these JSON definitions at build time and applies tool-specific formatters to
generate configurations for Claude, Gemini, Copilot, and other tools.

See [Permission System Integration](../../../agentsmd/docs/permission-system.md) for complete
documentation on how this integrates with nix-config.
