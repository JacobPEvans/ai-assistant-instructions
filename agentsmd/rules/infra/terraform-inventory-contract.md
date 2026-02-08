---
name: terraform-inventory-contract
description: Contract between terraform outputs and ansible dynamic inventory
---

# Terraform Inventory Contract

Terraform outputs from `terraform-proxmox` feed ansible dynamic inventory.

## Output Format

The `ansible_inventory` output produces JSON with host groups, IPs, and ports:

```json
{
  "splunk": {
    "hosts": ["192.168.0.200"],
    "vars": {
      "ansible_port": 22,
      "ansible_user": "ansible"
    }
  },
  "cribl_edge": {
    "hosts": ["192.168.0.181", "192.168.0.182"],
    "vars": {
      "ansible_port": 22
    }
  }
}
```

## Consumption

Ansible repos use a dynamic inventory plugin that reads terraform state:

1. Terraform writes outputs to state file
2. Ansible inventory plugin queries terraform state
3. Host groups, IPs, and connection vars are populated automatically

## Contract Rules

- Terraform owns IP assignment (derived from VMID)
- Terraform owns port assignment (syslog, netflow, HEC)
- Ansible consumes but never overrides these values
- Changes to IPs/ports must originate in terraform-proxmox
