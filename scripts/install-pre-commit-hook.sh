#!/usr/bin/env bash
# Install pre-commit hook for command token enforcement
set -euo pipefail

# Find the main .git directory
GIT_DIR=$(git rev-parse --git-common-dir)
HOOK_FILE="${GIT_DIR}/hooks/pre-commit"
TOKEN_SCRIPT="$(git rev-parse --show-toplevel)/scripts/check-command-tokens.sh"

echo "Installing pre-commit hook..."
echo "Git directory: ${GIT_DIR}"
echo "Hook file: ${HOOK_FILE}"

# Create hooks directory if it doesn't exist
mkdir -p "${GIT_DIR}/hooks"

# Create or append to pre-commit hook
if [[ -f "${HOOK_FILE}" ]]; then
    echo "WARNING: Pre-commit hook already exists"
    echo "Backing up to pre-commit.backup"
    cp "${HOOK_FILE}" "${HOOK_FILE}.backup"
fi

# Write the hook
cat > "${HOOK_FILE}" << 'EOF'
#!/usr/bin/env bash
# Command token limit enforcement
# Auto-installed by scripts/install-pre-commit-hook.sh

REPO_ROOT=$(git rev-parse --show-toplevel)
TOKEN_SCRIPT="${REPO_ROOT}/scripts/check-command-tokens.sh"

# Only run if checking in command files
if git diff --cached --name-only | grep -q "^agentsmd/commands/.*\.md$"; then
    echo "Checking command token limits..."
    if ! bash "${TOKEN_SCRIPT}"; then
        echo ""
        echo "Commit blocked due to token limit violations."
        echo "Fix the violations before committing."
        exit 1
    fi
fi

exit 0
EOF

chmod +x "${HOOK_FILE}"

echo ""
echo "✓ Pre-commit hook installed successfully"
echo "✓ Hook will run automatically on commits that modify command files"
echo ""
echo "To test: git commit -m \"test\""
echo "To bypass (NOT RECOMMENDED): git commit --no-verify"
echo ""
