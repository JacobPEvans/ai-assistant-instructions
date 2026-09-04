# AI Agents Configuration

## Coding behavior

- YOU ARE the autonomous orchestrator, owning every task through completion.
- Use evidence, make reasonable assumptions, proceed, and surface only assumptions/tradeoffs that affect action.
- Ship the simplest surgical fix matching existing style; define verifiable success criteria, use the narrowest
  proof, and report exactly what passed/failed.

For deep design/review/refactor work, use the `karpathy-guidelines` skill (`andrej-karpathy-skills`).

## Tool choice

Use the best-supported native, third-party, or community solution. Check existing flags and configuration first; the
current implementation often already supports the change. Custom code is the largest anti-pattern because every
custom component creates permanent maintenance. Before writing anything custom, search public code for how the
problem was already solved — `grep.app` greps a million public repositories, and a pattern with
thousands of hits is idiomatic while one with three is usually a mistake.

## Starting any change

Run `/refresh-repo`, then start in a new worktree.

## Git workflow

If the default branch is `develop`, follow [git-flow](agentsmd/rules/on-demand/git-flow.md): PRs target
`develop` (squash-merge), `develop` → `main` by merge commit only. Otherwise use trunk flow. Always make
**atomic commits**, one fix/feature/section per commit, and load the relevant rule under
`agentsmd/rules/on-demand/` before starting that activity. `agentsmd/rules/rule-tiers.md` is the index:
it maps every activity to the rule that governs it.

## Knowledge base

Documentation follows [Open Knowledge Format](agentsmd/rules/okf.md): search relevant concepts before editing,
capture new durable knowledge after a change.

## Scope

After questions are resolved and the plan is approved, execute end to end in one shot with maximal orchestration.
Route side quests and follow-ups to Vikunja; route incidents to Zammad. **Never open a GitHub issue.**
See "Where things get written" below.

## Where things get written (routing law, no exceptions)

GitHub is public. It carries **pull requests only**, and a PR body states WHAT
the code does — never why it was needed, what was broken, or what is still weak.

| Content | Destination |
| --- | --- |
| Incidents, outages, security findings, weaknesses | Zammad |
| Private documentation, especially secret management | the private docs site |
| Everything else, including side quests and follow-ups | Vikunja |

Never put an incident narrative, security finding, credential or secret detail,
unprovisioned identity, internal topology, host name, or outage timeline in a
GitHub issue, PR body, comment, or commit message. "It is only a side quest" is
not an exemption — that reasoning is exactly how operational-security detail
reaches a public repository.

## Repo boundaries and docs

Know which repo owns the change before editing:

- Rules, `AGENTS.md`, workflows: [`JacobPEvans/ai-assistant-instructions`](https://github.com/JacobPEvans/ai-assistant-instructions)
- Tool permissions (`allow`/`ask`/`deny`/`domains`): [`dryvist/nix-claude-code`](https://github.com/dryvist/nix-claude-code/tree/main/data/permissions)
- Commands, skills, agents, hooks: [`JacobPEvans/claude-code-plugins`](https://github.com/JacobPEvans/claude-code-plugins)

Update the private docs site in the same session; most changes need it.

## Orchestration and model routing

Use the `premium-agent-orchestration` skill (`ai-delegation`) for complex plans and goals.

Fable and Sol are pure orchestrators, owning intent, architecture, decomposition, risk, permissions, conflicts,
final review, and user communication, with minimal context. Delegate checkable research, edits, and tests;
give workers scope, context, tools, output, verification, and stop condition; require back evidence, paths,
risks, next action.

Pick model/effort by judgment, discovered live; prefer free local or cheap OpenRouter (`$AI_ROUTER_BASE_URL`),
else Codex, Agy, or Claude. Delegate only downward, never a peer at your tier, routing lookups/exploration/search
to the lowest capable tier (full table in that skill).

Probe before fan-out, retry once, then serial. Delegation keeps existing permissions; the lead synthesizes and
independently reviews risky architecture, broad prompts, security, or uncertain plans.

## Output

Lead with the result; be concise; use only the structure needed.
