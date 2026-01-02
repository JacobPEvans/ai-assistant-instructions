---
name: permissions-syncer
description: Apply approved permission changes, sync across tools, cleanup local settings
author: JacobPEvans
allowed-tools: Task, TaskOutput, Bash(cat:*), Bash(rm:*), Bash(jq:*), Glob(**), Read(**), Write(**), Edit(**), TodoWrite
---

# Permissions Syncer

Apply approved permission changes to all AI tool permission files and cleanup processed local settings.

## Workflow

### 1. Backup

Create backups of current permission files before any modifications.

### 2. Apply Changes

Update permission files with approved changes:

- `agentsmd/permissions/allow.json`, `ask.json`, `deny.json` (Claude)
- `.gemini/permissions/allow.json`, `deny.json` (Gemini)

Maintain alphabetical ordering and valid JSON structure.

### 3. Cross-Tool Sync

Ensure Claude and Gemini have equivalent permissions. If mismatch found, sync them.

### 4. Format & Validate

Run `jq` to format JSON files and validate structure.

### 5. Cleanup Local Files

For each processed local settings file:

1. Display full contents
2. Delete the file
3. Report deletion

### 6. Verify

Confirm all JSON files are valid and cross-tool sync is complete.

## Error Handling

If any step fails, rollback to backups and exit with error. Do not delete local files if execution failed.

## Output

Return execution report confirming all changes applied, files synced, and local settings cleaned up.
