#!/bin/bash
# Validate Claude Code commands have description and allowed-tools (correct field name, not "tools")

ERRORS=0

# Find all command files and validate each
# Using find + while read instead of for loop to comply with project rules
while IFS= read -r -d '' f; do
  # Skip symlinks
  [ -L "$f" ] && continue

  # Extract frontmatter (between --- markers)
  FM=$(sed -n '/^---$/,/^---$/p' "$f" 2>/dev/null)

  # Check for required 'description' field
  if ! grep -q "^description:" <<< "$FM"; then
    echo "ERROR: $f missing description"
    ((ERRORS++))
  fi

  # Check for required 'allowed-tools' field
  if ! grep -q "^allowed-tools:" <<< "$FM"; then
    echo "ERROR: $f missing allowed-tools"
    ((ERRORS++))
  fi

  # Check for deprecated 'tools' field (should use 'allowed-tools')
  if grep -q "^tools:" <<< "$FM"; then
    echo "ERROR: $f uses 'tools:' instead of 'allowed-tools:'"
    ((ERRORS++))
  fi
done < <(find . -path "*commands/*.md" -not -path "*/node_modules/*" -print0 2>/dev/null)

if [ "$ERRORS" -eq 0 ]; then
  echo "All command files valid"
  exit 0
else
  exit 1
fi
