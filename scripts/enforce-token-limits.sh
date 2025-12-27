#!/usr/bin/env bash
# Enforce token limits on changed files
# Uses atc (anthropic-token-counter) to count tokens
# Configuration via .token-limits.yaml
set -euo pipefail

# Get changed files based on context
if [[ "${EVENT_NAME:-push}" == "pull_request" ]]; then
    BASE_REF="${BASE_REF:-main}"
    CHANGED_FILES=$(git diff --name-only --diff-filter=ACMRT "$BASE_REF...HEAD" 2>/dev/null || echo "")
else
    CHANGED_FILES=$(git diff --name-only HEAD~1..HEAD 2>/dev/null || git ls-files)
fi

# Parse token limits from config
if [[ ! -f ".token-limits.yaml" ]]; then
    echo "❌ Missing .token-limits.yaml configuration"
    exit 1
fi

DEFAULT_LIMIT=$(python3 -c "import yaml; f=open('.token-limits.yaml'); c=yaml.safe_load(f); print(c.get('defaults',{}).get('max_tokens', 2000))" 2>/dev/null || echo "2000")

VIOLATIONS=0
VIOLATIONS_FILE="/tmp/token_violations.json"

echo "Checking token limits (default: $DEFAULT_LIMIT tokens)..."
echo "---"

# Check each changed file
while IFS= read -r file; do
    [[ -z "$file" ]] && continue
    [[ ! -f "$file" ]] && continue

    # Skip binary files
    case "$file" in
        *.png|*.jpg|*.gif|*.pdf|*.bin|*.zip|*.tar|*.gz) continue ;;
    esac

    # Get file limit (simplified - just use default)
    FILE_LIMIT=$DEFAULT_LIMIT

    # Count tokens with atc
    TOKEN_COUNT=$(atc "$file" -m sonnet 2>/dev/null | grep -oE '[0-9]+' | head -1 || echo "0")

    if [[ "$TOKEN_COUNT" -gt "$FILE_LIMIT" ]]; then
        EXCESS=$((TOKEN_COUNT - FILE_LIMIT))
        echo "❌ $file: $TOKEN_COUNT tokens (limit: $FILE_LIMIT, excess: +$EXCESS)"
        VIOLATIONS=$((VIOLATIONS + 1))

        # Save for GitHub Actions comment
        echo "{\"file\": \"$file\", \"tokens\": $TOKEN_COUNT, \"limit\": $FILE_LIMIT, \"excess\": $EXCESS}" >> "$VIOLATIONS_FILE" 2>/dev/null || true
    else
        echo "✅ $file: $TOKEN_COUNT tokens (limit: $FILE_LIMIT)"
    fi
done <<< "$CHANGED_FILES"

echo "---"

if [[ $VIOLATIONS -gt 0 ]]; then
    echo "❌ Found $VIOLATIONS token limit violation(s)"
    echo ""
    echo "To fix:"
    echo "  1. Extract large files to subagents"
    echo "  2. Split monolithic files into focused modules"
    echo "  3. Remove unnecessary examples/documentation"
    exit 1
else
    echo "✅ All files within token limits"
    exit 0
fi
