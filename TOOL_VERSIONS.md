# AI Assistant Instructions - Development Requirements

These are the minimum required tools and versions for using this repository.

**Nix-First Approach**: All tools can be installed via Nix. Traditional package managers (npm, pip, etc.) are
discouraged to avoid system pollution and ensure reproducibility.

## Required Tools

### GitHub CLI

- Required for PR management, issue operations, and workflow automation
- Minimum version: 2.0.0
- **Temporary use**: `nix-shell -p gh`
- **Permanent install**: Add `gh` to nixpkgs
- Verification: `gh --version`

```text
gh>=2.0.0
```

### Git

- Required for version control and worktree management
- Minimum version: 2.30.0 (for worktree support)
- **Temporary use**: `nix-shell -p git`
- **Permanent install**: Add `git` to nixpkgs
- Verification: `git --version`

```text
git>=2.30.0
```

### jq

- Required for JSON parsing and manipulation in shell scripts
- Minimum version: 1.6
- **Temporary use**: `nix-shell -p jq`
- **Permanent install**: Add `jq` to nixpkgs
- Verification: `jq --version`

```text
jq>=1.6
```

## Optional Tools for Development

### Pre-commit

- For local hook validation
- Minimum version: 2.20.0
- **Temporary use**: `nix-shell -p pre-commit`
- **Permanent install**: Add `pre-commit` to nixpkgs
- Alternative (not recommended): `pip install pre-commit`
- Verification: `pre-commit --version`

```text
pre-commit>=2.20.0
```

### markdownlint-cli2

- For markdown linting validation
- Minimum version: 0.11.0
- **Temporary use**: `nix-shell -p markdownlint-cli2`
- **Permanent install**: Add `markdownlint-cli2` to nixpkgs
- Alternative (not recommended): `npm install -g @markdownlint/cli2`
- Verification: `markdownlint-cli2 --version`

```text
markdownlint-cli2>=0.11.0
```

### shellcheck

- For shell script validation (recommended)
- Minimum version: 0.8.0
- **Temporary use**: `nix-shell -p shellcheck`
- **Permanent install**: Add `shellcheck` to nixpkgs
- Alternative (not recommended): `brew install shellcheck` (macOS) or `apt-get install shellcheck` (Linux)
- Verification: `shellcheck --version`

```text
shellcheck>=0.8.0
```

### yamllint

- For YAML validation
- Minimum version: 1.26.0
- **Temporary use**: `nix-shell -p yamllint`
- **Permanent install**: Add `yamllint` to nixpkgs
- Alternative (not recommended): `pip install yamllint`
- Verification: `yamllint --version`

```text
yamllint>=1.26.0
```

## Why Nix?

**Nix provides**:

- **No system pollution**: No global node_modules, site-packages, or ~/.cargo
- **Reproducibility**: Same environment across all machines
- **Declarative**: Dependencies defined in flake.nix or shell.nix
- **Isolation**: Each project gets its own environment

**Traditional package managers (npm, pip, cargo) are discouraged** and require explicit confirmation
when used. See [Permission Strategy](agentsmd/permissions/STRATEGY.md#nix-first-philosophy) for details.
