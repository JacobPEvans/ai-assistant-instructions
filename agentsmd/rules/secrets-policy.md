---
description: Never commit secrets, credentials, real IPs, or sensitive data to git — use variable references and scrubbed values
---

# Secrets & Sensitive Data Policy

**CRITICAL**: Never commit sensitive data to git. All git-committed files must use scrubbed values and variable references.

## What NOT to Commit

- API tokens, credentials, passwords
- Real IP addresses (internal or external)
- Real domain names or hostnames
- SSH private keys or certificates
- Database credentials
- AWS account IDs, ARNs, or API keys
- Encryption keys or secrets
- User-specific absolute paths

## Scrubbed Values

| Type | Scrubbed Value | Examples |
| --- | --- | --- |
| IPv4 Address | `192.168.0.*` | Last octet can be accurate |
| IPv6 Address | `2001:db8::*` | Documentation prefix |
| External Domain | `example.com` | Public services and APIs |
| Internal Domain | `example.local` | LAN hostnames and services |
| API Endpoint | `https://api.example.com:8006/api2/json` | Scrubbed domain pattern |
| Username | `terraform`, `admin`, `user` | Generic role-based names |
| Tokens/Keys | `your-token-here` or `<token>` | Clearly marked placeholder |

## Portable Path References

**NEVER commit absolute user paths** (`/Users/{username}/*`, `/home/{username}/*`, `$HOME/*`, `~/*`).

| Bad (User-Specific) | Good (Portable) | Use Case |
| --- | --- | --- |
| `/Users/john/.local/bin/tool` | `tool` | PATH lookup |
| `entry: /Users/john/.local/bin/ansible-lint` | `entry: ansible-lint` | Pre-commit hooks |
| `~/.ssh/id_rsa` | `# /path/to/your/ssh/key` | Templates |
| `$HOME/git/nix-config/main` | `${NIX_CONFIG_PATH}/main` | Env var for external paths |
| `/home/user/project/file.txt` | `./file.txt` | Relative paths within project |

## Variable References

Always use variable indirection for sensitive values:

```hcl
# CORRECT
provider "proxmox" {
  pm_api_url      = var.proxmox_api_endpoint
  pm_api_token_id = var.proxmox_api_token
}

# WRONG - hardcoded real values
provider "proxmox" {
  pm_api_url      = "https://192.168.0.52:8006/api2/json"
  pm_api_token_id = "terraform@pam!abc123xyz="
}
```

## Runtime Secret Injection

- **AI/Claude Projects**: macOS Keychain (`ai-secrets` keychain), never in files or env vars
- **Doppler**: `doppler run --name-transformer tf-var` for infrastructure
- **SOPS + age**: Encrypt secrets at rest in git
- **Environment Variables**: CI/CD secrets or local .env (never committed)
- **AWS Secrets Manager / Parameter Store**: For AWS deployments
- **SSH Agent**: Agent forwarding only, never commit keys
