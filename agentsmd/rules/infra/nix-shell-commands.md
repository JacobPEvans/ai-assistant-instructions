---
name: nix-shell-commands
description: Nix develop shell patterns for infrastructure tooling
---

# Nix Shell Commands

Infrastructure tools run inside per-repo Nix develop shells for reproducible environments.
direnv handles this automatically — manual `nix develop` is for one-off commands only.

## Pattern

Each repo defines its own `flake.nix` with a `devShells.default`. When you `cd` into the
repo directory, direnv activates the shell automatically.

For one-off commands without entering the shell:

```bash
nix develop --command bash -c "<command>"
```

## Common Shells

### Terraform

Wraps aws-vault + doppler + terragrunt (from the repo's local flake):

```bash
nix develop --command bash -c \
  "aws-vault exec terraform -- doppler run --name-transformer tf-var -- terragrunt plan"
```

### Ansible

Provides ansible, ansible-lint, and molecule:

```bash
nix develop --command bash -c \
  "doppler run -- ansible-playbook -i inventory/hosts.yml playbooks/site.yml"
```

### Packer

Provides packer and required plugins:

```bash
nix develop --command bash -c \
  "doppler run -- packer build template.pkr.hcl"
```

## Notes

- Each repo owns its own `flake.nix` defining `devShells.default`
- Each shell pins exact tool versions via Nix flakes
- Use `--command bash -c` to run commands inside the shell
- direnv with `use flake` in `.envrc` auto-activates shells on `cd`
- See `dev-shell-architecture.md` for the full per-repo devShell pattern
- These are direct execution patterns for Bash tool calls, not templates for script files (see the direct-execution rule)
