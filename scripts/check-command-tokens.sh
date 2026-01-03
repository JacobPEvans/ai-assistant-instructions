#!/usr/bin/env bash
# Token limit enforcement for command files
# Hard 1k token limit per command with no bypass

set -euo pipefail

MAX_TOKENS=1000
VIOLATIONS=0
COMMANDS_DIR="agentsmd/commands"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Checking command token limits..."
echo "Maximum allowed: ${MAX_TOKENS} tokens per command"
echo ""

# When run as a pre-commit hook, check only staged files
# Otherwise, check all command files
FILES_TO_CHECK=()
if [[ $# -gt 0 ]]; then
    # Files passed as arguments (from pre-commit hook)
    for file in "$@"; do
        [[ -f "$file" ]] && FILES_TO_CHECK+=("$file")
    done
else
    # Check all command files
    for file in ${COMMANDS_DIR}/*.md; do
        [[ -f "$file" ]] && FILES_TO_CHECK+=("$file")
    done
fi

# Check each command file
for file in "${FILES_TO_CHECK[@]}"; do
    [[ ! -f "$file" ]] && continue

    # Calculate approximate token count (chars / 4)
    chars=$(wc -c < "$file")
    tokens=$((chars / 4))

    filename=$(basename "$file")

    if [[ $tokens -gt $MAX_TOKENS ]]; then
        echo -e "${RED}✗ VIOLATION${NC}: $filename exceeds limit (${tokens} > ${MAX_TOKENS})"
        VIOLATIONS=$((VIOLATIONS + 1))
    else
        echo -e "${GREEN}✓ PASS${NC}: $filename (${tokens} tokens)"
    fi
done

echo ""

if [[ $VIOLATIONS -gt 0 ]]; then
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}HARD BLOCK: ${VIOLATIONS} command(s) exceed ${MAX_TOKENS} token limit${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "To fix:"
    echo "  1. Extract complex logic to .claude/agents/"
    echo "  2. Reference skills instead of duplicating patterns"
    echo "  3. Remove content Claude already knows"
    echo "  4. Follow command-agent-skill hierarchy"
    echo ""
    echo "See: ${HOME}/.claude/plans/replicated-weaving-puppy.md"
    echo ""
    exit 1
else
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}All commands pass token limit check!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
fi
