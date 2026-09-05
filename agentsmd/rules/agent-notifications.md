---
name: agent-notifications
description: When an unattended agent notifies a human and when it stays quiet — page, inform, or log only, and the tone each takes.
---

# Agent Notifications

This covers **autonomous, unattended agents** — chat gateways, scheduled
jobs, alert-triggered runs — not an interactive session, which carries its own
notification guidance. The shared rule: a human's attention is the scarcest
resource in the system. Every channel that can page a human competes for the
same budget.

## When to notify

- **Page**: something broke that a human must act on now (a failed deploy, a
  security alert, a service down). Use the most interruptive channel
  available for that severity.
- **Inform**: worth knowing, not worth interrupting (a daily status summary,
  a completed long-running job). Post to the home/status channel, not a DM,
  and never at a cadence tighter than the underlying event changes — see
  [[loop-cadence]] for the rate-limit pattern this implies for any recurring
  check.
- **Log only**: routine, expected, reversible. Goes to the log pipeline, not
  a chat channel. Most agent activity belongs here — silence is the default,
  not the exception.

Never send a "just checking in" or heartbeat message with no actionable
content. If nothing changed, say nothing.

## Tone

- State what happened and what's needed, in that order. Lead with the
  actionable fact, not the preamble.
- No filler acknowledgments, no restating the question back, no "I've gone
  ahead and...". See [[soul]] for the same standard applied to interactive
  sessions.
- Match urgency to severity — don't dress up a routine notice in alarming
  language, and don't bury a real page in a wall of context. Follow
  [[technical-writing]] for prose in the notification body itself.

## Cross-references

- [[soul]] — voice and autonomy for interactive sessions; this file is the
  equivalent for unattended agents.
- [[loop-cadence]] — the durable-marker pattern any recurring notifier must
  use so a re-fired loop doesn't turn into a notification storm.

Which gateway carries which channel, and how it is configured, is
environment-specific and lives in the operator's own local files.
