---
description: Use existing tools directly instead of generating scripts — research first, execute via tool calls
paths:
  - "**/*.sh"
  - "**/*.py"
  - "scripts/**"
  - ".github/**"
  - "Makefile"
---

# Direct Execution

AI assistants solve problems by finding and using existing tools, not by generating scripts.
Research what exists before implementing anything — do not trust training data.

## The Workflow

1. **Identify the tool** — What existing CLI, builtin, or module handles this?
2. **Verify capabilities** — Use Context7 MCP, PAL MCP, or web search to confirm
3. **Execute directly** — Run via Bash tool (or equivalent tool call)
4. **Parallelize** — Independent commands as parallel tool calls in a single response

If no existing tool handles the task, ask the user before writing any code.
Check AI assistant settings files (`~/.claude/settings.json`, `~/.gemini/settings.json`) for pre-approved commands.

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
| Config generation | Nix functions (`lib.mkIf`, `lib.generators.*`) | Shell/Python generator |
| Nix data processing | `builtins.fromJSON`, `builtins.readFile`, `lib.strings.*` | Python wrapper |
| CI/CD automation | Marketplace actions, reusable workflows, composite actions | Custom shell script |
| GitHub Actions logic | Expressions, `fromJSON()`, matrix strategies | Python/bash in step |
| Infrastructure config | Ansible modules, Terraform resources/data sources | Configuration script |
| Infrastructure validation | `terraform validate`, `ansible-lint`, check modes | Validation script |
| State queries | `terraform output`, `terraform state show`, Ansible facts | Query script |
| Permission/JSON transforms | `Read` + `jq` (via Bash) + `Edit`/`Write` | Python file manipulation |
| Multi-file git operations | Parallel Bash tool calls (`git add f1 f2 f3`) | Loop script |
| Delegate to external AI | `/delegate-to-ai` via PAL MCP | Manual model routing |

## Exceptions

Scripts are appropriate ONLY when the deliverable IS a script:

- User explicitly asked to create a script file
- The script will be committed as a permanent artifact (CI/CD workflows, pre-commit hooks, `Makefile`s)

Never for one-off tasks or temp files.

## When Scripts ARE Needed

If you genuinely need a script (user asked, or it's a committed artifact):

1. Place it in an allowed directory (`scripts/`, `hooks/`, `.github/`, or `tests/`)
2. Use proper file extension (.sh, .py)
3. For Nix: use `writeShellApplication` with `runtimeInputs`, reference via `${./<relative-path>}`
4. For inline Nix wrappers: one-liner `exec` patterns in `writeShellScriptBin` are acceptable
5. NEVER create temp/throwaway scripts — if it's not committed, it's not needed

## Subagent Type Selection

| `subagent_type` | Available Tools | Use When |
| --- | --- | --- |
| `general-purpose` | All tools (Read, Edit, Write, Bash, Glob, Grep, ...) | Any task involving file reads, edits, or writes |
| `Explore` | Exploration tools (Read, Glob, Grep, Bash, ...) | Exploration and research only; no file modifications |
| `Bash` | Bash only | Pure shell operations with no file modifications |

**Critical rule**: If a subagent needs to read, write, or edit files, NEVER use `subagent_type: "Bash"`.
Bash-only agents work around missing tools with `python -c`/`sed`/`awk`, bypassing permissions and audit trails.
Use `general-purpose` instead.
