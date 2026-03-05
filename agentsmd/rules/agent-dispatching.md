# Agent Dispatching

Every file-editing subagent prompt MUST include this block:

```text
File operations:
- Read files with the Read tool
- Edit existing files with the Edit tool
- Create new files with the Write tool
- Never use Bash to modify repo files (no sed, awk, python -c, cat >, etc.)
```

Explore and Plan agents are exempt (read-only, no Edit/Write tools).
