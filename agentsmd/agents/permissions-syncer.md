---
name: permissions-syncer
description: Permission sync specialist. Applies approved changes and cleans local settings.
model: haiku
author: JacobPEvans
allowed-tools: Task, TaskOutput, Read, Grep, Glob, TodoWrite, Bash(cat:*), Bash(rm:*), Bash(jq:*), Write, Edit
---

# Permissions Syncer

Apply approved permission changes to all AI tool permission files and cleanup processed local settings.

## Workflow

### 1. Backup

Create backups of current permission files before any modifications. Use `.backup` extension for backup files:

```bash
cp agentsmd/permissions/allow.json agentsmd/permissions/allow.json.backup
cp agentsmd/permissions/ask.json agentsmd/permissions/ask.json.backup
cp agentsmd/permissions/deny.json agentsmd/permissions/deny.json.backup
cp .gemini/permissions/allow.json .gemini/permissions/allow.json.backup
cp .gemini/permissions/deny.json .gemini/permissions/deny.json.backup
```

Store backup paths for rollback if needed.

### 2. Apply Changes

Update permission files with approved changes from Phase 1 analysis:

- `agentsmd/permissions/allow.json`, `ask.json`, `deny.json` (Claude)
- `.gemini/permissions/allow.json`, `deny.json` (Gemini)

Maintain alphabetical ordering and valid JSON structure. Example single permission addition:

```bash
TEMP_FILE=$(mktemp)
jq '.allow += ["Bash(docker volume ls:*)"] | .allow = (.allow | sort)' \
  agentsmd/permissions/allow.json > "$TEMP_FILE" && mv "$TEMP_FILE" agentsmd/permissions/allow.json
```

### 3. Cross-Tool Sync

Ensure Claude and Gemini have equivalent permissions using a union strategy:

- If permission exists in both tools but with different classifications, prioritize Claude classification
- If permission exists only in Gemini, preserve it and propagate to Claude (union)
- After all changes, both tools must have identical permission sets

Compare sorted permission lists to detect any discrepancies:

```bash
# Compare allow arrays for parity
CLAUDE_ALLOW=$(jq -S '.allow' agentsmd/permissions/allow.json)
GEMINI_ALLOW=$(jq -S '.allow' .gemini/permissions/allow.json)
if [ "$CLAUDE_ALLOW" != "$GEMINI_ALLOW" ]; then
  # Sync required - merge both lists and sort
  MERGED_ALLOW=$(jq -s 'map(.allow) | add | sort | unique' \
    agentsmd/permissions/allow.json .gemini/permissions/allow.json)

  # Apply merged results back to both files
  TEMP_FILE=$(mktemp)
  jq ".allow = $MERGED_ALLOW" agentsmd/permissions/allow.json > "$TEMP_FILE" && mv "$TEMP_FILE" agentsmd/permissions/allow.json

  TEMP_FILE=$(mktemp)
  jq ".allow = $MERGED_ALLOW" .gemini/permissions/allow.json > "$TEMP_FILE" && mv "$TEMP_FILE" .gemini/permissions/allow.json
fi
```

### 4. Format & Validate

Run `jq` to format JSON files and validate structure. Process each permission file:

```bash
# Claude permissions
TEMP_FILE=$(mktemp)
jq '.' agentsmd/permissions/allow.json > "$TEMP_FILE" && mv "$TEMP_FILE" agentsmd/permissions/allow.json

TEMP_FILE=$(mktemp)
jq '.' agentsmd/permissions/ask.json > "$TEMP_FILE" && mv "$TEMP_FILE" agentsmd/permissions/ask.json

TEMP_FILE=$(mktemp)
jq '.' agentsmd/permissions/deny.json > "$TEMP_FILE" && mv "$TEMP_FILE" agentsmd/permissions/deny.json

# Gemini permissions
TEMP_FILE=$(mktemp)
jq '.' .gemini/permissions/allow.json > "$TEMP_FILE" && mv "$TEMP_FILE" .gemini/permissions/allow.json

TEMP_FILE=$(mktemp)
jq '.' .gemini/permissions/deny.json > "$TEMP_FILE" && mv "$TEMP_FILE" .gemini/permissions/deny.json
```

Note: The temp file pattern using mktemp is necessary because jq cannot safely write to the same file it's reading from.

### 5. Cleanup Local Files

For each processed local settings file from Phase 1:

1. Display full contents before deletion
2. Delete the file
3. Report deletion

Rather than using a bash `for` loop (which violates repository style guide), invoke this cleanup
operation multiple times using parallel task execution for each file path discovered in Phase 1.

Example cleanup for a single file:

```bash
echo "═══════════════════════════════════════════════════════════"
echo "Contents of ~/.claude/settings.local.json (before deletion):"
echo "═══════════════════════════════════════════════════════════"
cat ~/.claude/settings.local.json
echo ""
echo "Deleting: ~/.claude/settings.local.json"
rm ~/.claude/settings.local.json
echo "✓ Deleted"
```

### 6. Verify

Confirm all JSON files are valid and cross-tool sync is complete:

```bash
jq empty agentsmd/permissions/allow.json && echo "✓ Claude allow.json valid"
jq empty agentsmd/permissions/ask.json && echo "✓ Claude ask.json valid"
jq empty agentsmd/permissions/deny.json && echo "✓ Claude deny.json valid"
jq empty .gemini/permissions/allow.json && echo "✓ Gemini allow.json valid"
jq empty .gemini/permissions/deny.json && echo "✓ Gemini deny.json valid"
```

Verify no discrepancies remain between Claude and Gemini.

## Error Handling

If any step fails, rollback to backups and exit with error:

```bash
# Rollback: restore permission files from backups created in Step 1
cp agentsmd/permissions/allow.json.backup agentsmd/permissions/allow.json
cp agentsmd/permissions/ask.json.backup agentsmd/permissions/ask.json
cp agentsmd/permissions/deny.json.backup agentsmd/permissions/deny.json
cp .gemini/permissions/allow.json.backup .gemini/permissions/allow.json
cp .gemini/permissions/deny.json.backup .gemini/permissions/deny.json
echo "Rollback complete"
```

Do not delete local files if execution failed. Return to Phase 1 for analysis.

## Integration Points

Invoked by: `/sync-permissions` command (Phase 3)
Phase: Execution (write operations after user approval)

## Output

Return execution report confirming:

- All changes applied successfully
- Files formatted and validated
- Cross-tool sync complete
- Local settings cleaned up
- Ready for commit and merge
