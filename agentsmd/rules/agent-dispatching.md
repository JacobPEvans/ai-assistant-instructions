---
description: Require file operation tool blocks in every subagent prompt — Read/Edit/Write/Grep/Glob over Bash equivalents
---

# Agent Dispatching

## File Operations Block (Required in Every Subagent Prompt)

Every file-editing subagent prompt MUST include this block verbatim:

```text
File operations:
- Read files with the Read tool (NEVER cat, head, tail, less, bat)
- Edit existing files with the Edit tool (NEVER sed, awk, perl -i, python -c)
- Create new files with the Write tool (NEVER cat >, echo >, tee, heredocs)
- Search file contents with the Grep tool (NEVER grep, rg, ag via Bash)
- Find files with the Glob tool (NEVER find, ls, fd via Bash)
- Bash is ONLY for running system commands (git, terraform, ansible, etc.)
```

Explore agents are exempt (read-only, no Edit/Write tools).

Script policy (Required in every subagent prompt):

- NEVER generate custom scripts — use native tools (jq, curl, gh api, Nix functions, etc.)
- If blocked by a hook, follow the alternatives in the block message
- Committed scripts go in allowed locations (scripts/, hooks/, .github/, tests/) — never temp files

## Why This Matters

Bash file operations bypass permissions, produce unauditable changes, and fail silently.
