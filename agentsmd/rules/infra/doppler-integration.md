---
name: doppler-integration
description: Doppler secret management patterns for infrastructure repos
---

# Doppler Integration

All infrastructure repos use Doppler for secret management.

## Configuration

- **Project**: `iac-conf-mgmt`
- **Config**: `prd` (production)

## Usage Patterns

### Terraform

Doppler transforms environment variables to `TF_VAR_` prefix:

```bash
doppler run --name-transformer tf-var -- terragrunt plan
```

Combined with aws-vault for AWS credentials:

```bash
aws-vault exec terraform -- doppler run --name-transformer tf-var -- terragrunt apply
```

### Ansible

Doppler injects secrets as environment variables:

```bash
doppler run -- ansible-playbook -i inventory/hosts.yml playbooks/site.yml
```

### Packer

Same pattern as terraform but without aws-vault (unless building AWS AMIs):

```bash
doppler run -- packer build template.pkr.hcl
```

## Required Secrets

Each repo documents its required Doppler secrets in `.docs/`. Common ones:

- `PROXMOX_VE_*` - Proxmox API connection
- `PROXMOX_SSH_*` - SSH access to Proxmox host
- AWS credentials (for terraform-aws repos)
