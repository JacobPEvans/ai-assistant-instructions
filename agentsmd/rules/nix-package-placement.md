---
description: Package placement decision matrix for the nix repos — where tools belong and when to use nix run instead
paths:
  - "**/*.nix"
  - "flake.nix"
  - "flake.lock"
---

# Nix Package Placement

Prefer the most ephemeral install that still meets the tool's real requirements.
Promote a tool from ephemeral to project-scoped (devenv shell) only when running
it on-demand is too slow; promote from project-scoped to always-on (`home.packages`
or `environment.systemPackages`) only when it must be on `$PATH` everywhere,
outside any project context.

The table below is ordered the same way — always-on at the top, ephemeral at the
bottom. Work upward from the bottom of the table; stop at the first row that
satisfies your tool's needs.

## Placement Decision Matrix

| Package category | Correct home | Mechanism |
| --- | --- | --- |
| Core bootstrapping (git, gnupg, vim) | **nix-darwin** | `environment.systemPackages` |
| macOS-only system tools (mas, mactop) | **nix-darwin** | `environment.systemPackages` |
| macOS system-level C libs (sox, portaudio) | **nix-darwin** | `environment.systemPackages` |
| GUI apps unavailable in nixpkgs | **nix-darwin** | `homebrew.casks` |
| CLI tools unavailable in nixpkgs or version-pinned | **nix-darwin** | `homebrew.brews` |
| AI tools, MCP servers, speech/audio stack | **nix-ai** | `home.packages` |
| User dev tools, shell config, linters, credentials | **nix-home** | `home.packages` |
| Pre-commit hook tools (must be on PATH globally) | **nix-home** | `home.packages` |
| Project-specific toolchains | **nix-devenv** | importable module |
| Language-specific testers, CI linters (bats, actionlint) | **nix-devenv** | shell `buildInputs` |
| Occasional one-off tools (diagramming, previews) | ephemeral | `nix run nixpkgs#<pkg>` |
| npm-backed CLI tools | ephemeral | `bunx <pkg>@version` |
| Python CLI tools | ephemeral | `uvx <pkg>` |

## Critical Rules

**homebrew.brews stays in nix-darwin.** Home-manager (`nix-ai`, `nix-home`) cannot declare
Homebrew formulas — `homebrew.*` is a nix-darwin option only. Group AI-adjacent brew tools
with a `# AI tools` comment block for logical clarity, not a repo move.

**Pre-commit hooks with `language: system`** require the tool on PATH. If a tool is used
as a `language: system` pre-commit hook, it must stay in `nix-home` home.packages even if
it feels project-specific (e.g., `lychee`).

**IDE linters stay global.** Tools like `pyright` that IDEs invoke as background processes
must be in `home.packages` (always on PATH). Moving them to a project devenv shell breaks
editor integration because IDEs activate the system environment, not a project shell.

## On-Demand Patterns

```bash
# Zero-install ephemeral runs (like bunx but for Nix):
nix run nixpkgs#d2 -- input.d2 output.svg
nix run nixpkgs#mermaid-cli -- -i input.mmd -o output.svg
nix run nixpkgs#python3Packages.grip -- README.md

# Enter a project shell with tools available:
nix develop github:JacobPEvans/nix-devenv?dir=shells/ansible
nix develop github:JacobPEvans/nix-devenv?dir=shells/kubernetes

# Use uvx for Python CLIs (preferred over pipx in Nix):
uvx aider-chat
uvx ruff check .
```

## Repo Responsibilities

| Repo | Scope |
| --- | --- |
| **nix-darwin** | macOS system config: system packages, Homebrew, security, GUI apps, LaunchDaemons |
| **nix-ai** | AI tool ecosystem: Claude Code, Gemini, MCP servers, whisper stack, AI CLIs |
| **nix-home** | User dev environment: dev tools, shell config, git, linters, credentials |
| **nix-devenv** | Reusable project shells and importable modules: per-language toolchains |

Full package lists live in each repo's source files — this rule contains placement logic only.
Adding a repo to this set? Update this table, the decision matrix categories above,
and `AGENTS.md` in each consumer repo that references the rule.
