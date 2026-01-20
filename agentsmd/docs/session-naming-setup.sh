#!/bin/bash
# Claude Code Session Naming Helper
#
# This script provides utilities for managing Claude Code sessions with
# clear naming conventions and git branch integration.
#
# Installation:
#   1. Copy this file to ~/.local/bin/claude-session-helper
#   2. Make it executable: chmod +x ~/.local/bin/claude-session-helper
#   3. Add to your shell config (~/.zshrc, ~/.bashrc, etc.):
#      alias claude-session="claude-session-helper"
#
# Usage:
#   claude-session start           # Start new session with optional name
#   claude-session branch          # Start session named after git branch
#   claude-session issue <number>  # Start session for an issue
#   claude-session resume <name>   # Resume a named session

set -euo pipefail

SCRIPT_NAME="claude-session-helper"
VERSION="1.0.0"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_header() {
    echo ""
    echo -e "${BLUE}╭─────────────────────────────────────────╮${NC}"
    echo -e "${BLUE}│ $1${NC}"
    echo -e "${BLUE}╰─────────────────────────────────────────╯${NC}"
    echo ""
}

# Check if in git repository
is_git_repo() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# Get current git branch
get_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-repo"
}

# Validate branch name for safety
validate_branch_name() {
    local name="$1"
    # Only allow alphanumeric, hyphens, slashes, and underscores
    if [[ ! "$name" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
        print_error "Invalid branch name. Only alphanumeric, -, _, / allowed."
        return 1
    fi
    return 0
}

# Sanitize name for Claude Code session naming
sanitize_name() {
    local name="$1"
    # Convert to lowercase, replace spaces and special chars with hyphens
    echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | tr -s '-' | sed 's/^-//;s/-$//'
}

# Show available sessions
list_sessions() {
    print_header "Available Sessions"

    local projects_dir="$HOME/.claude/projects"
    if [ ! -d "$projects_dir" ]; then
        print_warning "No sessions found (projects directory doesn't exist)"
        return 1
    fi

    if [ -z "$(ls -A "$projects_dir")" ]; then
        print_warning "No sessions found"
        return 1
    fi

    echo "Sessions in $projects_dir:"
    echo ""

    ls -1 "$projects_dir" | while read -r project_dir; do
        # Decode the project directory name
        local decoded="${project_dir//-Users-jevans/~}"
        echo "  • $decoded"
    done
}

# Start new session
cmd_start() {
    local name="${1:-}"

    if [ -z "$name" ]; then
        print_info "No session name provided"
        read -p "Enter session name (or press Enter to skip): " name
    fi

    if [ -n "$name" ]; then
        local sanitized=$(sanitize_name "$name")
        print_info "Starting new Claude Code session"
        print_info "You will be prompted to rename your session to: $sanitized"
        echo ""

        # Start Claude Code in interactive mode
        claude

        # After Claude closes, show reminder
        echo ""
        print_info "Remember to rename your session with: /rename $sanitized"
    else
        print_info "Starting new Claude Code session (interactive)"
        claude
    fi
}

# Start session named after current git branch
cmd_branch() {
    if ! is_git_repo; then
        print_error "Not in a git repository"
        return 1
    fi

    local branch=$(get_git_branch)
    # Validate branch name before using it
    if ! validate_branch_name "$branch"; then
        print_error "Branch name contains invalid characters"
        return 1
    fi

    local session_name=$(sanitize_name "$branch")

    print_header "Git Branch Session"
    print_info "Current branch: $branch"
    print_info "Session name: $session_name"
    echo ""

    # Try to resume existing session
    print_info "Looking for existing session..."
    if claude --resume "$session_name" --no-session-persistence=false 2>/dev/null; then
        print_success "Resumed session: $session_name"
        return 0
    fi

    # If no existing session, start new one
    print_info "No existing session found, starting new one"
    print_info "You will be prompted to rename your session to: $session_name"
    echo ""

    claude --system-prompt "You are working on git branch: $branch" || true

    echo ""
    print_info "Remember to rename your session with: /rename $session_name"
}

# Start session for an issue
cmd_issue() {
    local issue_num="$1"

    if [ -z "$issue_num" ]; then
        print_error "Issue number required"
        echo "Usage: $SCRIPT_NAME issue <number>"
        return 1
    fi

    local session_name="issue-${issue_num}"

    print_header "Issue Session"
    print_info "Issue number: #$issue_num"
    print_info "Session name: $session_name"
    echo ""

    # Try to resume existing session
    print_info "Looking for existing session..."
    if claude --resume "$session_name" 2>/dev/null; then
        print_success "Resumed session: $session_name"
        return 0
    fi

    # If no existing session, start new one
    print_info "No existing session found, starting new one"
    echo ""

    claude || true

    echo ""
    print_info "Remember to rename your session with: /rename $session_name"
}

# Resume a session
cmd_resume() {
    local search_term="${1:-}"

    if [ -z "$search_term" ]; then
        print_header "Available Sessions"
        print_info "Opening session picker..."
        claude --resume
    else
        # Sanitize search term to prevent command injection
        local safe_term
        safe_term=$(sanitize_name "$search_term")
        if [ -z "$safe_term" ]; then
            print_error "Invalid search term. Only alphanumeric and hyphens allowed."
            return 1
        fi
        print_header "Finding Sessions"
        print_info "Searching for: $safe_term"
        claude --resume "$safe_term"
    fi
}

# Show help
show_help() {
    cat << 'EOF'
Claude Code Session Naming Helper v1.0.0

USAGE:
  claude-session <command> [options]

COMMANDS:
  start [name]          Start a new session with optional name
                        Example: claude-session start "my-feature"

  branch                Start/resume session named after git branch
                        (requires being in a git repository)
                        Example: claude-session branch

  issue <number>        Start/resume session for a GitHub issue
                        Example: claude-session issue 95

  resume [search]       Resume a named session
                        With search term: filters matching sessions
                        Without search term: interactive picker
                        Example: claude-session resume feature-xyz

  list                  List all available sessions
                        Example: claude-session list

  -h, --help            Show this help message
  -v, --version         Show version

NAMING CONVENTIONS:
  • Use descriptive names in lowercase
  • Replace spaces with hyphens
  • Include context: "issue-95", "feat-auth", "fix-memory-leak"
  • Examples:
    - issue-95-session-naming
    - feat-auth-refactor
    - fix-memory-leak
    - docs-api-update

EXAMPLES:
  # Start a new session
  claude-session start

  # Start session named "feature-xyz"
  claude-session start feature-xyz

  # Start session named after current git branch
  cd ~/git/myproject
  git checkout -b feat/auth-service
  claude-session branch

  # Resume a previous session
  claude-session resume feature-xyz

  # Resume session for issue #95
  claude-session resume issue-95

For more information, see:
  https://github.com/JacobPEvans/ai-assistant-instructions/blob/main/agentsmd/docs/claude-code-session-naming.md

EOF
}

# Main entry point
main() {
    local command="${1:-}"

    case "${command}" in
        start)
            cmd_start "${2:-}"
            ;;
        branch)
            cmd_branch
            ;;
        issue)
            cmd_issue "${2:-}"
            ;;
        resume)
            cmd_resume "${2:-}"
            ;;
        list)
            list_sessions
            ;;
        -h|--help|help)
            show_help
            ;;
        -v|--version|version)
            echo "$SCRIPT_NAME version $VERSION"
            ;;
        "")
            print_error "No command specified"
            echo ""
            show_help
            return 1
            ;;
        *)
            print_error "Unknown command: $command"
            echo ""
            show_help
            return 1
            ;;
    esac
}

# Run main function
main "$@"
