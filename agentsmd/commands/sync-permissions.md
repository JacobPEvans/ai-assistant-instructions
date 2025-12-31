---
description: Scan local AI settings and merge safe permissions into repo
model: haiku
allowed-tools: Task, TaskOutput, TodoWrite, Bash(cat:*), Bash(find:*), Bash(rm:*), Glob(**), Grep(**), Read(**), Write(**)
---

# Sync Permissions

Scan for local AI assistant settings files and merge universally-safe permissions into the repository's permission files for all supported tools.

## Supported AI Tools

This command manages permissions for multiple AI assistants:

| Tool | Settings Location | Permission Format |
| ---- | ----------------- | ----------------- |
| Claude | `.claude/settings.local.json` | `permissions.allow[]` |
| Gemini | `.gemini/settings.json` | `permissions.allow[]` |
| Copilot | `.github/copilot-settings.json` | TBD |

All permission files must stay in sync - fix any mismatches immediately.

## Steps

### 1. Discover Local Permission Files

1.1. Scan for all AI settings files:

```bash
find ~ -name "settings.local.json" -path "*/.claude/*" 2>/dev/null
find ~ -name "settings.json" -path "*/.gemini/*" 2>/dev/null
```

1.2. Read each file and extract the permissions arrays.

### 2. Analyze Permissions

For each permission found, evaluate its safety:

#### Safe to Add (Allow List)

Permissions are safe for the allow list if they are:

- **Read-only operations**: `list`, `ls`, `show`, `info`, `view`, `get`, `describe`, `inspect`
- **Version/help commands**: `--version`, `--help`, `-v`, `-h`
- **Status commands**: `status`, `doctor`, `ping`, `check`
- **Create operations**: `create`, `add`, `new`, `init` (unless overwriting critical system resources)
- **Safe fetch domains**: Documentation sites, official vendor sites

#### Require Confirmation (Ask List)

Permissions should go to the ask list if they:

- **Modify existing resources**: `update`, `set`, `edit`, `patch`
- **Delete resources**: `rm`, `delete`, `remove`, `prune`
- **Execute arbitrary code**: `exec`, `run`, `eval`
- **Manage credentials**: Operations on keys, tokens, secrets

#### Never Allow (Deny List)

Permissions should be denied if they:

- Can cause irreversible damage
- Bypass security controls
- Access sensitive data directly

### 3. Merge Permissions

3.1. Read the repository's permission files for each tool:

**Claude:**

- `agentsmd/permissions/allow.json`
- `agentsmd/permissions/ask.json`
- `agentsmd/permissions/deny.json`

**Gemini:**

- `.gemini/permissions/allow.json`
- `.gemini/permissions/deny.json`

3.2. For each new safe permission:

- Check if already present (avoid duplicates)
- Add to appropriate section based on category
- Maintain alphabetical ordering within sections

**WebFetch Domain Deduplication:**

When adding WebFetch domains, always check for existing broader domain patterns:

- If `github.com` exists, skip `api.github.com`, `docs.github.com`, etc.
- If `docker.com` exists, skip `docs.docker.com`, `hub.docker.com`, etc.
- For well-known safe vendors (GitHub, Google, Docker, Apple, Microsoft), prefer adding the root domain rather than subdomains
- `github.io` is separate from `github.com` - GitHub Pages require their own entry

**Preferred Root Domains for Safe Vendors:**

| Subdomain Found | Add Instead |
| --- | --- |
| `docs.docker.com` | `docker.com` (if not present) |
| `api.github.com` | `github.com` (if not present) |
| `developers.google.com` | `google.com` |
| `support.apple.com` | `apple.com` |
| `docs.microsoft.com` | `microsoft.com` |
| `*.github.io` | `github.io` |

Skip adding subdomains if the root domain is already in the allow list.

3.3. Look for related permissions to add:

- If `docker volume ls` is safe, `docker volume inspect` likely is too
- If `aws s3 ls` is safe, other `aws <service> list-*` commands likely are too
- Identify patterns and suggest additions

### 4. Ensure Cross-Tool Sync

4.1. Compare permission lists across all AI tools.

4.2. If a permission exists in one tool but not another:

- Add it to the other tools in their native format
- Translate permission syntax as needed

4.3. Fix any mismatches immediately - all tools should have equivalent permissions.

### 5. Write Updated Permissions

5.1. Write changes to all permission files.

5.2. Run linters/formatters on the JSON files.

### 6. Clean Up Local Files

After all permissions are merged:

6.1. **Show contents before deletion**: For each local settings file, display its full contents
to the user before deleting. This allows the user to verify what was processed.

```bash
echo "=== Contents of <path>/settings.local.json ==="
cat <path>/settings.local.json
```

6.2. Delete the local settings files that were processed:

```bash
rm <path>/settings.local.json
```

6.3. Report which files were cleaned up.

## Safety Guidelines

### Commands That Are Always Safe

- Version checks (`--version`)
- Help output (`--help`, `-h`)
- List operations that don't reveal secrets
- Status/health checks
- Reading public documentation
- Creating new resources (containers, volumes, branches)

### Commands That Need Analysis

- Commands that could reveal sensitive info
- Commands that interact with cloud resources in destructive ways

### Commands to Never Auto-Add

- Commands that modify critical system state
- Commands that could leak credentials
- Commands that bypass security controls

## Output

Report summary:

- Number of permission files scanned
- Permissions added to each list (per AI tool)
- Permissions skipped (with reasons)
- Files cleaned up
