#!/bin/bash
# Identify .md symlinks and regular files for link checking
# Outputs to GITHUB_OUTPUT or stdout
set -euo pipefail

# Escape value for safe use in GITHUB_OUTPUT (prevents workflow command injection)
# Escapes %, \r, \n which could inject workflow commands via ::
escape_output() {
    printf '%s' "$1" | sed $'s/%/%25/g; s/\r/%0D/g' | tr $'\n' ' '
}

symlinks="" regular="" broken=""

while IFS= read -r -d '' f; do
    if [ -L "$f" ]; then
        [ -e "$f" ] && symlinks+="$f " || broken+="$f:$(readlink "$f") "
    else
        regular+="$f "
    fi
done < <(find . -name '*.md' -not -path './.git/*' -print0)

{
    echo "symlinks=$(escape_output "${symlinks% }")"
    echo "regular_files=$(escape_output "${regular% }")"
    echo "broken_symlinks=$(escape_output "${broken% }")"
    echo "has_broken_symlinks=$([[ -n "$broken" ]] && echo true || echo false)"
} >> "${GITHUB_OUTPUT:-/dev/stdout}"
