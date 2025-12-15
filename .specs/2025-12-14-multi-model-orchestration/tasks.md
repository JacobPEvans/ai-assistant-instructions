# Multi-Model AI Orchestration - Tasks

**Spec Source**: `~/.claude/plans/crystalline-herding-volcano.md`

---

## PR 1: Infrastructure & Structure

### Setup

- [x] Verify worktree status in `nix-config/` (branch: `feat/ai-orchestration-module`)
- [x] Verify worktree status in `ai-assistant-instructions/` (branch: `feat/multi-model-orchestration`)

### Master Module

- [x] Create `nix-config/modules/ai-orchestration/default.nix` with options:
  - `enable` - Enable multi-model orchestration
  - `localOnlyMode` - Use only Ollama (no cloud APIs)
  - `defaultResearchModel`, `defaultCodingModel`, `defaultFastModel`
  - `localResearchModel`, `localCodingModel`
  - `secretsBackend` - "keychain" (macOS Keychain 'ai-secrets')
  - `ollamaHost` - default `http://localhost:11434`

### agentsmd Directory Structure

- [x] Create `agentsmd/` directory in ai-assistant-instructions repo
- [x] Create `agentsmd/AGENTS.md` with PAL MCP routing rules
- [x] Create `agentsmd/rules/` directory (renamed from concepts/)
- [x] Create `agentsmd/workflows/` directory
- [x] Create `agentsmd/docs/` directory
- [ ] Move `orchestrator-prompt.txt` to `agentsmd/workflows/` (skipped - file doesn't exist yet)

### Symlinks

- [x] Set up symlink: `agentsmd/.claude/` → `~/.claude/`
- [x] Set up symlink: `agentsmd/.gemini/` → `~/.gemini/`
- [x] Set up symlink: `agentsmd/.copilot/` → `~/.copilot/`
- [x] Set up symlink: `agentsmd/AGENTS.md` → `~/AGENTS.md`

### Documentation

- [x] Document 'ai-secrets' keychain manual setup in `agentsmd/docs/keychain-setup.md`
- [x] Include: `security create-keychain -p "" ai-secrets.keychain-db`
- [x] Include: Adding API keys with `security add-generic-password`

### Validation & PR

- [x] Test that Nix module imports correctly
- [x] Verify all symlinks resolve properly
- [x] Create PR 1: "feat(ai-orchestration): Infrastructure & Structure"
  - ai-assistant-instructions: <https://github.com/JacobPEvans/ai-assistant-instructions/pull/104>
  - nix-config: <https://github.com/JacobPEvans/nix/pull/111>

---

## PR 2: PAL MCP Integration

### Research

- [ ] Research PAL MCP Nix/flake support at <https://github.com/BeehiveInnovations/pal-mcp-server>
- [ ] Determine installation method (flake input vs pipx vs npm)
- [ ] Document findings in `agentsmd/docs/pal-mcp-research.md`

### Nix Module

- [ ] Create `nix-config/modules/ai-orchestration/pal-mcp/default.nix`
- [ ] Add PAL MCP as flake input (if supported) or define installation method
- [ ] Configure PAL MCP environment variables

### Secrets Wrapper

- [ ] Create Python wrapper for keychain secret retrieval
- [ ] Wrapper retrieves from 'ai-secrets' keychain at runtime
- [ ] Support keys: ANTHROPIC_API_KEY, OPENAI_API_KEY, GEMINI_API_KEY, etc.
- [ ] Inject secrets into PAL MCP process environment

### MCP Server Configuration

- [ ] Configure MCP server registration for Claude
- [ ] Add to `~/.claude/mcp_servers.json` or equivalent
- [ ] Enable PAL MCP tools:
  - [ ] `chat` - Single model conversation
  - [ ] `clink` - Multi-model parallel queries
  - [ ] `codereview` - Code review with multiple models
  - [ ] `precommit` - Pre-commit AI review
  - [ ] `consensus` - Multi-model consensus
  - [ ] `planner` - Architecture planning

### PR 2 Validation

- [ ] Test PAL MCP server starts correctly
- [ ] Test secret injection from keychain works
- [ ] Test at least one PAL MCP tool (e.g., `chat`)
- [ ] Create PR 2: "feat(ai-orchestration): PAL MCP Integration"

---

## PR 3: Anthropic Suite Import

### PR 3 Nix Module

- [ ] Create `nix-config/modules/ai-orchestration/anthropic/default.nix`
- [ ] Define options for marketplace registration
- [ ] Define options for plugin enablement

### Marketplace Registration

- [ ] Register `anthropics/skills` marketplace
- [ ] Register `anthropics/claude-plugins-official` marketplace
- [ ] Configure skill/plugin discovery paths

### Enable All Plugins

- [ ] Enable document-skills
- [ ] Enable example-skills
- [ ] Enable all official plugins (list from marketplace)
- [ ] Document any conflicts encountered

### Command Comparison (Start)

- [ ] Create `agentsmd/docs/command-comparison.md`
- [ ] Add headers: Anthropic, PAL MCP, Personal, Alternatives
- [ ] List current personal commands
- [ ] Begin mapping personal → Anthropic/PAL MCP equivalents

### PR 3 Validation

- [ ] Verify skills/plugins load in Claude
- [ ] Test at least one imported skill
- [ ] Create PR 3: "feat(ai-orchestration): Anthropic Suite Import"

---

## PR 4: auto-claude + PAL MCP Integration

### Orchestrator Update

- [ ] Update `agentsmd/workflows/orchestrator-prompt.txt` to use PAL MCP tools
- [ ] Add PAL MCP tool invocation patterns
- [ ] Document model selection logic (research → Gemini, coding → Claude, etc.)

### Local Mode Support

- [ ] Add `--local` runtime flag to auto-claude
- [ ] Ensure `OLLAMA_HOST` is passed to PAL MCP in local mode
- [ ] Config-level `localOnlyMode` sets default behavior
- [ ] Runtime `--local` overrides config

### /ai-go Command

- [ ] Create `/ai-go` slash command in `agentsmd/.claude/commands/ai-go.md`
- [ ] Command triggers auto-claude with full orchestration
- [ ] One-click autonomous operation entry point

### CI Integration Tests

- [ ] Create test: PAL MCP server starts
- [ ] Create test: Keychain secret retrieval works (mock)
- [ ] Create test: Local mode uses Ollama
- [ ] Create test: /ai-go command resolves
- [ ] Add tests to CI workflow

### PR 4 Validation

- [ ] Test full autonomous flow with `/ai-go`
- [ ] Test local-only mode with Ollama
- [ ] Verify CI tests pass
- [ ] Create PR 4: "feat(ai-orchestration): auto-claude + PAL MCP Integration"

---

## PR 5: LiteLLM Fallback

### PR 5 Nix Module

- [ ] Create `nix-config/modules/ai-orchestration/litellm/default.nix`
- [ ] Define Docker Compose configuration in Nix
- [ ] Symlink Docker Compose to OrbStack location

### Generic Model Aliases

- [ ] Configure alias: `research-model` → best research model
- [ ] Configure alias: `coding-model` → best coding model
- [ ] Configure alias: `fast-model` → fastest model
- [ ] Configure alias: `local-research` → qwen3-next:80b
- [ ] Configure alias: `local-coding` → qwen3-coder:30b

### Fallback Routing

- [ ] Configure fallback on API errors
- [ ] Primary: PAL MCP direct routing
- [ ] Fallback: LiteLLM proxy
- [ ] Set budget limits ($50/day default)

### PR 5 Validation

- [ ] Test LiteLLM container starts in OrbStack
- [ ] Test model alias resolution
- [ ] Test fallback triggers on simulated error
- [ ] Create PR 5: "feat(ai-orchestration): LiteLLM Fallback"

---

## PR 6: Benchmarking

### PR 6 Nix Module

- [ ] Create `nix-config/modules/ai-orchestration/benchmark/default.nix`
- [ ] Install `llm-benchmark` via pipx
- [ ] Define Open WebUI Docker Compose in Nix

### llm-benchmark Setup

- [ ] Configure llm-benchmark for Ollama models
- [ ] Create helper script: `ai-benchmark` (runs throughput tests)
- [ ] Document benchmark interpretation

### Open WebUI Arena

- [ ] Docker Compose for Open WebUI at `~/.config/ai-orchestration/open-webui/`
- [ ] Create helper script: `ai-arena-start`
- [ ] Create helper script: `ai-arena-stop`
- [ ] Configure arena-style model comparison

### PR 6 Documentation

- [ ] Create `agentsmd/workflows/benchmark-guide.md`
- [ ] Document: When to benchmark (new models, after updates)
- [ ] Document: How to interpret results
- [ ] Document: Recommended model configurations

### PR 6 Validation

- [ ] Test `ai-benchmark` runs successfully
- [ ] Test Open WebUI starts and shows arena
- [ ] Create PR 6: "feat(ai-orchestration): Benchmarking"

---

## PR 7: Command Comparison & Cleanup

### Complete Command Comparison

- [ ] Finish `agentsmd/docs/command-comparison.md`
- [ ] Section: Anthropic Official commands
- [ ] Section: PAL MCP tools
- [ ] Section: Agent OS alternatives
- [ ] Section: Major alternatives (Aider, Cursor, Windsurf)
- [ ] Matrix: Feature comparison across tools

### Evaluate Personal Commands

- [ ] List all current personal commands
- [ ] For each: identify Anthropic/PAL MCP equivalent
- [ ] For each: document migration path
- [ ] Flag commands with no equivalent (keep these)

### Delete Redundant Commands

- [ ] Delete commands replaced by Anthropic suite
- [ ] Delete commands replaced by PAL MCP
- [ ] Update any references to deleted commands
- [ ] Keep only commands with unique functionality

### Close GitHub Issues

- [ ] Close #101: "Add subagents to summon external AIs" (PAL MCP chat/clink)
- [ ] Close #96: "Integrate Local Ollama Models" (PAL MCP + OLLAMA_HOST)
- [ ] Close #69: "Pre-commit AI Code Review" (PAL MCP precommit)
- [ ] Close #40: "Consolidate Duplicate AI Commands" (unified orchestration)
- [ ] Close #27: "Split Claude slash commands" (PAL MCP tools)

### Final Validation

- [ ] Full end-to-end test: `/ai-go` → autonomous operation
- [ ] Test cloud mode with multiple providers
- [ ] Test local-only mode with Ollama
- [ ] Verify all symlinks intact
- [ ] Verify all CI tests pass

### PR & Release

- [ ] Create PR 7: "feat(ai-orchestration): Command Comparison & Cleanup"
- [ ] After merge: Tag release v1.0.0
- [ ] Update CLAUDE.md with final architecture

---

## Summary

| PR | Title | Key Deliverables |
| --- | --- | --- |
| 1 | Infrastructure & Structure | Master module, agentsmd/, symlinks, keychain docs |
| 2 | PAL MCP Integration | PAL MCP module, secrets wrapper, MCP config |
| 3 | Anthropic Suite Import | Anthropic module, marketplaces, plugins |
| 4 | auto-claude + PAL MCP | /ai-go, orchestrator update, CI tests |
| 5 | LiteLLM Fallback | LiteLLM module, generic aliases, fallback routing |
| 6 | Benchmarking | Benchmark module, llm-benchmark, Open WebUI |
| 7 | Command Comparison & Cleanup | Comparison doc, command migration, issue closure |

**Total Tasks**: 94 actionable items across 7 PRs

**Dependencies**:

- PR 2 depends on PR 1 (master module must exist)
- PR 4 depends on PR 2 (PAL MCP must be configured)
- PR 5 depends on PR 2 (needs PAL MCP for fallback chain)
- PR 7 depends on all others (cleanup after everything works)
