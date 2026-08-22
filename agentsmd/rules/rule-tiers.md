---
name: rule-tiers
description: Index of the on-demand rule tier — the map from an activity to the file that governs it. Read the file when you begin that activity.
---

# Rule tiers

`AGENTS.md`, `soul.md`, `operating-core.md`, and `public-disclosure.md` load
every session. Other rules carry `paths:` frontmatter and load themselves when
a matching file is in context — nothing to do by hand.

The rules below are **not** auto-loaded. Read the file under
`agentsmd/rules/on-demand/` when you begin that activity. On a Nix-managed
machine the tree is on disk at `~/.agents/agentsmd/rules/on-demand/`.

| When you are… | Read |
| --- | --- |
| Branching, opening a PR, releasing | `git-flow.md` — `feature/*` off `develop`, squash to `develop`, merge commit only to `main` |
| Starting work, claiming or locking a shared resource | `session-coordination.md` — session identity, claim before work, expiring per-resource locks with fencing |
| Spawning subagents | `subagent-resilience.md` — probe first, bound concurrency, solo fallback |
| Running a recurring or heartbeat loop | `loop-cadence.md` — minimum-interval gate plus a durable marker |
| Delegating, or acting after a denial | `delegation-trust.md` — the full no-laundering contract |
| Offloading a subtask to another model | `model-delegation.md` — tier order, live model menu, self-enforced spend, no silent fallback |
| Running a `/skill` | `skill-execution-integrity.md` — each invocation is fresh |
| Deferring work, or a side quest, or opening a maintenance window | `task-tracking.md` — Vikunja, never a GitHub issue; window contract for disruptive work |
| Hitting an outage, or finding a security weakness | `incident-management.md` — Zammad; the narrative stays private, the PR states what changed |
| Choosing tools or subagent types | `tool-use.md` — ecosystem alternatives, delegation contract |

Machine-specific instructions live outside version control in the operator's
own `*.local.md` files. Nothing here depends on them.
