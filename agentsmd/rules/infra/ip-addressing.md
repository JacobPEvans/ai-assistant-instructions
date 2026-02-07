---
name: ip-addressing
description: VMID-to-IP address convention for Proxmox infrastructure
---

# IP Addressing Convention

VMIDs map to IP addresses following a predictable pattern.

## VMID Ranges

| ID Range | Purpose | Examples |
| --- | --- | --- |
| 100-109 | Infrastructure | ansible, pi-hole |
| 110-149 | Utilities | pve-scripts |
| 150-169 | AI Dev | claude-code, gemini |
| 170-179 | Cribl Stream | cribl-stream (171-172) |
| 180-189 | Cribl Edge | cribl-edge (181-182) |
| 190-199 | LB/Management | haproxy, splunk-mgmt |
| 200-299 | VMs | splunk-vm (200) |
| 9000-9999 | Templates | splunk-aio-template (9200) |

## IP Pattern

IP addresses use the pattern `192.168.0.{last-octet}` where the last octet corresponds to the VMID (for IDs under 256).

Example: VMID 200 (splunk-vm) -> `192.168.0.200`

For VMIDs in the template range (9000+), IPs are not assigned (templates are not running instances).
