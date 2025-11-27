#!/bin/bash
# SessionStart Hook - Invokes Session Initializer Pattern
#
# This hook runs automatically when Claude Code:
# - Starts a new session (startup)
# - Resumes an existing session (resume)
# - Performs context compaction (compact)
#
# Integrates with: .ai-instructions/subagents/session-initializer.md
# See: .ai-instructions/concepts/progress-checkpoint.md

set -e

# Get project directory from Claude Code environment
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Define key paths
MEMORY_BANK_DIR="$PROJECT_DIR/.ai-instructions/concepts/memory-bank"
CHECKPOINT_FILE="$MEMORY_BANK_DIR/progress-checkpoint.md"
ACTIVE_CONTEXT_FILE="$MEMORY_BANK_DIR/active-context.md"
TASK_QUEUE_FILE="$MEMORY_BANK_DIR/task-queue.md"
INSTRUCTIONS_FILE="$PROJECT_DIR/.ai-instructions/INSTRUCTIONS.md"
INDEX_FILE="$PROJECT_DIR/.ai-instructions/INDEX.md"

# Initialize context output
CONTEXT_OUTPUT=""
WARNINGS=""
ERRORS=""

# Function to append to context
add_context() {
    CONTEXT_OUTPUT="${CONTEXT_OUTPUT}${1}\n"
}

# Function to append warning
add_warning() {
    WARNINGS="${WARNINGS}  - ${1}\n"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# SECTION 1: Environment Validation
# ============================================================================

add_context "## Session Initialization Report"
add_context ""
add_context "**Timestamp**: $(date -Iseconds)"
add_context "**Project**: $PROJECT_DIR"
add_context ""

# Check Node.js
if command_exists node; then
    NODE_VERSION=$(node --version 2>/dev/null || echo "unknown")
    add_context "- Node.js: $NODE_VERSION"
else
    add_warning "Node.js not found"
fi

# Check npm
if command_exists npm; then
    NPM_VERSION=$(npm --version 2>/dev/null || echo "unknown")
    add_context "- npm: v$NPM_VERSION"
else
    add_warning "npm not found"
fi

# Check git
if command_exists git; then
    GIT_VERSION=$(git --version 2>/dev/null | cut -d' ' -f3 || echo "unknown")
    add_context "- Git: v$GIT_VERSION"
else
    add_warning "Git not found"
fi

add_context ""

# ============================================================================
# SECTION 2: Git State Check
# ============================================================================

add_context "### Git State"
add_context ""

if [ -d "$PROJECT_DIR/.git" ]; then
    cd "$PROJECT_DIR"

    # Current branch
    BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
    add_context "- Branch: \`$BRANCH\`"

    # Check for uncommitted changes
    DIRTY_FILES=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [ "$DIRTY_FILES" -gt 0 ]; then
        add_context "- **Uncommitted changes**: $DIRTY_FILES files"
        add_warning "Repository has $DIRTY_FILES uncommitted files - consider committing or stashing"

        # List changed files (max 5)
        CHANGED=$(git status --porcelain 2>/dev/null | head -5)
        add_context "\`\`\`"
        add_context "$CHANGED"
        if [ "$DIRTY_FILES" -gt 5 ]; then
            add_context "... and $((DIRTY_FILES - 5)) more"
        fi
        add_context "\`\`\`"
    else
        add_context "- Working tree: clean"
    fi

    # Last commit
    LAST_COMMIT=$(git log -1 --format="%h %s" 2>/dev/null || echo "none")
    add_context "- Last commit: \`$LAST_COMMIT\`"
else
    add_warning "Not a git repository"
fi

add_context ""

# ============================================================================
# SECTION 3: Progress Checkpoint Recovery
# ============================================================================

add_context "### Context Recovery"
add_context ""

if [ -f "$CHECKPOINT_FILE" ]; then
    add_context "**Progress checkpoint found**: \`progress-checkpoint.md\`"
    add_context ""

    # Extract key sections from checkpoint (first 50 lines for overview)
    CHECKPOINT_PREVIEW=$(head -50 "$CHECKPOINT_FILE" 2>/dev/null || echo "Could not read checkpoint")
    add_context "<checkpoint_preview>"
    add_context "$CHECKPOINT_PREVIEW"
    add_context "</checkpoint_preview>"
    add_context ""
    add_context "**Action**: Review full checkpoint at \`$CHECKPOINT_FILE\`"
else
    add_context "No progress checkpoint found. Starting fresh session."
    add_context ""
    add_context "**Recommended**: Load context via \`/load-context\` or read:"
    add_context "- [INDEX.md](.ai-instructions/INDEX.md) - Navigation"
    add_context "- [INSTRUCTIONS.md](.ai-instructions/INSTRUCTIONS.md) - Workflow"
fi

add_context ""

# ============================================================================
# SECTION 4: Task Queue Status
# ============================================================================

if [ -f "$TASK_QUEUE_FILE" ]; then
    add_context "### Active Tasks"
    add_context ""

    # Extract pending and in_progress tasks
    ACTIVE_TASKS=$(grep -A 10 "^### TASK-" "$TASK_QUEUE_FILE" 2>/dev/null | \
                   grep -E "(^### TASK-|Status.*pending|Status.*in_progress)" | \
                   head -10 || echo "")

    if [ -n "$ACTIVE_TASKS" ]; then
        add_context "$ACTIVE_TASKS"
    else
        add_context "No active tasks in queue."
    fi
    add_context ""
fi

# ============================================================================
# SECTION 5: Warnings Summary
# ============================================================================

if [ -n "$WARNINGS" ]; then
    add_context "### Warnings"
    add_context ""
    add_context "$WARNINGS"
fi

# ============================================================================
# SECTION 6: Quick Start Guidance
# ============================================================================

add_context "### Quick Start"
add_context ""
add_context "1. **Resume work**: Check progress checkpoint above"
add_context "2. **New task**: Follow 5-step workflow in INSTRUCTIONS.md"
add_context "3. **Navigation**: Use INDEX.md for quick reference"
add_context ""
add_context "---"
add_context "*Session initialized by SessionStart hook*"

# ============================================================================
# OUTPUT: Return context to Claude Code
# ============================================================================

# Persist environment variables if CLAUDE_ENV_FILE is set
if [ -n "$CLAUDE_ENV_FILE" ]; then
    echo "export AI_INSTRUCTIONS_DIR=\"$PROJECT_DIR/.ai-instructions\"" >> "$CLAUDE_ENV_FILE"
    echo "export MEMORY_BANK_DIR=\"$MEMORY_BANK_DIR\"" >> "$CLAUDE_ENV_FILE"
fi

# Output the context for Claude to consume
# Using printf for proper newline handling
printf '%b' "$CONTEXT_OUTPUT"

exit 0
