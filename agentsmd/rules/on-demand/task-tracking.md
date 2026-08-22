---
name: task-tracking
description: Where work that is not a pull request gets recorded — side quests, follow-ups, and maintenance windows. Read before deferring work or before disruptive work on a live service.
---

# Task tracking

Vikunja is the task tracker. Every side quest, follow-up, and deferred item
goes there. **Never open a GitHub issue** — GitHub carries pull requests only.

Refer to Vikunja by project name and project number. Never put its URL or host
in committed text.

## Side quests and follow-ups

Found something worth doing that is not this task? Record it in Vikunja with
enough context for someone else to pick it up, then continue. Do not widen the
current change to cover it, and do not silently drop it.

Keep the entry free of anything that belongs elsewhere: an incident narrative,
a security finding, a credential detail, or internal topology goes to the
incident tracker or the private docs site, not into a task description. "It is
only a side quest" is not an exemption.

## Maintenance windows

A maintenance window is shared, agent-visible "hands off this target" state.
Without one, a second session cannot tell that a host is mid-rebuild.

One project, `Maintenance Windows` (project 54). One task equals one window.

| Field | Value |
| --- | --- |
| Title | the affected host or service, as an FQDN — never an IP |
| `dueDate` | when the window ends |
| Label | `maintenance` |
| Description | why the window is open, and who or what opened it |
| Comments | the audit trail |

The contract:

- **Check before you start.** Before non-trivial work on a live guest or
  service — a converge, a reboot, a destroy-and-rebuild, any disruptive infra
  change — look for an active window on that target. One open by someone else
  means hands off: coordinate, do not barge in.
- **An active window is `done == false` AND `due_date` in the future.** Judging
  by `done` alone answers "yes" almost always, because many tasks carry a
  placeholder date and never expire.
- **Open a window before you start** that class of work, and close it or
  comment when you finish.
- **Reversible, local, read-only work needs no window.**
- **Cross-link an incident by URL**: paste the incident ticket URL into the
  window's description and the window URL back into the ticket. A plain URL
  each way is enough to navigate both directions; no integration is needed.

Credentials, API routes, and the account that may write are environment
specifics. They live in the operator's local configuration, not here.
