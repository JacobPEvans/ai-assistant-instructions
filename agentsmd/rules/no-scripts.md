---
description: Scripts MUST live in dedicated script files; never comingled in YAML, Markdown, Bash one-liners, or heredocs
---

# No Scripts — Detailed Rule

The short rule lives in `AGENTS.md` ("No Scripts — Iron Law"). This file
holds the full rationale, expanded examples, and the dedicated-directory
allow-list.

## Why this rule exists

Native CLIs and ecosystem primitives are better-maintained than anything
Claude (or you) would write fresh. They have tests, releases, maintainers,
documentation that users can read and link to, and behavior that doesn't
drift between sessions.

Scripts written inline have none of that. They are invisible to linters,
test runners, and code review when comingled in non-script files (YAML
workflows, Markdown docs, Bash one-liners, heredocs). They rot the moment
they're committed and cargo-cult themselves into the next session's pattern.

When a native solution exists, use it. When one doesn't, the four-tier
search documents *why* the script must exist. The 10-line gate keeps the
script small enough to read in one sitting. The dedicated-directory
allow-list keeps the script visible to tooling.

## What counts as a "script"

A script is anything with logic — conditionals, loops, branching,
multi-step state. The container doesn't matter. A 30-line `for` loop
embedded in a YAML `run:` block is a script. A 50-line `bash` heredoc
piped into `git commit -m` is a script. Both must move to a dedicated
file or — better — be replaced with native tools.

### Banned (with worked examples)

#### YAML `run:` blocks with logic

Wrong:

```yaml
- name: Merge if quiet window
  run: |
    for pr in $(gh pr list --json number -q '.[].number'); do
      if [[ $(date +%H) -ge 9 && $(date +%H) -le 17 ]]; then
        gh pr merge "$pr" --squash --auto
      fi
    done
```

Right (extract):

```yaml
- name: Merge if quiet window
  run: .github/scripts/merge-if-quiet.sh
```

Or better (native composition):

```yaml
- uses: peter-evans/enable-pull-request-automerge@v3
  with:
    pull-request-number: ${{ github.event.pull_request.number }}
    merge-method: squash
```

#### Bash with multi-line control flow

Wrong:

```text
while IFS= read -r branch; do
  gh api repos/x/y/git/refs/heads/$branch -X DELETE
done < /tmp/branches.txt
```

Right (native):

```text
gh api repos/x/y/branches --paginate --jq '.[].name' \
  | xargs -I{} gh api --method DELETE repos/x/y/git/refs/heads/{}
```

#### Heredoc smuggling logic

Wrong:

```text
git commit -m "$(cat <<'EOF'
$(if [[ $(date +%u) == 5 ]]; then echo "Friday deploy"; else echo "Standard"; fi)

$(git log --oneline | head -5)
EOF
)"
```

Right (compose first, commit second; or just write a one-line message):

```text
git commit -m "feat: standard release"
```

#### Inline interpreters

Wrong: `python -c "import json; print(json.load(open('x.json'))['key'])"`

Right: `jq -r .key x.json`

### Allowed (not a script; rule does not trigger)

- **Single-line pipelines.** Compose with `|`, `&&`, `||`, `xargs` — even
  long pipelines are fine if they're a single line and lean on native CLIs.
- **One-line heredocs feeding pre-existing prose.** A PR body that is
  pre-written prose, fed via heredoc to `gh pr create --body`, is fine.
  The heredoc is a string-passing mechanism, not a script.
- **Short YAML `run:` blocks** without control flow: `run: pnpm install`,
  `run: terraform validate`, `run: pnpm install && pnpm build`.
- **Single Bash commands with `&&`/`||`** chaining, no control-flow
  keywords, no newlines.

## Allowed dedicated-script directories

When a script is genuinely required (search empty, four-tier log clean,
under 10 lines or user-approved), it must live in one of:

| Directory | Purpose |
| --- | --- |
| `scripts/` | Project-level utility scripts |
| `.github/scripts/` | Scripts called from GitHub Actions workflows |
| `.claude/hooks/` | Claude Code hook scripts |
| `tests/` | Test fixtures and runners |
| `plugins/<name>/hooks/` | Plugin-supplied hook scripts |

The script must have a proper extension (`.sh`, `.py`, `.ts`, `.js`,
`.rb`, `.pl`) and a shebang on the first line. No extensionless script
files; no scripts in arbitrary repo paths.

## The four-tier search (mandatory)

Before any new dedicated script file, search and log each tier:

1. **Native CLIs / builtins** — `jq`, `gh`, `git`, `curl`, system utilities
2. **Ecosystem primitives** — Ansible modules, Terraform resources, Nix
   functions, marketplace Actions, pre-commit hooks
3. **Third-party packaged tools** — Homebrew, apt, pip, npm, cargo
4. **Popular community solutions** — well-starred GitHub projects, official
   plugins, awesome-* lists

Format: one line per tier. `<Tier Name>: <tool searched> - <found / not found>, <reason>`.
Empty rows or "n/a" are rejected.

Worked example:

```text
Native CLIs: gh pr merge --auto - found, but lacks quiet-window logic
Ecosystem primitives: peter-evans/enable-pull-request-automerge@v3 - found, but no time-of-day gate
Third-party packaged tools: cargo-release - not found, doesn't apply
Popular community solutions: github.com/.../release-please-action - found, but no quiet-window
```

## The 10-line gate

Only applies after the four-tier search comes up empty.

- Under 10 non-comment lines: auto-approved.
- 10+ non-comment lines: ASK the user and wait for an unambiguous yes.

Counting: shebang counts; every code line, heredoc/multi-line-string
line, and continuation line counts; blank and pure-comment lines don't;
no semicolon-stuffing.

## What to do when blocked

If a hook or permission rule blocks a script-related action:

1. **Stop.** Do not retry. Do not route around the block via a different
   tool (e.g., do not switch from `Write` to `Bash` to bypass).
2. **Reconsider.** Re-run the four-tier search; the right answer is usually
   a native tool you missed the first pass.
3. **Ask the user.** Explain what you wanted to do, what was blocked, and
   what native alternative you considered. The user decides.

Routing around a hook is bad-faith behavior. The hook is the rule — when
it fires, the rule is telling you to think harder, not to work around it.
