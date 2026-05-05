---
description: Scripts MUST live in dedicated script files; never inlined in YAML, Markdown, Bash one-liners, or heredocs
---

# No Scripts — Detailed Rule

Companion to `AGENTS.md`: rationale, worked examples, allow-list.

## Why

Native CLIs have tests, releases, docs, stable behavior. Inline scripts have
none of that, hide from linters when buried in YAML/Markdown/heredocs, and
rot fast. A "script" is anything with logic — conditionals, loops, branching,
multi-step state — regardless of container.

## Worked examples

### YAML `run:` with logic

Wrong:

```yaml
- run: |
    for pr in $(gh pr list --json number -q '.[].number'); do
      if [[ $(date +%H) -ge 9 && $(date +%H) -le 17 ]]; then
        gh pr merge "$pr" --squash --auto
      fi
    done
```

Right — extract, or use a native action:

```yaml
- run: .github/scripts/merge-if-quiet.sh
- uses: peter-evans/enable-pull-request-automerge@v3
```

### Bash with multi-line control flow

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

### Heredoc smuggling logic

Wrong: `git commit -m "$(cat <<'EOF' ... $(if ...) ... EOF)"`

Right: `git commit -m "feat: standard release"`

### Inline interpreters

Wrong: `python -c "import json; print(json.load(open('x.json'))['key'])"`

Right: `jq -r .key x.json`

## Allowed dedicated-script directories

| Directory | Purpose |
| --- | --- |
| `scripts/` | Project utility scripts |
| `.github/scripts/` | Called from Actions workflows |
| `.claude/hooks/` | Claude Code hook scripts |
| `tests/` | Test fixtures and runners |
| `plugins/<name>/hooks/` | Plugin-supplied hook scripts |

Proper extension (`.sh`, `.py`, `.ts`, `.js`, `.rb`, `.pl`) and shebang required.

## Search log example

```text
Native CLIs: gh pr merge --auto - found, but lacks quiet-window logic
Ecosystem primitives: peter-evans/enable-pull-request-automerge@v3 - found, no time-of-day gate
Third-party packaged tools: cargo-release - not found, doesn't apply
Popular community solutions: release-please-action - found, no quiet-window
```

## When blocked

Stop. Don't switch tools to bypass — re-run the search; usually a native
option was missed. If still stuck, ask the user. Routing around a hook is
bad-faith.
