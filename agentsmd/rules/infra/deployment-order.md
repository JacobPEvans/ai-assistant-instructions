---
name: deployment-order
description: Infrastructure deployment pipeline order and dependencies
---

# Deployment Order

Infrastructure changes flow through a strict pipeline. Each stage depends on the prior stage.

## Pipeline

```text
terraform-proxmox       Provision VMs/containers on Proxmox VE
        |
        v
ansible-proxmox         Configure Proxmox host (kernel, swap, monitoring)
        |
        v
ansible-proxmox-apps    Configure applications (Cribl, HAProxy, etc.)
        |
        v
ansible-splunk          Configure Splunk Enterprise
```

## Stage Dependencies

1. **terraform-proxmox**: No dependencies. Creates VMs, assigns IPs, opens ports.
2. **ansible-proxmox**: Requires Proxmox host accessible. Configures host-level settings.
3. **ansible-proxmox-apps**: Requires VMs provisioned by terraform. Installs and configures apps.
4. **ansible-splunk**: Requires Splunk VM provisioned and base-configured. Deploys Splunk config.

## Partial Runs

Not every change requires the full pipeline:

- **New VM**: Full pipeline (terraform -> ansible)
- **App config change**: ansible-proxmox-apps only
- **Splunk config**: ansible-splunk only
- **Host tuning**: ansible-proxmox only
- **Network/firewall**: terraform-proxmox, then affected ansible stages
