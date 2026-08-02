---
name: openrouter-models
description: Choose among the hosted models the shared router serves — discover current ids and prices from the public catalog, understand the router-enforced spend budget, respect the free-tier prompt-logging caveat, and request onboarding of a model the router does not serve yet
version: 1.0.0
author: dryvist homelab
license: MIT
metadata:
  hermes:
    category: research
    tags: [openrouter, models, pricing, budget, egress]
    related_skills: [delegate-to-router]
---

# openrouter-models

Your locally served brain handles routine work. For reasoning or coding where a
stronger hosted model would genuinely change the outcome, escalate through the
shared router — a deliberate per-call choice, never an automatic on-error
fallback. This skill covers what is available, what it costs, and the rules
around it. `delegate-to-router` covers the mechanics of the call itself.

## The budget is enforced at the router, not by you

Spend caps, rate limits, and the set of models your credential may reach are
enforced by the router against your own key. You do not implement the budget
and you cannot bypass it — a noncompliant or compromised caller hits the same
ceiling.

What this skill asks of you:

- **Treat a rejection as a correct answer.** A `429`, a spend-cap message, or a
  `400` for a non-allowlisted model means the policy worked. Drop to a cheaper
  tier or defer the work, and say which you did.
- **Never route around a cap** and never request a broader credential to get
  past one.
- **Prefer free variants** whenever they are adequate, subject to the egress
  rule below. Never run a long unattended loop on a paid model.
- **Surface remaining budget** when you report spend-relevant work, if the
  router exposes it on your key. Read it from the router; do not reconstruct it
  from your own tallies, which drift.

## Free tiers log your prompts

Many free hosted endpoints log prompt and session content provider-side, and
some train on it. Send them **public or synthetic material only**.

Never through a free tier: secrets and credentials, anything read from or
adjacent to the secret store, private infrastructure topology or hostnames,
incident detail, personal or customer data. That material either goes to a
locally served tier or is not delegated at all. When in doubt, treat it as
confidential — the cost of using a paid tier is bounded, the cost of a leak is
not.

## Discover current models and prices

The hosted catalog is public and keyless, so pricing research costs nothing:

```sh
curl -fsS --max-time 15 https://openrouter.ai/api/v1/models | jq '
  .data[] | {id, context_length,
             prompt_usd_per_mtok: ((.pricing.prompt | tonumber) * 1000000),
             completion_usd_per_mtok: ((.pricing.completion | tonumber) * 1000000)}'
```

Useful selections:

- Cheapest strong coders: filter ids matching the task domain, sort by
  `completion_usd_per_mtok`, read the top few.
- Free variants: `.data[] | select(.id | endswith(":free")) | .id`.
- For "what is currently leading", pair the catalog with a short web check of
  the provider's public rankings — the catalog is ground truth for price and
  context length; rankings are opinion.

Refresh this when you actually need it (prices move), not on a schedule.

## The public catalog is not the served menu

**A model existing upstream does not mean the router serves it.** The catalog
above tells you what exists and what it costs; the router's own contract tells
you what you may actually call. Get the served list from
`delegate-to-router` step 2 and select only from that. Never write a model id
into a rule, skill, doc, or config — that is a second spelling that drifts from
the registry, and this skill deliberately names none.

## Requesting a model the router does not serve

Onboarding is an infrastructure change — a registry entry plus a credential —
so it is not self-serve. When discovery shows a model clearly worth having,
open **one** request through your session's normal work-routing destination
(never a public issue tracker), containing: the exact upstream model id, the
current prompt and completion price per million tokens, the context length, the
concrete task class that justifies it, and the expected spend inside your
budget. Check for an existing open request first — never duplicate. Real
upstream ids only; never propose a generic alias.

## Report what you used

State the model or tier that actually produced each result — the locally served
brain when you did not escalate, and every escalation model when you did.
