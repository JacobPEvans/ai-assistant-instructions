---
name: sops-integration
description: SOPS + age encryption patterns for infrastructure secrets at rest
---

# SOPS Integration

Encrypt secrets at rest with [SOPS](https://github.com/getsops/sops) and
[age](https://github.com/FiloSottile/age). Doppler remains the runtime
injection layer; SOPS handles secrets that must live in git.

## When to Use SOPS vs Doppler

| Scenario | Tool |
| --- | --- |
| Secrets injected at runtime (env vars) | Doppler |
| Secrets committed to git (encrypted) | SOPS |
| Terraform state encryption | SOPS |
| Ansible vault replacement | SOPS |
| CI/CD pipeline secrets | Doppler |

**Rule**: If a secret must exist in a file checked into git, encrypt it
with SOPS. If it can be injected at runtime, use Doppler.

## Age Key Management

### Key Location

The age private key lives at `~/.config/sops/age/keys.txt` (SOPS default).

### Key Backup

Back up the age private key to Doppler:

```bash
doppler secrets set SOPS_AGE_KEY="$(cat ~/.config/sops/age/keys.txt)" \
  --project iac-conf-mgmt --config prd
```

### Key Generation

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

Extract the public key (for `.sops.yaml`):

```bash
age-keygen -y ~/.config/sops/age/keys.txt
```

## Repository Configuration

Every repo using SOPS needs a `.sops.yaml` at the root:

```yaml
creation_rules:
  - path_regex: \.enc\.ya?ml$
    age: >-
      age1your-public-key-here
  - path_regex: secrets/.*\.ya?ml$
    age: >-
      age1your-public-key-here
```

### Naming Convention

Encrypted files use the `.enc.yml` suffix:

- `secrets.enc.yml` - encrypted
- `secrets.yml` - **never committed** (plaintext, in `.gitignore`)

## Usage Patterns

### Terraform

Use `sops exec-env` to inject decrypted values as environment variables:

```bash
sops exec-env secrets.enc.yml 'doppler run --name-transformer tf-var -- terragrunt plan'
```

Or decrypt inline with the Terraform SOPS provider:

```hcl
data "sops_file" "secrets" {
  source_file = "secrets.enc.yml"
}
```

### Ansible

Replace `ansible-vault` with SOPS-encrypted variable files:

```bash
# Decrypt to stdout, pipe to ansible
sops exec-env secrets.enc.yml 'doppler run -- ansible-playbook -i inventory/hosts.yml site.yml'
```

Or use the `community.sops` collection for native integration:

```yaml
# In a vars file or task
- name: Load encrypted vars
  community.sops.load_vars:
    file: secrets.enc.yml
```

### Encrypt / Decrypt Commands

```bash
# Encrypt a new file
sops --encrypt --age age1your-public-key secrets.yml > secrets.enc.yml

# Edit an encrypted file in-place
sops secrets.enc.yml

# Decrypt to stdout (never redirect to a tracked file)
sops --decrypt secrets.enc.yml
```

## Coexistence with Doppler

SOPS and Doppler serve different layers of the secrets chain:

```text
Doppler (runtime)        SOPS (at rest)
  |                        |
  v                        v
Environment variables    Encrypted files in git
  |                        |
  +--- Both feed into ----+
  |                        |
  v                        v
Terraform / Ansible consume secrets from either source
```

**Precedence**: When both provide the same secret, Doppler (runtime) wins.
The `sops exec-env` wrapper runs first, then `doppler run` overlays.

## Git Safety

Add to `.gitignore` in every repo using SOPS:

```gitignore
# Plaintext secrets (never commit)
secrets.yml
*.dec.yml
*.decrypted.yml
```

## Secrets Chain Documentation

Each repo's `.docs/` folder should document:

1. Which secrets use Doppler vs SOPS
2. The age public key (safe to document)
3. How to bootstrap a new developer (key setup)
