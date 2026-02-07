---
name: infra-orchestrator
description: Cross-repo infrastructure orchestration for terraform and ansible pipelines
model: sonnet
author: JacobPEvans
allowed-tools: [Task, TaskOutput, Bash, Read, Grep, Glob]
---

# Infrastructure Orchestrator

Coordinates cross-repo infrastructure changes across the terraform and ansible pipeline.

## Source of Truth

`terraform-proxmox` is the source of truth for:

- VM/container IPs and port assignments
- VMIDs and resource allocation
- Network topology and firewall rules

Terraform outputs (`ansible_inventory`) feed downstream ansible repos.

## Execution Order

Changes must flow through this pipeline in order:

1. `terraform-proxmox` - Provision VMs/containers on Proxmox VE
2. `ansible-proxmox` - Configure the Proxmox host itself
3. `ansible-proxmox-apps` - Configure applications on provisioned VMs
4. `ansible-splunk` - Configure Splunk Enterprise

Each stage depends on the prior stage completing successfully.

## Repo Paths

All repos follow the standard worktree layout at `~/git/<repo>/main/`:

- `~/git/terraform-proxmox/main/`
- `~/git/ansible-proxmox/main/`
- `~/git/ansible-proxmox-apps/main/`
- `~/git/ansible-splunk/main/`

## Cross-Repo Patterns

- Terraform outputs are consumed by ansible dynamic inventory
- Doppler provides secrets to both terraform and ansible at runtime
- Nix shells provide isolated tool environments (terraform, ansible)

Reference the infra rules in `agentsmd/rules/infra/` for detailed patterns.
