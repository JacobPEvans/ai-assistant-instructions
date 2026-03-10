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

- **Execution order**: See the deployment order section of the `/infrastructure-standards` skill (in the `infra-standards` plugin) for the terraform->ansible pipeline
- **Terraform contract**: See the terraform inventory contract section of the `/infrastructure-standards` skill (in the `infra-standards` plugin)
- **Secret management**: See the Doppler integration section of the `/infrastructure-standards` skill (in the `infra-standards` plugin)
- **Network addressing**: See the IP addressing section of the `/infrastructure-standards` skill (in the `infra-standards` plugin)

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
