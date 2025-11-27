# Project Planning

## Repository Purpose

Standardized, vendor-agnostic AI assistant instructions for consistent AI-assisted development.

## Architecture

```text
.ai-instructions/          # Single source of truth
├── INDEX.md               # AI navigation (START HERE)
├── INSTRUCTIONS.md        # Main entry point
├── _shared/               # Reusable components (DRY)
├── concepts/              # Core patterns
├── commands/              # Slash commands
├── subagents/             # Agent specifications
└── workflows/             # 5-step process

Vendor configs (.claude/, .github/, .copilot/, .gemini/)
→ Link to .ai-instructions/ (DRY compliant)
```

## Recent Changes

### Autonomous Operation System (Current)

- User presence modes (attended/semi-attended/unattended)
- Watchdog mechanism with commit-before-guessing
- Self-healing with 5 Whys analysis
- Hard protections (never skip validation)
- 11 specialized subagents including Issue Creator/Resolver

### Repository Optimization

- Created `_shared/` for DRY compliance
- Added `INDEX.md` for AI navigation
- Reduced `pull-request-review-feedback.md` from 496 to 99 lines
- Added `/load-context` command for session startup

## Capabilities

### Implemented

- [x] Autonomous orchestration
- [x] Self-healing error recovery
- [x] Parallel issue resolution (up to 5 worktrees)
- [x] PR conversation resolution via GraphQL
- [x] Hard protections enforcement
- [x] User presence mode switching
- [x] Watchdog timeout handling
- [x] Cross-session context bridging (progress checkpoints, session initializer)
- [x] Custom subagent model routing (complexity-based tier selection)
- [x] Context compaction for long-running agents
- [x] QA validation subagent for post-implementation checks
- [x] New slash commands: `/checkpoint`, `/handoff`, `/compact`

### Future

- [ ] SessionStart hooks (auto-invoke Session Initializer) - See TASK-003
- [ ] MCP server integrations
- [ ] Automated link checking
- [ ] Cross-repository coordination
- [ ] Cost tracking dashboard

## Known Issues

- Some vendor configs may need sync with latest `.ai-instructions/`

## Key Files

| File | Purpose |
|------|---------|
| `.ai-instructions/INDEX.md` | AI navigation |
| `.ai-instructions/INSTRUCTIONS.md` | Main instructions |
| `CLAUDE.md` | Claude quick start |
| `CHANGELOG.md` | Version history |
