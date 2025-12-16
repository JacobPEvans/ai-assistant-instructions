# Claude Instructions

All instructions for this project have been centralized.

Please refer to the instructions in [`AGENTS.md`](./AGENTS.md).

## Worktree-Based Development

**All changes must be made on a dedicated worktree/branch.** This repo uses worktrees for session isolation:

```text
~/git/ai-assistant-instructions/
├── main/                    # Main branch (read-only for development)
├── feat/add-feature/        # Feature worktree
└── fix/bug-name/            # Fix worktree
```

Run `/init-worktree` before starting any new work. Never commit directly to `main/`.
