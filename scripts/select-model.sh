#!/usr/bin/env bash
# select-model.sh - Automatic model selection based on task requirements
#
# This script implements the decision tree from agentsmd/commands/delegate-to-ai.md
# to select the best AI model for a given task considering cost, privacy, and capability needs.
#
# Usage: select-model.sh [options]
#   --task-type=<research|coding|review|decision|default>
#   --cost-sensitive (flag - prefer free local models)
#   --private (flag - sensitive data, must use local Ollama)
#   --large-context (flag - need 1M+ context window)
#
# Output:
#   Model: <model-name>
#   Command: <invocation-command>
#   Rationale: <explanation>

set -euo pipefail

# Default values
TASK_TYPE="default"
COST_SENSITIVE=false
PRIVATE=false
LARGE_CONTEXT=false

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --task-type=*)
      TASK_TYPE="${1#*=}"
      shift
      ;;
    --cost-sensitive)
      COST_SENSITIVE=true
      shift
      ;;
    --private)
      PRIVATE=true
      shift
      ;;
    --large-context)
      LARGE_CONTEXT=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Decision tree implementation based on delegate-to-ai.md routing logic
select_model() {
  local task_type="$1"
  local cost_sensitive="$2"
  local private="$3"
  local large_context="$4"

  # Step 1: Is the data sensitive or confidential?
  if [[ "$private" == "true" ]]; then
    echo "Model: ollama"
    echo "Selected: deepseek-r1:70b (local reasoning) or qwen3-next:80b (local general)"
    echo "Command: ollama run deepseek-r1:70b"
    echo "Rationale: Private/sensitive data must stay local. Never use cloud APIs."
    return 0
  fi

  # Step 2: Is cost a concern?
  if [[ "$cost_sensitive" == "true" ]]; then
    case "$task_type" in
      coding)
        echo "Model: qwen3-coder:30b"
        echo "Command: ollama run qwen3-coder:30b"
        echo "Rationale: Cost-sensitive coding task - using free local specialized model"
        return 0
        ;;
      review)
        echo "Model: deepseek-r1:70b"
        echo "Command: ollama run deepseek-r1:70b"
        echo "Rationale: Cost-sensitive code review - using free local reasoning model"
        return 0
        ;;
      research)
        echo "Model: qwen3-next:80b"
        echo "Command: ollama run qwen3-next:80b"
        echo "Rationale: Cost-sensitive research/analysis - using free local general model"
        return 0
        ;;
      decision)
        echo "Model: deepseek-r1:70b + qwen3-next:80b"
        echo "Command: bash -c 'echo \"Model 1 (DeepSeek R1):\" && ollama run deepseek-r1:70b && echo -e \"\\nModel 2 (Qwen):\\\" && ollama run qwen3-next:80b'"
        echo "Rationale: Cost-sensitive critical decision - using best-reasoning + general local models"
        return 0
        ;;
      default)
        echo "Model: qwen3-next:80b"
        echo "Command: ollama run qwen3-next:80b"
        echo "Rationale: Cost-sensitive generic task - using free local model"
        return 0
        ;;
    esac
  fi

  # Step 3: Do you need the latest information/web search or 1M+ context window?
  if [[ "$large_context" == "true" ]]; then
    echo "Model: gemini-3-pro"
    echo "Command: gemini chat --model gemini-3-pro"
    echo "Rationale: 1M+ token context needed - only Gemini 3 Pro can handle this scale"
    return 0
  fi

  # Step 4: Is this a critical decision?
  if [[ "$task_type" == "decision" ]]; then
    echo "Model: consensus"
    echo "Selected: gemini-3-pro + deepseek-r1:70b (local) + claude"
    echo "Command: bash /tmp/multi-model-consensus.sh"
    echo "Rationale: Critical decision - get consensus from multiple models to reduce bias"
    return 0
  fi

  # Step 5: Need specialized coding?
  if [[ "$task_type" == "coding" ]]; then
    echo "Model: claude-opus-4-5"
    echo "Command: Using Claude directly (current session)"
    echo "Rationale: Cloud-based, cost-insensitive coding - Claude Opus for highest quality"
    return 0
  fi

  # Step 6: Code review with cost flexibility
  if [[ "$task_type" == "review" ]]; then
    echo "Model: consensus"
    echo "Selected: gemini-3-pro + deepseek-r1:70b (local)"
    echo "Command: bash /tmp/multi-model-review.sh"
    echo "Rationale: Code review benefits from multiple perspectives on non-sensitive code"
    return 0
  fi

  # Step 7: Research/Analysis with cost flexibility
  if [[ "$task_type" == "research" ]]; then
    echo "Model: gemini-3-pro"
    echo "Command: gemini chat --model gemini-3-pro"
    echo "Rationale: Research/analysis - Gemini 3 Pro for 1M context and latest information"
    return 0
  fi

  # Default: Start local, fall back to cloud
  echo "Model: ollama-with-fallback"
  echo "Selected: qwen3-next:80b (local) → gemini-3-pro (cloud fallback)"
  echo "Command: ollama run qwen3-next:80b || gemini chat --model gemini-3-pro"
  echo "Rationale: Default/general task - try local first for cost/privacy, fall back to cloud if needed"
  return 0
}

# Execute the selection logic and format output
select_model "$TASK_TYPE" "$COST_SENSITIVE" "$PRIVATE" "$LARGE_CONTEXT"
