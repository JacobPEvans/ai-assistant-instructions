---
description: Delegate tasks to external AI models (Gemini, Ollama, GPT) for specialized capabilities
model: sonnet
# SECURITY: Wildcards required for AI tools (dynamic models/prompts), curl for API checks
# Following least privilege: limited to specific AI CLIs + connectivity testing only
allowed-tools: Bash(gemini:*), Bash(ollama:*), Bash(litellm:*), Bash(curl:*), Read, Write, Grep
author: JacobPEvans
---

# Delegate to External AI

Delegate tasks to external AI models for specialized capabilities beyond Claude's strengths.

## When to Delegate

Use external AI models when the task benefits from:

- **Large Context Windows**: Gemini 3 Pro (1M tokens) for analyzing huge codebases or documents
- **Mathematical Reasoning**: GPT-5.2 or DeepSeek for complex math problems
- **Local/Private Processing**: Ollama models for sensitive data that can't go to cloud APIs
- **Multi-Model Consensus**: Getting opinions from multiple AIs on critical decisions
- **Specialized Research**: Gemini's latest web search and reasoning capabilities

See [AGENTS.md](../../AGENTS.md) for current model capabilities and routing rules.

## Quick Reference: Cost-Based Model Selection

Choose your model based on task type, cost sensitivity, and requirements:

| Task Type | Cost-Sensitive? | Privacy Needed? | Recommended Model | Rationale |
|-----------|-----------------|-----------------|-------------------|-----------|
| **Code Review** | No | No | Consensus (Gemini + DeepSeek) | Get multiple perspectives |
| | Yes | No | DeepSeek R1 (local) | Excellent reasoning, free |
| | Yes | Yes | DeepSeek R1 (local) | Free + private |
| **Research/Analysis** | No | No | Gemini 3 Pro | 1M context, latest info |
| | Yes | No | Qwen 3 Next (local) | Fast, free alternative |
| | Yes | Yes | Qwen 3 Next (local) | Free + stays local |
| **Coding/Implementation** | No | No | Claude + Local validation | High quality output |
| | Yes | No | Qwen-Coder (local) | Specialized, cost-free |
| | Yes | Yes | Qwen-Coder (local) | Free + secure |
| **Critical Decision** | Any | No | Multi-Model Consensus | Reduces single-model bias |
| | Any | Yes | DeepSeek R1 + Qwen local | Best reasoning + privacy |
| **Sensitive Data** | Any | **Yes** | Ollama (local only) | Never use cloud APIs |

### Decision Tree

1. **Is the data sensitive or confidential?** → Use Ollama (local models only)
2. **Is cost a concern?** → Use local Ollama models (qwen3-next, qwen3-coder, deepseek-r1)
3. **Do you need the latest information/web search?** → Use Gemini 3 Pro
4. **Do you need giant context window (1M+ tokens)?** → Use Gemini 3 Pro
5. **Is this a critical decision?** → Use multi-model consensus (Gemini + DeepSeek local + Claude)
6. **Need specialized coding?** → Use qwen3-coder:30b locally or Claude
7. **Default/general tasks** → Start with local Ollama, fall back to cloud if needed

## Available External AIs

### 1. Gemini (Google)

**Best for**: Research, large document analysis, multi-step reasoning

**Prerequisites**:

- Gemini CLI installed: `pip install google-generativeai`
- API key stored securely (see Security section below)

**Usage**:

```bash
# Research task example
gemini chat --model gemini-3-pro --prompt "Research current state of WebAssembly component model and compare with Docker containers"

# Large document analysis
gemini analyze --model gemini-3-pro --file /path/to/large-doc.md --prompt "Summarize key architectural decisions"
```

**Fallback**: If Gemini API unavailable, use local Ollama qwen3-next:80b

### 2. Ollama (Local Models)

**Best for**: Private/offline tasks, cost-free processing, sensitive data

**Prerequisites**:

- Ollama installed and running: `brew install ollama` or `nixpkgs.ollama`
- Models pulled: `ollama pull qwen3-next:80b`

**Usage**:

```bash
# Check available models
ollama list

# Run task with local model
ollama run qwen3-next:80b "Explain the security implications of this code: $(cat sensitive-file.py)"

# Coding task with specialized model
ollama run qwen3-coder:30b "Write a Rust function to parse TOML with error handling"

# Reasoning task
ollama run deepseek-r1:70b "Analyze the logical consistency of this argument: ..."
```

**Recommended Models** (as of Dec 2025):

- Research: `qwen3-next:80b-a3b-instruct-q8_0`
- Coding: `qwen3-coder:30b-a3b-q8_0`
- Reasoning: `deepseek-r1:70b-llama-distill-q8_0`

**Fallback**: Always available (local-only, no API required)

### 3. LiteLLM (Multi-Model Proxy)

**Best for**: Unified interface to multiple providers, automatic fallbacks

**Prerequisites**:

- LiteLLM installed: `pip install litellm`
- Configuration at `~/.config/litellm/config.yaml`

**Usage**:

```bash
# Use via proxy (automatically routes based on config)
litellm --model research-model "Compare approaches for managing state in React vs Vue"

# Force specific provider
litellm --model gemini/gemini-3-pro "Task description"
litellm --model anthropic/claude-opus-4-5 "Task description"
```

**Fallback**: Automatically configured in LiteLLM config (Gemini -> GPT -> Ollama)

### 4. Multi-Model Consensus

**Best for**: Critical decisions, code reviews, architectural choices

**Usage**:

```bash
# Create a temporary script to gather multiple opinions
cat > /tmp/multi-model-query.sh <<'EOF'
#!/bin/bash
PROMPT="$1"

echo "=== Gemini 3 Pro ==="
gemini chat --model gemini-3-pro --prompt "$PROMPT"

echo -e "\n=== Claude (via LiteLLM) ==="
litellm --model anthropic/claude-sonnet-4-5 "$PROMPT"

echo -e "\n=== DeepSeek R1 (Local) ==="
ollama run deepseek-r1:70b "$PROMPT"
EOF

# Note: Execute with bash directly (chmod may require permission)
bash /tmp/multi-model-query.sh "Should we use microservices or monolith for this project?"
```

## Security: API Key Management

**CRITICAL**: Never store API keys in files, environment variables, or code.

### Recommended Approach (macOS Keychain)

```bash
# Note: 'security' commands require explicit permission in AI assistant configurations
# These are macOS system commands and may need to be added to allowed-tools

# Store API key in keychain (one-time setup)
security add-generic-password \
  -a "$USER" \
  -s "GEMINI_API_KEY" \
  -w "your-api-key-here" \
  -U

# Retrieve at runtime
export GEMINI_API_KEY=$(security find-generic-password -a "$USER" -s "GEMINI_API_KEY" -w)
gemini chat --model gemini-3-pro --prompt "Task"
```

See [keychain-setup.md](../docs/keychain-setup.md) for full setup instructions.

### Alternative: Bitwarden Secrets

```bash
# Retrieve from Bitwarden Secrets
export GEMINI_API_KEY=$(bws secret get GEMINI_API_KEY --output json | jq -r '.value')
export OPENAI_API_KEY=$(bws secret get OPENAI_API_KEY --output json | jq -r '.value')
```

## Delegation Workflow

### Step 1: Analyze Task Requirements

Determine which external AI is best suited:

```markdown
| Requirement | Recommended AI | Why |
|-------------|----------------|-----|
| Large codebase analysis | Gemini 3 Pro | 1M token context |
| Complex math/proofs | GPT-5.2 or DeepSeek R1 | AIME/IMO performance |
| Private data processing | Ollama (local) | No cloud API calls |
| Critical decision | Multi-model consensus | Reduces single-model bias |
| Cost-sensitive task | Ollama (local) | Free, unlimited |
```

### Step 2: Prepare Input

```bash
# For file-based input
TASK_FILE=/tmp/delegation-input.txt
cat > "$TASK_FILE" <<'EOF'
Analyze this API design for security vulnerabilities:
[paste API spec]
EOF
```

### Step 3: Execute Delegation

```bash
# Retrieve API key securely
export GEMINI_API_KEY=$(security find-generic-password -a "$USER" -s "GEMINI_API_KEY" -w 2>/dev/null)

# Execute with error handling
if [ -n "$GEMINI_API_KEY" ]; then
  gemini chat --model gemini-3-pro --file "$TASK_FILE"
else
  echo "Gemini API unavailable, falling back to local model"
  ollama run qwen3-next:80b "$(cat $TASK_FILE)"
fi
```

### Step 4: Synthesize Results

After getting response from external AI:

1. Read and validate the output
2. Cross-reference with your own analysis
3. Identify any contradictions or gaps
4. Provide final recommendation to user

## Error Handling

### API Rate Limits

```bash
# Check for rate limit errors and retry with exponential backoff
# Note: Sequential 'for' loop required here for exponential backoff timing (not parallelizable)
for i in 1 2 4 8; do
  if gemini chat --model gemini-3-pro --prompt "$TASK" 2>/tmp/gemini-err; then
    break
  elif grep -q "rate limit" /tmp/gemini-err; then
    echo "Rate limited, waiting ${i}s..."
    sleep $i
  else
    echo "Falling back to local model"
    ollama run qwen3-next:80b "$TASK"
    break
  fi
done
```

### Service Unavailable

```bash
# Test connectivity before delegating
if ! curl -s --max-time 5 https://generativelanguage.googleapis.com > /dev/null; then
  echo "Gemini API unreachable, using local Ollama"
  USE_LOCAL=true
fi

if [ "$USE_LOCAL" = true ]; then
  ollama run qwen3-next:80b "$TASK"
else
  gemini chat --model gemini-3-pro --prompt "$TASK"
fi
```

### Invalid API Key

```bash
# Validate API key before use
if [ -z "$GEMINI_API_KEY" ]; then
  echo "ERROR: GEMINI_API_KEY not found in keychain"
  echo "Run: security add-generic-password -a $USER -s GEMINI_API_KEY -w 'your-key'"
  echo "Falling back to local model..."
  ollama run qwen3-next:80b "$TASK"
fi
```

## Local-Only Mode

When `AI_ORCHESTRATION_LOCAL_ONLY=true` or privacy required:

```bash
# Set environment variable
export AI_ORCHESTRATION_LOCAL_ONLY=true

# All delegations automatically use Ollama
if [ "$AI_ORCHESTRATION_LOCAL_ONLY" = true ]; then
  # Map cloud models to local equivalents
  case "$REQUESTED_MODEL" in
    gemini-3-pro|research)
      ollama run qwen3-next:80b "$TASK"
      ;;
    claude-opus-4-5|coding)
      ollama run qwen3-coder:30b "$TASK"
      ;;
    *)
      ollama run qwen3-next:latest "$TASK"
      ;;
  esac
fi
```

## Integration with PAL MCP

If PAL MCP Server is available (see [AGENTS.md](../../AGENTS.md)):

```bash
# Check if PAL MCP is running
if pgrep -f "pal-mcp-server" > /dev/null; then
  # Use PAL MCP tools (more sophisticated routing)
  # This requires PAL MCP Server to be installed and configured
  echo "PAL MCP available - using advanced multi-model routing"
  # PAL will be automatically available via MCP tools
else
  # Fallback to direct CLI invocation (this command)
  echo "PAL MCP not available - using direct CLI delegation"
fi
```

## Examples

### Example 1: Large Codebase Analysis

```bash
# Task: Analyze entire codebase for architectural patterns
REPO_PATH=/path/to/large/repo

# Gemini 3 Pro can handle 1M tokens
find "$REPO_PATH" -name "*.ts" -o -name "*.tsx" | \
  xargs cat | \
  gemini chat --model gemini-3-pro --prompt "Analyze this TypeScript codebase and identify:
  1. Main architectural patterns used
  2. Potential technical debt
  3. Security concerns
  4. Performance bottlenecks"
```

### Example 2: Multi-Model Code Review

```bash
# Task: Get consensus on a critical refactoring
DIFF=$(git diff main...feature-branch)

echo "$DIFF" | tee \
  >(gemini chat --model gemini-3-pro --prompt "Review this diff for issues" > /tmp/gemini-review.txt) \
  >(ollama run deepseek-r1:70b "Review this diff for issues" > /tmp/deepseek-review.txt) \
  >(litellm --model anthropic/claude-sonnet-4-5 "Review this diff for issues" > /tmp/claude-review.txt) \
  > /dev/null

# Wait for all to complete, then synthesize
wait
cat /tmp/gemini-review.txt /tmp/deepseek-review.txt /tmp/claude-review.txt | \
  ollama run qwen3-next:80b "Synthesize these three code reviews into a unified recommendation"
```

### Example 3: Private Data Analysis

```bash
# Task: Analyze sensitive customer data (must stay local)
export AI_ORCHESTRATION_LOCAL_ONLY=true

# Force local processing
ollama run qwen3-next:80b "Analyze this customer data for trends: $(cat sensitive-data.csv)"
```

## Troubleshooting

### Issue: "gemini: command not found"

**Solution**: Install Gemini CLI

```bash
pip install google-generativeai
# or via Nix
nix-env -iA nixpkgs.python3Packages.google-generativeai
```

### Issue: "ollama: connection refused"

**Solution**: Start Ollama service

```bash
# macOS
brew services start ollama

# Or run directly
ollama serve &

# Verify
ollama list
```

### Issue: API key errors

**Solution**: Verify keychain setup

```bash
# Test keychain access
security find-generic-password -a "$USER" -s "GEMINI_API_KEY" -w

# If fails, add key
security add-generic-password -a "$USER" -s "GEMINI_API_KEY" -w "your-api-key"
```

## Best Practices

1. **Always have a fallback**: Cloud API unavailable? Use local Ollama
2. **Secure API keys**: Keychain > Bitwarden > Environment variables > NEVER in files
3. **Cost awareness**: Local models are free; cloud APIs have limits
4. **Privacy first**: Sensitive data must use local-only mode
5. **Validate outputs**: External AIs can hallucinate; always verify critical information
6. **Multi-model consensus**: For important decisions, consult multiple models
7. **Update regularly**: Model capabilities change monthly; review [AGENTS.md](../../AGENTS.md)

## Related Files

- [AGENTS.md](../../AGENTS.md) - Model routing rules and capabilities
- [keychain-setup.md](../docs/keychain-setup.md) - API key security setup
- [.specs/2025-12-14-multi-model-orchestration/PLAN.md](../../.specs/2025-12-14-multi-model-orchestration/PLAN.md) - Full orchestration plan

## Future Enhancements

- Integration with PAL MCP Server for automatic routing
- Python-based task router for intelligent model selection
- Anthropic Skills for research workflows
- Automated testing of external AI availability
