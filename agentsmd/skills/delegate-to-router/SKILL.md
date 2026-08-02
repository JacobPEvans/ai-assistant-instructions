---
name: delegate-to-router
description: Offload a bounded subtask to the shared model router — discover the live model menu from the router's published contract, pick the cheapest capable tier, place a bounded call, and report honestly when the router is unreachable
version: 1.0.0
author: dryvist homelab
license: MIT
metadata:
  hermes:
    category: research
    tags: [delegation, routing, models, cost]
    related_skills: [openrouter-models]
---

# delegate-to-router

Doctrine: `prompt://dryvist/auto-ai-agent/model-delegation`. This skill is the
mechanics — how to find out what is served right now, and how to call it.

Use it when a subtask is **bounded**: a summary, classification over a batch,
structured extraction, boilerplate drafting, a first-pass read of unfamiliar
code. Do not use it to hand off the judgment you were asked for.

## 1. Read your endpoint from the environment

The router is an OpenAI-compatible endpoint. Its base URL and your credential
arrive as environment variables — the names are set by whatever provisioned
your session, so read them rather than assuming a value:

```sh
env | grep -iE 'router|litellm|openai_(base|api)' | sed 's/=.*/=<set>/'
```

You never hold a provider credential directly, and the router's own upstream
keys are not visible to you. If no endpoint variable is present, the router is
not wired into this session: say so and do the work yourself. Do not go looking
for a provider key.

## 2. Fetch the live model menu — never hardcode a name

Model inventories change far faster than this skill does, so the menu is
fetched, not remembered:

```sh
# Preferred: the router's published registry contract.
curl -fsS --max-time 10 -H "Authorization: Bearer $ROUTER_KEY" \
  "$ROUTER_BASE/registry.json"

# Fallback: the OpenAI-compatible listing every router serves.
curl -fsS --max-time 10 -H "Authorization: Bearer $ROUTER_KEY" \
  "$ROUTER_BASE/models" | jq -r '.data[].id'
```

Substitute the variable names you actually found in step 1.

Select from what came back. Prefer a **stable role alias** over a concrete
model id where the registry publishes one — the alias is the part promised to
keep working across model swaps. Sort candidates by cost and take the cheapest
that can plausibly do *this subtask*, not the parent task.

If both endpoints fail, you may fall back to a pinned copy of the registry that
was hash-pinned at build time — but say in your output that you used the pinned
copy and that the live menu was unreachable. A pinned copy can be stale; a call
by a name it lists may still fail.

## 3. Place the call, bounded

```sh
curl -fsS --max-time 120 -H "Authorization: Bearer $ROUTER_KEY" \
  -H 'content-type: application/json' \
  -d '{"model":"<id from step 2>","messages":[{"role":"user","content":"..."}]}' \
  "$ROUTER_BASE/chat/completions"
```

Every call gets an explicit timeout. Send only the context the subtask needs —
a delegated call that carries your whole transcript costs more than doing the
work yourself and widens what leaves the estate.

## 4. Handle the negative paths explicitly

| What you see | What it means | What to do |
| --- | --- | --- |
| DNS failure, refused connection, timeout | Router unreachable | Report it; defer the subtask or continue on your own model as a stated choice |
| `401` / `403` | Credential invalid, expired, or not scoped to that model | Report it; do not retry with a different credential |
| `429` or a budget message | Rate limit or a cap the deployment does enforce | Drop to a cheaper tier or defer; see `openrouter-models` |
| `400` naming an unknown model | Your id is not served | Re-fetch the menu (step 2); do not retry the same id |

None of these authorize a silent fallback. Absorbing the work back into your
own context without saying so is the exact cost delegation was meant to avoid,
and it hides the failure from whoever pays for it. Never respond to any of them
by acquiring a direct provider credential.

## 5. Report what you used

Name the model or alias that produced each delegated result, and say when a
result came from the pinned menu rather than the live one.

## What never gets delegated

Secrets and credentials, OpenBao-adjacent context, private infrastructure
topology, personal data. Those go to a locally served tier or stay with you —
and free-tier endpoints in particular log prompt content provider-side. See
`openrouter-models` for the egress rules in full.
