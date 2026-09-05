---
name: incident-management
description: Where incidents, outages, security findings, and weaknesses get recorded, and what must never reach a public artifact. Read when something breaks or when you find a weakness.
---

# Incident management

Zammad is the incident tracker. Outages, security findings, and weaknesses go
there — never into a GitHub issue, pull request body, comment, or commit
message, and never into the task tracker.

The reason is disclosure, not bookkeeping. A public repository is
search-indexed and archived forever. An incident narrative names what broke,
when, and what depended on it, which maps the attack surface even when no
credential appears in the text.

## What counts

Open a ticket for any of these, however small:

- An outage or degradation of a live service.
- A security finding: an exposed credential, an over-broad grant, a missing
  control, an unprovisioned identity.
- A weakness you noticed but did not fix — a fragile path, a silent failure
  mode, a guard that can be bypassed.
- A near miss, including one you caused and recovered from.
- A credential printed into any transcript, log, or session record, on any
  harness — a ticket is opened even when it was revoked immediately, because
  the transcript keeps the value after the credential stops working.

A weakness you *did* fix still gets a ticket if the fix is partial or if the
same shape exists elsewhere.

## What the ticket carries

The full narrative belongs here, because here is private: the timeline, the
hosts involved, what depended on what, the credential or identity at issue,
what you tried, and what is still weak. Say plainly what is unresolved.

If the incident involved a maintenance window, cross-link the two by URL —
ticket URL in the window description, window URL in the ticket.

## What the public artifact carries instead

The fix ships as a pull request whose body states **what the code now does**.
It does not state why the change was needed, what was broken, what the blast
radius was, or what remains weak. A reviewer who needs that context reads the
ticket.

The same applies to the commit message and to any code comment on the fix.

## Reporting a fix

A fix is not done at the merge. Report it in the ticket with what you ran and
what it returned, then close the ticket — not before.
