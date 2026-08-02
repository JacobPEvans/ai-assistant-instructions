---
name: openrouter-models
description: Choose among the hosted models the shared router serves — discover current ids and prices from the public catalog, self-enforce a spend budget the router does not meter for you, respect the free-tier prompt-logging caveat, and request onboarding of a model the router does not serve yet
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

## The model set is enforced; the budget is yours to enforce

Two different kinds of limit. Treating them the same is how money gets spent.

**Enforced at the router:** the set of models your credential may reach. That
is an allowlist you cannot edit, so a `400` for an unlisted model means the
policy worked — it costs nothing and is a correct answer.

**NOT enforced, in the general case: your spend.** Metering spend per caller
needs shared state plus a credential per caller, and a deliberately stateless
router may have neither. Where that is so, no ceiling exists anywhere except in
your own behaviour.

### The budget: $1.00 per day, self-enforced

That is the standing default, and it is real only because you apply it. If your
deployment states a different figure, use theirs; if it states none, use this
one. Do not proceed without a number — "stop at the cap" means nothing if no
cap is named, and an unnamed cap is how an account-wide credential ends up
metered by nothing at all.

- **Track your spend yourself.** Keep a running total in memory keyed by day
  (`openrouter-spend-<YYYY-MM-DD>`). After each paid call, estimate its cost
  from the response's token usage times the per-token prices you discovered,
  and add it. Check the total **before** every paid call.
- **Stop at $1.00.** At or above it, use the locally served tier or a `:free`
  variant instead, and note the deferral. Nothing else will stop you.
- **Never read "nothing stopped me" as permission.** An unenforced limit is
  still a limit; it is just one only you can apply.
- **Prefer free variants** whenever they are adequate, subject to the egress
  rule below. Never run a long unattended loop on a paid model — an unattended
  loop is exactly where self-enforcement fails silently.
- **Report what you have used** when you report spend-relevant work, so a human
  can see the total you are enforcing against.

If your deployment DOES enforce spend, it will tell you so, and a `429` or a
spend-cap message is then also a correct answer to defer on. Trust what your
deployment states over this skill, which describes the general case.

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
