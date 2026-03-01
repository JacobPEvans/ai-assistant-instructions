---
name: dev-shell-architecture
description: Per-repo devShell pattern using Nix flakes and direnv
---

# Dev Shell Architecture

Every repo owns its own dev shell. There is no central shell registry.

## Core Pattern

```text
repo/
├── flake.nix      ← defines devShells.default
├── flake.lock     ← pins nixpkgs independently
├── .envrc         ← contains: use flake (committed to git)
└── .direnv/       ← gitignored cache directory
```

## Day-to-Day Workflow

1. `cd ~/git/<repo>/main/` → direnv auto-activates the shell
2. New repo? → scaffold with a template (see below)
3. Need to customize? → edit the repo's `flake.nix`

## .envrc Policy

- `.envrc` is **ALWAYS committed** — enables instant setup in any worktree
- `.direnv/` is **ALWAYS in `.gitignore`** — cache dir, never commit
- `.envrc` contains `use flake` (one line) plus optional env var paths (not secrets)
- `SOPS_AGE_KEY_FILE` is a path to a local file, not a secret — safe to commit:

  ```sh
  use flake
  export SOPS_AGE_KEY_FILE=${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}
  ```

- No `NIX_CONFIG_PATH` needed — the flake is local to the repo

## nix-home Templates

nix-home provides scaffolding templates for infrastructure repo types:

| Template | Command | Use for |
| -------- | ------- | ------- |
| `ansible` | `nix flake init -t github:JacobPEvans/nix-home#ansible` | ansible-proxmox, ansible-proxmox-apps |
| `terraform` | `nix flake init -t github:JacobPEvans/nix-home#terraform` | terraform-proxmox, terraform-aws |
| `kubernetes` | `nix flake init -t github:JacobPEvans/nix-home#kubernetes` | kubernetes-monitoring |
| `containers` | `nix flake init -t github:JacobPEvans/nix-home#containers` | container projects |
| `splunk-dev` | `nix flake init -t github:JacobPEvans/nix-home#splunk-dev` | Splunk development (Python 3.9 via uv) |

For standard languages, use community templates:

```sh
nix flake init -t github:the-nix-way/dev-templates#go
nix flake init -t github:the-nix-way/dev-templates#node
nix flake init -t github:the-nix-way/dev-templates#python
```

## Per-Repo Shell Contents

| Repo | Template | Key Tools |
| ---- | -------- | --------- |
| ansible-proxmox | ansible | ansible, molecule, sops, age, python3 |
| ansible-proxmox-apps | ansible | ansible, molecule, sops, age, python3 + SOPS_AGE_KEY_FILE |
| terraform-proxmox | terraform | terraform, terragrunt, opentofu, tfsec, trivy, sops, awscli2 |
| terraform-aws | terraform | terraform, terragrunt, opentofu, tfsec, trivy, sops, awscli2 |
| kubernetes-monitoring | kubernetes | kubectl, helm, helmfile, kubeconform, kube-linter, k9s, kind |
| splunk | splunk-dev | uv (provides Python 3.9 on-demand) |

## Global Packages (Still Available Everywhere)

These remain in `nix-home` global packages (no need for a dev shell to provide them):

- `python314`, `python312` — general scripting
- `uv` — universal Python runner
- `awscli2`, `aws-vault` — used from terminal regardless of project
- `pre-commit` — used in every repo's git hooks
- All linters (shellcheck, shfmt, nixfmt, etc.)
- `jq`

## Manual Activation

direnv handles this automatically. For one-off commands without entering the shell:

```sh
nix develop --command terraform plan
```

For entering the shell manually:

```sh
nix develop    # from repo root with flake.nix
```
