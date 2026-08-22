---
name: workspace-conventions
description: How a multi-repository workspace is laid out and worked in — transport by visibility, path variables, per-repo dev shells, and a worktree per change. Read when cloning, setting up a repo, or starting a change.
---

# Workspace conventions

## Transport by visibility, not by owner

Pick the git transport from the repository's **visibility**:

| Visibility | Transport | Why |
| --- | --- | --- |
| public | SSH | the operator's key authenticates; no token needed |
| private | HTTPS | every push resolves a short-lived token through the credential helper |

An always-on SSH key would let any process push to any private repository.
HTTPS keeps the least-privilege gate meaningful for writes.

## Path variables, never a literal path

Refer to workspace roots by variable, never by an absolute path baked into a
script, a document, or a command. A literal path breaks on every other machine
and leaks the operator's directory layout into committed text.

## One dev shell per repository

Each repository carries a Nix flake with a default dev shell plus a committed
direnv file that loads it. Tooling comes from that shell.

Never install a tool with an ad-hoc package manager to get past a missing
binary — add it to the flake, or run it from a throwaway shell. Reaching for a
language package manager is how a machine acquires tools nothing declares.

## A worktree per change

Each repository is a normal clone sitting on its default branch. **Create a
worktree for every change; never edit the default branch directly.**

- Place it at the repository top level under a dedicated worktrees directory.
- Pass an **absolute** path to the worktree command. A relative path resolves
  against the current directory and nests the worktree inside another one.

**Cleanup sweeps must never delete the default-branch worktree.** It has no
open pull request and no ahead/behind signal, so a naive "clean, zero commits
ahead, pull request closed" rule selects it — but builds and converges run from
it.

Before deleting any worktree, confirm no live process has its working directory
inside it. A running session in a directory you are about to remove is a
corrupted session, not a cleanup.

## Before cloning

Check the repository's visibility first, because it decides the transport and
the destination. Then search the workspace for an existing clone of the same
name. A misplaced clone is still a valid clone, so the duplicate goes unnoticed
and the two copies drift.

**A misplaced clone is a move, not a delete** — unless you have proven it holds
nothing unique. Check all four: uncommitted changes, commits ahead of the
remote, local branches absent from the remote, and — the one most often
skipped — whether any process is currently sitting inside it.
