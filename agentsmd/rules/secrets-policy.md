---
description: Never commit secrets, credentials, or sensitive data to git — use variable references
---

# Secrets Policy

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
