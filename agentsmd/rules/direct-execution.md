# Direct Execution

AI assistants solve problems by finding and using existing tools, not by generating scripts.

## The Workflow

Every task follows this sequence:

1. **Identify the tool** — What existing CLI, builtin, or module handles this? (`jq`, `gh`, `nix eval`, `terraform output`, etc.)
2. **Verify capabilities** — Use Context7 MCP, PAL MCP, or web search to confirm the tool can do what you need
3. **Execute directly** — Run the command via the Bash tool (or equivalent tool call)
4. **Parallelize** — Run independent commands as parallel tool calls in a single response

If no existing tool handles the task, ask the user before writing any code.

## Ecosystem Alternatives

When you reach for a script, use these instead:

| Task | Use This | Not This |
| --- | --- | --- |
| JSON manipulation | `jq` via Bash tool | Python script |
| API calls | `curl` or `gh api` via Bash tool | Python/curl script |
| Text processing (stdout) | `grep`, `sed`, `awk` piped (never `-i` / in-place) | Processing script |
| File reading | `Read` tool | `cat`, `head`, `tail` via Bash |
| File editing | `Edit` tool | `sed -i`, `awk`, `python -c` via Bash |
| File creation | `Write` tool | `cat >`, heredocs, `echo >` via Bash |
| File search | `Grep` tool | `grep`, `rg` via Bash |
| Config generation | Nix functions (`lib.mkIf`, `lib.generators.*`) | Shell/Python generator |
| Nix data processing | `builtins.fromJSON`, `builtins.readFile`, `lib.strings.*` | Python wrapper |
| CI/CD automation | Marketplace actions, reusable workflows, composite actions | Custom shell script in workflow |
| GitHub Actions logic | Expressions, `fromJSON()`, matrix strategies | Python/bash in workflow step |
| Infrastructure config | Ansible modules, Terraform resources/data sources | Configuration script |
| Infrastructure validation | `terraform validate`, `ansible-lint`, check modes | Validation script |
| State queries | `terraform output`, `terraform state show`, Ansible facts | Query script |
| Permission/JSON file edits | `jq` commands via Bash tool | Python file manipulation |
| Multi-file git operations | Parallel Bash tool calls (`git add f1 f2 f3`) | Loop script |
| Delegate to external AI | `/delegate-to-ai` via PAL MCP | Manual model routing |

## Why This Matters

- **Permission model**: Direct tool calls go through the permission system; scripts bypass it
- **Debugging**: Individual command failures are traceable; script failures are opaque
- **Token efficiency**: Generating script source wastes context
- **Temp file pollution**: Scripts in `/tmp/` create cleanup burden

## Exceptions

Scripts are appropriate ONLY when the deliverable IS a script:

- User explicitly asked to create a script file
- The script will be committed as a permanent repository artifact
- Examples: CI/CD workflows, pre-commit hooks, `Makefile`s, committed `scripts/` CI artifacts

Scripts are never appropriate for one-off tasks, temp files, or anything in `/tmp/`.

## Subagent Type Selection

When delegating to a Task subagent, choose the type based on what tools the subagent needs.
This table covers the Task tool's built-in tool-restriction profiles; named subagent types
(e.g., `code-reviewer`, `ci-fixer`) are separate and always include their declared tool sets.

| `subagent_type` | Available Tools | Use When |
| --- | --- | --- |
| `general-purpose` | All tools (Read, Edit, Write, Bash, Glob, Grep, …) | Any task involving file reads, edits, or writes |
| `Explore` | Exploration tools (Read, Glob, Grep, Bash, …) | Exploration and research only; no file modifications |
| `Bash` | Bash only | Pure shell operations with no file modifications |

**Critical rule**: If a subagent needs to read, write, or edit files, NEVER use `subagent_type: "Bash"`.

When Bash-only agents need to edit files, they often work around the limitation by using tools like
`python -c`, `sed`, or `awk` to modify files directly. This bypasses the Read/Edit/Write tools and
the permission model, and makes changes harder to audit and debug. For any task that needs file reads,
writes, or edits, use `general-purpose` instead so the subagent can rely on Read/Edit/Write tools.

## Disambiguation

Bash snippets in agent definitions and documentation are reference patterns for the AI
to execute via tool calls. They are NOT templates to be written as script files.
