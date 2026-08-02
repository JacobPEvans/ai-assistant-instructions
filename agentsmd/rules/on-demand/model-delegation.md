---
name: model-delegation
description: Offload bounded subtasks to the shared model router at the cheapest capable tier — model names fetched from the router's published contract, budgets enforced at the router, honest reporting instead of silent fallback
---

# Model delegation

Canonical doctrine: `prompt://dryvist/auto-ai-agent/model-delegation` in the
central prompt catalog. That fragment is the public, vendor-neutral statement
and the shared autonomous base carries a distilled copy, so non-Claude agents
inherit it automatically. This rule is the Claude-session view of the same
doctrine plus the local plumbing.

## Delegate before you spend your own capacity

A bounded subtask does not need the model reasoning about the whole task.
Summaries, classification over a batch, structured extraction, boilerplate
drafting, a first-pass read of unfamiliar code — send those to the router.

Walk the tiers and stop at the first genuinely capable one:

1. **Locally served models** — no marginal cost, no egress. Default for bulk,
   repetitive, or privacy-sensitive work.
2. **Low-cost hosted models** through the router, free-tier endpoints included
   where the material allows it.
3. **Subscription-covered capacity exposed as a tool** — another harness made
   callable, where the work is already paid for.
4. **Premium hosted models** — only after a weaker tier was actually tried and
   demonstrably fell short.

"Capable" judges the subtask, not the parent task. Do not escalate a whole job
because one step inside it is hard; split the job.

## Never hardcode a model name

Model inventories change far faster than this rule does. Names, aliases, and
enabled state live in the router's published contract — fetch them at call time
and select from what is actually served. A name you remembered or copied out of
a document is not evidence the router serves it, and a call by an unserved name
fails. Prefer a stable role alias over a concrete model id where one exists:
the alias is the part promised to keep working.

This applies to committed text too. A model id written into a rule, skill, doc
table, or config is a second spelling that will drift from the registry — the
exact duplication this doctrine exists to remove.

## Budgets are enforced where you cannot bypass them

Spend caps, rate limits, and the reachable model set are enforced by the router
against your own credential. A budget or allowlist rejection is a **correct
answer**: drop to a cheaper tier or defer, and say which. Never route around a
cap, and never request a broader credential to get past one — that is the
denial-laundering pattern `delegation-trust.md` forbids, applied to spend.

Free-tier endpoints frequently log prompt content provider-side. Public or
synthetic material only — never secrets, credentials, private infrastructure
detail, or anyone's personal data. Anything that must not leave the estate goes
to a locally served tier or is not delegated at all.

## Router unreachable: report, never fall back silently

Bound every delegated call with an explicit timeout. On DNS failure, refused
connection, `401`, exhausted budget, or a disabled model: report what failed,
then either defer the subtask or continue on your own model as a **stated,
deliberate choice**. Silently absorbing the work back into your own context is
the exact cost the delegation was meant to avoid, and it hides the failure from
whoever pays for it.

Never respond to a router failure by reaching for a direct provider credential.
No agent holds one, and acquiring one to work around an outage replaces a
central budget with an unmetered one.

## Report what you used

Name the model or tier that produced each delegated result. A reader weighing
your output needs to know which parts came from a cheap tier; an operator
tuning spend needs the same information.

## Skills

- `delegate-to-router` — how to discover the live model menu and place a call.
- `openrouter-models` — the router-enforced budget, the free-tier logging
  caveat, and the lane for requesting a model the router does not serve.

Both live in `agentsmd/skills/`, which is the only authored copy. That location
**supersedes any per-consumer copy**: a harness adopting one deletes its local
version in the same change rather than running both. Two copies of a skill
about spend and egress will drift on precisely the rules that carry the risk,
and whichever consumer holds the stale one cannot tell.
