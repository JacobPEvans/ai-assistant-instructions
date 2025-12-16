#!/bin/bash
# Validate Claude Code commands have description and allowed-tools (correct field name, not "tools")
set -e; ERRORS=0
for f in $(find . -path "*commands/*.md" 2>/dev/null | grep -v node_modules); do
  [ -L "$f" ] && continue
  FM=$(sed -n '/^---$/,/^---$/p' "$f" 2>/dev/null)
  echo "$FM" | grep -q "^description:" || { echo "ERROR: $f missing description"; ERRORS=$((ERRORS+1)); }
  echo "$FM" | grep -q "^allowed-tools:" || { echo "ERROR: $f missing allowed-tools"; ERRORS=$((ERRORS+1)); }
  echo "$FM" | grep -q "^tools:" && { echo "ERROR: $f uses 'tools:' instead of 'allowed-tools:'"; ERRORS=$((ERRORS+1)); }
done
[ $ERRORS -eq 0 ] && echo "All command files valid" || exit 1
