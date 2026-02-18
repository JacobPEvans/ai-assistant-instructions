# Secrets & Sensitive Data Policy

**CRITICAL**: Never commit sensitive data to git. All git-committed files must use scrubbed values and variable references.

## What NOT to Commit

❌ API tokens, credentials, passwords
❌ Real IP addresses (internal or external)
❌ Real domain names or hostnames
❌ SSH private keys or certificates
❌ Database credentials
❌ AWS account IDs, ARNs, or API keys
❌ Encryption keys or secrets
❌ User-specific absolute paths

## Scrubbed Values for Git-Committed Files

Use these placeholders consistently across all repositories:

| Type | Scrubbed Value | Examples |
| --- | --- | --- |
| IPv4 Address | `192.168.0.*` | `192.168.0.1`, `192.168.0.100` (last octet can be accurate) |
| IPv6 Address | `2001:db8::*` | `2001:db8::1` (documentation prefix) |
| External Domain | `example.com` | For external/public services and APIs |
| Internal Domain | `example.local` | For internal/LAN hostnames and services |
| API Endpoint | `https://api.example.com:8006/api2/json` | Use scrubbed domain pattern |
| Username | `terraform`, `admin`, `user` | Generic role-based names |
| Tokens/Keys | `your-token-here` or `<token>` | Clearly marked as placeholder |

## Portable Path References

**NEVER commit absolute user paths in git-tracked files.** This includes `/Users/{username}/*`, `/home/{username}/*`, `$HOME/*`, and `~/*` patterns. Use these alternatives:

| Bad (User-Specific) | Good (Portable) | Use Case |
| --- | --- | --- |
| `/Users/john/.local/bin/tool` | `tool` | Use PATH lookup for system commands |
| `entry: /Users/john/.local/bin/ansible-lint` | `entry: ansible-lint` | Pre-commit hooks, scripts |
| `~/.ssh/id_rsa` | Placeholder comment (e.g., `# /path/to/your/ssh/key`) | Example files, templates |
| `$HOME/git/nix-config/main` | `${NIX_CONFIG_PATH}/main` (env var) | Configurable paths in scripts |
| `/home/user/project/file.txt` | `./file.txt` or `../file.txt` | Relative paths within project |

**When to use environment variables:**

- Scripts that reference external projects
- Tool paths that vary by installation
- Any path outside the current repository

**When to use relative paths:**

- Files within the same repository
- Cross-references between project files

**When to comment out with placeholders:**

- Example configuration files (`.example` suffix)
- Template files that users copy and customize

## Variable References in Git-Committed Code

Always use variable indirection for sensitive values in code committed to any branch:

```hcl
# ✅ CORRECT - References variables
provider "proxmox" {
  pm_api_url      = var.proxmox_api_endpoint
  pm_api_token_id = var.proxmox_api_token
  pm_user         = var.proxmox_username
}

# ❌ WRONG - Hardcoded real values
provider "proxmox" {
  pm_api_url      = "https://192.168.1.52:8006/api2/json"
  pm_api_token_id = "terraform@pam!abc123xyz="
  pm_user         = "terraform@pam"
}
```

## Runtime Secret Injection

**AI/Claude Projects:**
API keys are retrieved at runtime from macOS Keychain (`ai-secrets` keychain).
Keys are NEVER stored in files or environment variables.

**Infrastructure Projects:**
Inject secrets at runtime via secure channels:

- **Doppler**: Centralized secret management with `doppler run --name-transformer tf-var`
- **SOPS + age**: Encrypt secrets at rest in git (see the sops-integration rule)
- **Environment Variables**: CI/CD secrets or local .env (never committed)
- **AWS Secrets Manager / Parameter Store**: For AWS deployments
- **SSH Agent**: For private keys (agent forwarding only, never commit keys)
- **HashiCorp Vault**: For large organizations with compliance needs

See the `.docs/` folder at the repository root (not in worktrees) for project-specific implementation patterns.

## Documentation & Configuration Examples

```yaml
# ✅ GOOD - Scrubbed values with variable references
services:
  database:
    host: db.example.local
    port: 5432
    username: postgres
    password: ${DATABASE_PASSWORD}

  api:
    endpoint: https://api.example.com:8080
    token: ${API_TOKEN}

# ❌ BAD - Real values and hardcoded secrets
services:
  database:
    host: db-prod.company.internal
    port: 5432
    username: postgres
    password: SuperSecure!Pass123

  api:
    endpoint: https://api.example.com
    token: <actual-jwt-token-value>
```

## Pre-Commit Safety

GitHub secret scanning and branch protection help, but **personal responsibility is critical**:

- Review all diffs before committing
- Never copy-paste real credentials into code
- Use IDE plugins that highlight secrets
- If you accidentally commit secrets, revoke them immediately
