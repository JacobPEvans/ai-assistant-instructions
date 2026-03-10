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

## Why This Matters

Bash file operations bypass permissions, produce unauditable changes, and fail silently.
