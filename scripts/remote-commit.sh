#!/usr/bin/env bash
#
# remote-commit.sh - Helper script for making commits via GitHub API without local clone
#
# This script provides utilities for making commits directly via the GitHub API,
# supporting both single-file updates (Contents API) and multi-file commits (Git Data API).
#
# Usage:
#   ./remote-commit.sh single-file <repo> <branch> <file-path> <content-file> <message>
#   ./remote-commit.sh multi-file <repo> <branch> <commit-message> <file1:content1> [file2:content2...]
#   ./remote-commit.sh workflow <repo> <workflow-id> [inputs-json]
#
# Examples:
#   # Update a single file
#   ./remote-commit.sh single-file owner/repo main README.md /tmp/readme.txt "Update README"
#
#   # Commit multiple files
#   ./remote-commit.sh multi-file owner/repo main "Update docs" \
#     docs/guide.md:/tmp/guide.txt \
#     docs/api.md:/tmp/api.txt
#
#   # Trigger a workflow
#   ./remote-commit.sh workflow owner/repo deploy.yml main '{"environment":"production"}'
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Usage information
usage() {
    cat <<EOF
Usage: $(basename "$0") <command> [options]

Commands:
    single-file <repo> <branch> <file-path> <content-file> <message>
        Update a single file using the Contents API

        Arguments:
            repo          Repository in format 'owner/repo'
            branch        Target branch name
            file-path     Path to file in repository (e.g., README.md)
            content-file  Local file containing new content
            message       Commit message

    multi-file <repo> <branch> <message> <file:content> [file:content...]
        Commit multiple files using the Git Data API

        Arguments:
            repo          Repository in format 'owner/repo'
            branch        Target branch name
            message       Commit message
            file:content  Pairs of repo-path:local-file (e.g., docs/a.md:/tmp/a.txt)

    workflow <repo> <workflow-id> <ref> [inputs-json]
        Trigger a workflow dispatch event

        Arguments:
            repo          Repository in format 'owner/repo'
            workflow-id   Workflow file name or ID
            ref           Branch, tag, or commit SHA to run workflow on
            inputs-json   Optional JSON object of workflow inputs

Examples:
    # Update README.md
    $(basename "$0") single-file myorg/myrepo main README.md /tmp/readme.txt "docs: Update README"

    # Commit multiple documentation files
    $(basename "$0") multi-file myorg/myrepo main "docs: Update guides" \\
        docs/guide.md:/tmp/guide.txt \\
        docs/api.md:/tmp/api.txt

    # Trigger deployment workflow on main branch
    $(basename "$0") workflow myorg/myrepo deploy.yml main '{"environment":"prod"}'

EOF
    exit 1
}

# Check GitHub CLI authentication
check_auth() {
    if ! command -v gh &>/dev/null; then
        log_error "GitHub CLI (gh) is not installed"
        log_error "Install it from: https://cli.github.com/"
        exit 1
    fi

    if ! gh auth status &>/dev/null; then
        log_error "Not authenticated with GitHub CLI"
        log_error "Run: gh auth login"
        exit 1
    fi

    if ! command -v jq &>/dev/null; then
        log_error "jq is not installed"
        log_error "Install it from: https://stedolan.github.io/jq/"
        exit 1
    fi

    log_info "GitHub CLI authentication verified"
}

# Get the current SHA of a file (needed for Contents API updates)
get_file_sha() {
    local repo="$1"
    local branch="$2"
    local file_path="$3"

    local response
    response=$(gh api "repos/$repo/contents/$file_path?ref=$branch" 2>/dev/null || echo "")

    if [[ -z "$response" ]]; then
        echo ""
        return
    fi

    echo "$response" | jq -r '.sha'
}

# Base64 encode content (portable across macOS and Linux)
base64_encode() {
    if [[ "$(uname)" == "Darwin" ]]; then
        base64 < "$1"
    else
        base64 -w 0 < "$1"
    fi
}

# Update a single file using Contents API
single_file_commit() {
    local repo="$1"
    local branch="$2"
    local file_path="$3"
    local content_file="$4"
    local message="$5"

    if [[ ! -f "$content_file" ]]; then
        log_error "Content file not found: $content_file"
        exit 1
    fi

    log_info "Getting current file SHA..."
    local current_sha
    current_sha=$(get_file_sha "$repo" "$branch" "$file_path")

    log_info "Encoding file content..."
    local encoded_content
    encoded_content=$(base64_encode "$content_file" | tr -d '\n')

    log_info "Creating commit via Contents API..."
    local payload
    payload=$(jq -n \
        --arg msg "$message" \
        --arg content "$encoded_content" \
        --arg branch "$branch" \
        --arg sha "$current_sha" \
        '{
            message: $msg,
            content: $content,
            branch: $branch
        } + (if $sha != "" then {sha: $sha} else {} end)')

    local response
    if response=$(gh api "repos/$repo/contents/$file_path" \
        --method PUT \
        --input - <<< "$payload" 2>&1); then
        log_info "Successfully committed to $repo/$file_path on branch $branch"
        echo "$response" | jq -r '.commit.html_url'
        return 0
    else
        log_error "Failed to commit file"
        log_error "$response"
        exit 1
    fi
}

# Commit multiple files using Git Data API
multi_file_commit() {
    local repo="$1"
    local branch="$2"
    local message="$3"
    shift 3
    local file_pairs=("$@")

    if [[ ${#file_pairs[@]} -eq 0 ]]; then
        log_error "No files specified for multi-file commit"
        exit 1
    fi

    log_info "Getting current commit SHA for branch $branch..."
    local base_commit
    base_commit=$(gh api "repos/$repo/git/refs/heads/$branch" --jq '.object.sha')

    log_info "Getting base tree SHA..."
    local base_tree
    base_tree=$(gh api "repos/$repo/git/commits/$base_commit" --jq '.tree.sha')

    log_info "Creating tree with ${#file_pairs[@]} file(s)..."
    local tree_items=()

    for pair in "${file_pairs[@]}"; do
        if [[ "$pair" != *:* ]]; then
            log_error "Invalid file pair '$pair'. Expected format 'path-in-repo:local-file-path' (e.g., 'docs/guide.md:./guide.md')."
            exit 1
        fi

        local repo_path="${pair%%:*}"
        local local_file="${pair#*:}"

        if [[ ! -f "$local_file" ]]; then
            log_error "Content file not found: $local_file"
            exit 1
        fi

        log_info "  - Processing $repo_path"

        # Create blob for file content (use base64 encoding for robustness)
        local blob_content
        # Prefer single-line base64 output; fall back for implementations without -w
        if blob_content=$(base64 -w0 "$local_file" 2>/dev/null); then
            :
        else
            blob_content=$(base64 "$local_file" | tr -d '\n')
        fi

        local blob_sha
        blob_sha=$(gh api "repos/$repo/git/blobs" \
            --method POST \
            --field content="$blob_content" \
            --field encoding="base64" \
            --jq '.sha')

        tree_items+=("$(jq -n \
            --arg path "$repo_path" \
            --arg sha "$blob_sha" \
            '{path: $path, mode: "100644", type: "blob", sha: $sha}')")
    done

    # Create tree with all blobs
    local tree_json
    tree_json=$(printf '%s\n' "${tree_items[@]}" | jq -s '.')

    local new_tree
    new_tree=$(gh api "repos/$repo/git/trees" \
        --method POST \
        --field base_tree="$base_tree" \
        --raw-field tree="$tree_json" \
        --jq '.sha')

    log_info "Creating commit..."
    local new_commit
    new_commit=$(gh api "repos/$repo/git/commits" \
        --method POST \
        --field message="$message" \
        --field tree="$new_tree" \
        --raw-field parents="[\"$base_commit\"]" \
        --jq '.sha')

    log_info "Updating branch reference..."
    gh api "repos/$repo/git/refs/heads/$branch" \
        --method PATCH \
        --field sha="$new_commit" >/dev/null

    log_info "Successfully committed ${#file_pairs[@]} file(s) to $repo on branch $branch"
    echo "https://github.com/$repo/commit/$new_commit"
}

# Trigger a workflow dispatch
workflow_dispatch() {
    local repo="$1"
    local workflow_id="$2"
    local ref="$3"
    local inputs_json="${4:-}"

    log_info "Triggering workflow $workflow_id in $repo on ref $ref..."

    local payload
    if [[ -n "$inputs_json" ]]; then
        payload=$(jq -n \
            --arg ref "$ref" \
            --argjson inputs "$inputs_json" \
            '{ref: $ref, inputs: $inputs}')
    else
        payload=$(jq -n \
            --arg ref "$ref" \
            '{ref: $ref}')
    fi

    if gh api "repos/$repo/actions/workflows/$workflow_id/dispatches" \
        --method POST \
        --input - <<< "$payload" &>/dev/null; then
        log_info "Successfully triggered workflow $workflow_id"
        log_info "View runs at: https://github.com/$repo/actions/workflows/$workflow_id"
        return 0
    else
        log_error "Failed to trigger workflow"
        exit 1
    fi
}

# Main script logic
main() {
    if [[ $# -lt 1 ]]; then
        usage
    fi

    local command="$1"
    shift

    check_auth

    case "$command" in
        single-file)
            if [[ $# -ne 5 ]]; then
                log_error "Invalid arguments for single-file command"
                usage
            fi
            single_file_commit "$@"
            ;;
        multi-file)
            if [[ $# -lt 4 ]]; then
                log_error "Invalid arguments for multi-file command"
                usage
            fi
            multi_file_commit "$@"
            ;;
        workflow)
            if [[ $# -lt 3 ]]; then
                log_error "Invalid arguments for workflow command"
                usage
            fi
            workflow_dispatch "$@"
            ;;
        -h|--help|help)
            usage
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            ;;
    esac
}

main "$@"
