---
name: nix-shell-commands
description: Nix develop shell patterns for infrastructure tooling
---

# Nix Shell Commands

Infrastructure tools run inside Nix develop shells for reproducible environments.

## Pattern

```bash
nix develop <nix-config-path>/shells/<shell> --command bash -c "<command>"
```

The nix-config repo provides shell definitions at `shells/<name>/`.

## Common Shells

### Terraform

Wraps aws-vault + doppler + terragrunt:

```bash
nix develop <nix-config-path>/shells/terraform \
  --command bash -c \
  "aws-vault exec terraform -- doppler run --name-transformer tf-var -- terragrunt plan"
```

### Ansible

Provides ansible, ansible-lint, and molecule:

```bash
nix develop <nix-config-path>/shells/ansible \
  --command bash -c \
  "doppler run -- ansible-playbook -i inventory/hosts.yml playbooks/site.yml"
```

### Packer

Provides packer and required plugins:

```bash
nix develop <nix-config-path>/shells/packer \
  --command bash -c \
  "doppler run -- packer build template.pkr.hcl"
```

## Notes

- Shells are defined in the nix-config repo under `shells/`
- Each shell pins exact tool versions via Nix flakes
- Use `--command bash -c` to run commands inside the shell
- The nix-config path should be configured via environment variable or relative reference
