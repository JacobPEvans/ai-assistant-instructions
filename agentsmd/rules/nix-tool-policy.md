# Nix Tool Policy

## Rule: Never Install Tools That Nix Dev Shells Provide

**Scope**: All repositories with `flake.nix` + `.envrc` (Nix dev shell pattern)

## Prohibited Actions

- `pipx install <tool>` / `pipx reinstall <tool>` — pipx virtualenvs reference Nix store Python; breaks after GC
- `pip install <tool>` / `pip3 install <tool>` — same problem, also pollutes global Python
- `uv pip install <tool>` — same Nix store Python problem
- `uv run <tool>` — unnecessary; tools are on PATH from the dev shell
- `brew install <tool>` for tools already in the dev shell — creates version conflicts

## What To Do Instead

1. **Tools are on PATH**: When a repo has `flake.nix` + `.envrc`, all project tools are provided by the Nix dev shell. Run them as bare commands.

2. **If a tool is not found**: Use `direnv exec . <command>` to run within the dev shell environment. This works even when direnv shell hooks haven't fired.

3. **If direnv exec fails**: Use `nix develop --command <command>` as a fallback. This is slower but always works.

4. **Never install globally**: The correct response to a missing tool is activating the dev shell, not installing the tool system-wide.

## Why This Matters

Nix manages Python interpreters in the Nix store (`/nix/store/...`).
Tools installed via pipx/pip create virtual environments that hardcode paths to these interpreters.
When `nix-collect-garbage` runs or a flake update changes the Python version,
those paths become invalid and every pipx/pip-installed tool breaks silently.

The Nix dev shell pattern avoids this by providing tools through the flake lockfile, ensuring consistent, reproducible environments that survive garbage collection.

## Repos Using This Pattern

All JacobPEvans repositories with `flake.nix` + `.envrc`, including:

- ansible-proxmox, ansible-proxmox-apps, ansible-splunk
- terraform-proxmox, terraform-aws, terraform-aws-bedrock
- nix-darwin, nix-ai, nix-home, nix-devenv
- orbstack-kubernetes
