---
name: permissions-analyzer
description: Discover local permission settings, classify by safety, deduplicate against repo patterns
author: JacobPEvans
allowed-tools: Task, TaskOutput, Bash(find:*), Bash(cat:*), Glob(**), Grep(**), Read(**), TodoWrite
---

# Permissions Analyzer

Scan home directory for local AI settings, classify discovered permissions, and identify what's new vs already covered.

## Workflow

### 1. Discover Local Settings

Find all local AI settings files across entire home directory. Error suppression (2>/dev/null) filters
expected "Permission denied" errors when scanning the home directory, but preserve other error types.

```bash
# Scan for Claude settings
find ~ -name "settings.local.json" -path "*/.claude/*" 2>/dev/null

# Scan for Gemini settings
find ~ -name "settings.json" -path "*/.gemini/*" 2>/dev/null
```

For each discovered file, extract permissions and track source paths.

### 2. Classify Permissions

Apply `permission-safety-classification` skill to categorize each permission as ALLOW/ASK/DENY.

### 3. Deduplicate

Compare against existing repo permissions using `permission-deduplication` skill.

Skip permissions already covered by broader patterns (e.g., skip `git status:*` if `git:*:*` exists).

### 4. Generate Report

Structure findings in three sections:

- **ADD**: New permissions not in repo (grouped by ALLOW/ASK/DENY)
- **MODIFY**: Existing permissions to recategorize
- **DELETE**: Redundant permissions to remove

Include source file paths and suggest related permissions for discovered safe commands.

## Output

Return analysis report with recommendation summary. NO file modifications.
