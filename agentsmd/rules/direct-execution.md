# Direct Execution

AI assistants execute tasks by running commands directly, not by generating scripts.

## Core Principle

**Use direct tool invocations, not script files.** When you need to accomplish a task:

1. Run commands individually via the Bash tool (or equivalent)
2. Run independent commands as parallel tool calls in a single response
3. Chain dependent commands with `&&` in a single Bash tool call

## Do This, Not That

| Do This | Not This |
| --- | --- |
| Multiple individual Bash tool calls | Writing a `.sh` or `.py` file then executing it |
| `git add file1 file2 file3` (one call) | A loop script that iterates over files |
| Parallel tool invocations for independent tasks | A wrapper script that orchestrates steps |
| Sequential tool calls for dependent operations | A Python script that chains subprocess calls |

## Why Scripts Are Wrong Here

- **Permission bypass**: Written scripts sidestep the tool permission model
- **Debugging opacity**: Script failures are harder to trace than individual command failures
- **Wasted tokens**: Generating script source code consumes context without adding value
- **Temp file pollution**: Scripts written to `/tmp` or project dirs create cleanup burden

## Exceptions

Scripts are appropriate ONLY when the deliverable IS a script:

- User explicitly asks to create a script
- The task is writing automation code that will be committed to the repository
- CI/CD workflow files (GitHub Actions YAML, `Makefile`s, etc.)

## Subagent Type Selection

When delegating to a Task subagent, choose the type based on what tools the subagent needs:

| `subagent_type` | Available Tools | Use When |
| --- | --- | --- |
| `general-purpose` | All tools (Read, Edit, Write, Bash, Glob, Grep, …) | Any task involving file reads, edits, or writes |
| `Explore` | Exploration tools (Read, Glob, Grep, Bash, …) | Exploration and research only; no file modifications |
| `Bash` | Bash only | Pure shell operations with no file modifications |

**Critical rule**: If a subagent needs to read, write, or edit files, NEVER use `subagent_type: "Bash"`.

Bash-only agents that must edit files fall back to `python -c`, `sed`, and `awk` — violating this
rule, bypassing the permission model, and producing harder-to-debug results. Use `general-purpose`
instead, which has the Read/Edit/Write tools available.

## Disambiguation

Bash snippets in agent definitions and documentation are reference patterns for the AI
to execute via tool calls. They are NOT templates to be written as script files.
