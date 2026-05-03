---
description: Scripts MUST live in dedicated script files; never comingled in YAML, Markdown, Bash one-liners, or heredocs
---

# No Scripts — Detailed Rule

Companion to the iron law in `AGENTS.md`: rationale, worked examples, allow-list.

## Why this rule exists

Native CLIs are better-maintained than anything you'd write fresh — tests,
releases, docs, stable behavior. Inline scripts have none of that, are
invisible to linters and review when buried in YAML / Markdown / heredocs,
and rot on contact. Use native tools first. Document why if you can't.

## What counts as a "script"

Anything with logic — conditionals, loops, branching, multi-step state. The
container doesn't matter: a 30-line `for` loop in a YAML `run:` block is a
script; so is a 50-line `bash` heredoc fed to `git commit -m`. Move them
to a dedicated file or replace with native tools.

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

Or native composition:

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

Right:

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

Right: `git commit -m "feat: standard release"`

#### Inline interpreters

Wrong: `python -c "import json; print(json.load(open('x.json'))['key'])"`

Right: `jq -r .key x.json`

### Allowed (not a script)

- Single-line pipelines, however long. `|`, `&&`, `||`, `xargs` chains are fine.
- One-line heredocs feeding **pre-existing prose** to a CLI (e.g.,
  `gh pr create --body "$(cat <<'EOF' ... EOF)"` with a static body).
- YAML `run:` of 1–3 lines without control flow (`run: pnpm install`).
- Single Bash commands without control-flow keywords or newlines
  (`a && b && c` is fine).

## Allowed dedicated-script directories

| Directory | Purpose |
| --- | --- |
| `scripts/` | Project-level utility scripts |
| `.github/scripts/` | Scripts called from GitHub Actions workflows |
| `.claude/hooks/` | Claude Code hook scripts |
| `tests/` | Test fixtures and runners |
| `plugins/<name>/hooks/` | Plugin-supplied hook scripts |

Proper extension (`.sh`, `.py`, `.ts`, `.js`, `.rb`, `.pl`) and a shebang
are required. No extensionless scripts; no scripts in arbitrary paths.

## Four-tier search

Tiers and the 10-line gate live in `AGENTS.md`. Worked example log:

```text
Native CLIs: gh pr merge --auto - found, but lacks quiet-window logic
Ecosystem primitives: peter-evans/enable-pull-request-automerge@v3 - found, but no time-of-day gate
Third-party packaged tools: cargo-release - not found, doesn't apply
Popular community solutions: github.com/.../release-please-action - found, but no quiet-window
```

## When blocked

Hook block? Stop. Don't retry, don't switch tools to bypass. Re-run the
search — there's usually a native option you missed. If still stuck, ask
the user with what you tried and what got blocked. Routing around a hook
is bad-faith behavior.
