---
description: Use native tools (Read/Edit/Write/Grep/Glob) over Bash equivalents — research existing solutions before generating scripts
---

# Tool Use

AI assistants solve problems by finding and using existing tools, not by generating scripts.
Research what exists before implementing anything — do not trust training data.

## The Workflow

1. **Identify the tool** — What existing CLI, builtin, or module handles this?
2. **Verify capabilities** — Use Context7 MCP, PAL MCP, or web search to confirm
3. **Execute directly** — Run via Bash tool (or equivalent tool call)
4. **Parallelize** — Independent commands as parallel tool calls in a single response

If no existing tool is found, run the **No Scripts** research workflow in
`AGENTS.md` before considering any code.
Check AI assistant settings files (`~/.claude/settings.json`,
`~/.gemini/settings.json`) for pre-approved commands.

## Ecosystem Alternatives

| Task | Use This | Not This |
| --- | --- | --- |
| File reading | `Read` tool | `cat`, `head`, `tail` via Bash |
| File editing | `Edit` tool | `sed -i`, `awk`, `python -c` via Bash |
| File creation | `Write` tool | `cat >`, heredocs, `echo >` via Bash |
| File search | `Grep` tool | `grep`, `rg`, `ag` via Bash |
| File discovery | `Glob` tool | `find`, `ls`, `fd` via Bash |
| JSON manipulation | `jq` via Bash tool | Python script |
| API calls | `curl` or `gh api` via Bash tool | Python/curl script |
| Text processing (pipe filter) | `grep`/`sed`/`awk` on stdin (never in-place) | Processing script |
| Permission/JSON transforms | `Read` + `jq` (via Bash) + `Edit`/`Write` | Python file manipulation |
| Multi-file git operations | Parallel Bash tool calls (`git add f1 f2 f3`) | Loop script |
| Delegate to external AI | Bifrost `http://localhost:30080/v1/chat/completions` or `/delegate-to-ai` for `clink`/`consensus` | Manual model routing |
| Infrastructure config | Ansible modules, Terraform resources/data sources | Configuration script |
| Infrastructure validation | `terraform validate`, `ansible-lint`, check modes | Validation script |
| State queries | `terraform output`, `terraform state show`, Ansible facts | Query script |

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

Script policy (Required verbatim in every subagent prompt):

- Scripts are LAST RESORT. Search first; script only when every tier comes
  up empty AND approval is granted (see 10-line gate below).
- Scripts MUST live in dedicated script files (`.sh`, `.py`, `.ts`, `.js`,
  `.rb`, `.pl`) under `scripts/`, `.github/scripts/`, `.claude/hooks/`,
  `tests/`, or `plugins/<name>/hooks/` dirs. NEVER comingled in non-script files.
- Inline scripts are forbidden in ALL non-script files: no logic in YAML
  `run:` blocks, no heredoc payloads carrying logic, no multi-line control
  flow inside a single Bash command, no `python -c` / `node -e` / `bash -c`.
- Before writing ANY new dedicated script file, exhaust the four-tier
  search and log it in your reply (one line per tier; empty rows rejected).
- Under 10 non-comment lines AND search empty: auto-approved.
- 10+ non-comment lines: ASK the user and wait for an unambiguous yes.
- Hook blocks are TERMINAL DENIALS, not fallback menus.

## Subagent Type Selection

| `subagent_type` | Available Tools | Use When |
| --- | --- | --- |
| `general-purpose` | All tools (Read, Edit, Write, Bash, Glob, Grep, ...) | Any task involving file reads, edits, or writes |
| `Explore` | Exploration tools (Read, Glob, Grep, Bash, ...) | Exploration and research only; no file modifications |
| `Bash` | Bash only | Pure shell operations with no file modifications |

**Critical rule**: If a subagent needs to read, write, or edit files, NEVER use `subagent_type: "Bash"`.
Bash-only agents work around missing tools with `python -c`/`sed`/`awk`, bypassing permissions and audit trails.
Use `general-purpose` instead.

## Why This Matters

Bash file operations bypass permissions, produce unauditable changes, and fail silently.
