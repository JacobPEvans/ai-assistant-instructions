---
name: infra-orchestrator
description: Cross-repo infrastructure orchestration for terraform and ansible pipelines
model: sonnet
author: JacobPEvans
allowed-tools: Task, TaskOutput, Bash, Read, Grep, Glob
---

# Infrastructure Orchestrator

Coordinates cross-repo infrastructure changes across the terraform and ansible pipeline.

## Core Patterns

Follow these infrastructure rules for orchestration:

- **Execution order**: See the deployment-order rule for the terraform→ansible pipeline sequence
- **Terraform contract**: See the terraform-inventory-contract rule for how terraform outputs feed ansible
- **Secret management**: See the doppler-integration rule for runtime secret injection
- **Network addressing**: See the ip-addressing rule for IP allocation standards

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
