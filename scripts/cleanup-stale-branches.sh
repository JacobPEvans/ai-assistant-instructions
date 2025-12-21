#!/usr/bin/env bash
# cleanup-stale-branches.sh - Safely identify and delete merged branches
#
# This script identifies feature and fix branches that have been merged into main
# and are safe to delete. It excludes branches with active open PRs.
#
# Usage: cleanup-stale-branches.sh [options]
#   --local-only       (flag - only delete local branches, not remote)
#   --remote-only      (flag - only delete remote branches)
#   --apply            (flag - actually delete branches; without flag, shows what would be deleted)
#   --exclude=<branch> (comma-separated list of branch names to preserve)
#
# Output:
#   Lists branches that are safe to delete
#   If --apply is used, actually deletes them
#   If --dry-run (default), shows what would be deleted

set -euo pipefail

# Configuration
LOCAL_ONLY=false
REMOTE_ONLY=false
APPLY_CHANGES=false
EXCLUDED_BRANCHES="main,master,develop"

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --local-only)
      LOCAL_ONLY=true
      REMOTE_ONLY=false
      shift
      ;;
    --remote-only)
      LOCAL_ONLY=false
      REMOTE_ONLY=true
      shift
      ;;
    --apply)
      APPLY_CHANGES=true
      shift
      ;;
    --exclude=*)
      EXCLUDED_BRANCHES="${EXCLUDED_BRANCHES},${1#*=}"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: cleanup-stale-branches.sh [--local-only|--remote-only] [--apply] [--exclude=branch1,branch2]"
      exit 1
      ;;
  esac
done

# Helper function to check if branch is in excluded list
is_excluded() {
  local branch="$1"
  IFS=',' read -ra EXCLUDED <<< "$EXCLUDED_BRANCHES"
  for excluded in "${EXCLUDED[@]}"; do
    if [[ "$branch" == "$excluded" ]]; then
      return 0
    fi
  done
  return 1
}

# Get list of merged PR branches (branches that have been merged via PR)
get_merged_pr_branches() {
  if command -v gh &> /dev/null; then
    gh pr list --state merged --limit 100 --json headRefName --jq '.[].headRefName' 2>/dev/null || echo ""
  fi
}

# Get list of open PR branches to avoid deleting them
get_open_pr_branches() {
  if command -v gh &> /dev/null; then
    gh pr list --state open --json headRefName --jq '.[].headRefName' 2>/dev/null || echo ""
  fi
}

# Helper function to check if branch has an open PR
has_open_pr() {
  local branch="$1"
  local open_prs
  open_prs=$(get_open_pr_branches)

  if [[ -z "$open_prs" ]]; then
    return 1
  fi

  while IFS= read -r pr_branch; do
    if [[ "$branch" == "$pr_branch" ]]; then
      return 0
    fi
  done <<< "$open_prs"

  return 1
}

# Function to get merged local branches
get_merged_local_branches() {
  git branch --merged main --format='%(refname:short)' | while read -r branch; do
    if ! is_excluded "$branch"; then
      echo "$branch"
    fi
  done
}

# Function to get merged remote branches
get_merged_remote_branches() {
  # Get all remote branches that have been merged to main
  # Filter out origin/HEAD and main branch
  git branch --remotes --merged main --format='%(refname:short)' | \
    grep "origin/" | \
    grep -v "origin/HEAD" | \
    grep -v "origin/main" | \
    sed 's|origin/||' | \
    while read -r branch; do
      if ! is_excluded "$branch"; then
        echo "$branch"
      fi
    done
}

# Main cleanup logic
main() {
  local branches_to_delete=()
  local branches_with_open_prs=()

  echo "Analyzing branches for safe deletion..."
  echo ""

  # Get merged PR branches from GitHub API
  local merged_branches
  merged_branches=$(get_merged_pr_branches)

  # Get open PR branches from GitHub API
  local open_branches
  open_branches=$(get_open_pr_branches)

  # Process each merged branch
  if [[ -n "$merged_branches" ]]; then
    while IFS= read -r branch; do
      if [[ -z "$branch" ]]; then
        continue
      fi

      # Check if branch has an open PR
      if echo "$open_branches" | grep -q "^$branch$"; then
        branches_with_open_prs+=("$branch")
      else
        branches_to_delete+=("$branch")
      fi
    done <<< "$merged_branches"
  fi

  # Also check for any local-only merged branches (from git)
  if [[ "$REMOTE_ONLY" != "true" ]]; then
    while IFS= read -r branch; do
      # Skip if already in one of our lists
      local already_included=false
      for existing in "${branches_to_delete[@]}" "${branches_with_open_prs[@]}"; do
        if [[ "$existing" == "$branch" ]]; then
          already_included=true
          break
        fi
      done

      if [[ "$already_included" != "true" ]] && ! is_excluded "$branch"; then
        if echo "$open_branches" | grep -q "^$branch$"; then
          branches_with_open_prs+=("$branch")
        else
          branches_to_delete+=("$branch")
        fi
      fi
    done < <(get_merged_local_branches)
  fi

  # Display results
  local total_to_delete=${#branches_to_delete[@]}
  local total_preserved=${#branches_with_open_prs[@]}

  if [[ $total_to_delete -gt 0 ]]; then
    echo "Merged branches safe to delete ($total_to_delete):"
    echo "========================================"
    printf '%s\n' "${branches_to_delete[@]}" | sort
    echo ""
  fi

  if [[ $total_preserved -gt 0 ]]; then
    echo "Branches with open PRs (preserved: $total_preserved):"
    echo "========================================"
    printf '%s\n' "${branches_with_open_prs[@]}" | sort
    echo ""
  fi

  if [[ $total_to_delete -eq 0 ]]; then
    echo "No stale branches found. Repository is clean!"
    return 0
  fi

  # Apply deletions if requested
  if [[ "$APPLY_CHANGES" == "true" ]]; then
    echo "Deleting $total_to_delete branches..."
    echo ""

    local deleted_count=0
    local failed_count=0

    for branch in "${branches_to_delete[@]}"; do
      # Try to delete local branch
      if git show-ref --quiet "refs/heads/$branch"; then
        if git branch -d "$branch" 2>/dev/null; then
          echo "  ✓ Deleted local: $branch"
          ((deleted_count++))
        else
          echo "  ✗ Failed to delete local: $branch"
          ((failed_count++))
        fi
      fi

      # Try to delete remote branch
      if [[ "$LOCAL_ONLY" != "true" ]] && git show-ref --quiet "refs/remotes/origin/$branch"; then
        if git push origin --delete "$branch" 2>/dev/null; then
          echo "  ✓ Deleted remote: origin/$branch"
          ((deleted_count++))
        else
          echo "  ✗ Failed to delete remote: origin/$branch"
          ((failed_count++))
        fi
      fi
    done

    echo ""
    echo "Cleanup summary:"
    echo "  Successfully deleted: $deleted_count branches"
    if [[ $failed_count -gt 0 ]]; then
      echo "  Failed to delete: $failed_count branches"
    fi
  else
    if [[ $total_to_delete -gt 0 ]]; then
      echo "To apply these deletions, run:"
      echo "  bash scripts/cleanup-stale-branches.sh --apply"
      echo ""
    fi
  fi
}

main "$@"
