#!/usr/bin/env bash
# Identify .md symlinks and regular files for link checking
# Outputs to GITHUB_OUTPUT or stdout
set -euo pipefail

symlinks="" regular="" broken=""

while IFS= read -r -d '' f; do
    if [ -L "$f" ]; then
        [ -e "$f" ] && symlinks+="$f " || broken+="$f:$(readlink "$f") "
    else
        regular+="$f "
    fi
done < <(find . -name '*.md' -not -path './.git/*' -print0)

cat >> "${GITHUB_OUTPUT:-/dev/stdout}" <<EOF
symlinks=${symlinks% }
regular_files=${regular% }
broken_symlinks=${broken% }
has_broken_symlinks=$([[ -n "$broken" ]] && echo true || echo false)
EOF
