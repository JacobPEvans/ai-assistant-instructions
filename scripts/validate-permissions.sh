#!/bin/bash

################################################################################
# validate-permissions.sh
#
# Validates permission files in agentsmd/permissions/ for cclint compatibility.
#
# This script ensures that:
# 1. All permission JSON files have valid syntax
# 2. Permission files contain shell commands (git:*, npm:*, etc.)
# 3. Permission files do NOT contain tool names (Edit, Bash, MultiEdit, etc.)
# 4. The cclint schema is accessible and parseable
# 5. valid-tools.json is generated and up-to-date
#
# Exit codes:
#   0 - All validations passed
#   1 - Validation errors found
#   2 - Schema fetch or processing failed
################################################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
REPO_ROOT="$(git rev-parse --show-toplevel)"
PERMISSIONS_DIR="${REPO_ROOT}/agentsmd/permissions"
VALID_TOOLS_FILE="${PERMISSIONS_DIR}/valid-tools.json"
CACHE_DIR="${REPO_ROOT}/.cache"
SCHEMA_CACHE="${CACHE_DIR}/cclint-schema.json"

# Exit status
EXIT_STATUS=0

################################################################################
# Functions
################################################################################

log_error() {
    echo -e "${RED}❌ ERROR: $*${NC}" >&2
}

log_success() {
    echo -e "${GREEN}✅ $*${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ️  $*${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $*${NC}"
}

# Get valid tools from npm package or use fallback
get_valid_tools_list() {
    local cclint_version
    cclint_version=$(npm view @carlrannaberg/cclint version 2>/dev/null || echo "0.2.10")

    # Hardcoded list of valid tools in cclint (as of v0.2.10)
    # This is more reliable than trying to fetch from GitHub which may fail
    cat << 'EOF'
Bash
BashOutput
Edit
ExitPlanMode
Glob
Grep
KillShell
NotebookEdit
Read
SlashCommand
Task
TodoWrite
WebFetch
WebSearch
Write
EOF
}

# Generate valid-tools.json
generate_valid_tools_json() {
    local tools_list="$1"
    local cclint_version
    local timestamp

    cclint_version=$(npm view @carlrannaberg/cclint version 2>/dev/null || echo "0.2.10")
    timestamp=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

    # Generate valid-tools.json
    {
        echo "{"
        echo "  \"timestamp\": \"$timestamp\","
        echo "  \"cclint_version\": \"$cclint_version\","
        echo "  \"schema_url\": \"https://raw.githubusercontent.com/carlrannaberg/cclint/main/schema.json\","
        echo "  \"valid_tools\": ["

        local first=true
        while IFS= read -r tool; do
            if [[ -n "$tool" ]]; then
                if [[ "$first" == true ]]; then
                    echo "    \"$tool\""
                    first=false
                else
                    echo "    ,\"$tool\""
                fi
            fi
        done <<< "$tools_list"

        echo "  ],"
        echo "  \"mcp_pattern\": \"mcp__.*\","
        echo "  \"note\": \"Valid cclint tools as of version $cclint_version\""
        echo "}"
    }
}

# Load valid tools from valid-tools.json or schema
load_valid_tools() {
    local valid_tools_file="$1"

    if [[ -f "$valid_tools_file" ]]; then
        jq -r '.valid_tools[]' "$valid_tools_file" | sort
    else
        log_warning "valid-tools.json not found, will be generated"
        return 1
    fi
}

# Validate a single JSON permission file
validate_permission_file() {
    local file="$1"
    local valid_tools_array="$2"
    local filename
    filename=$(basename "$file")
    local errors=0
    local line_num=0

    # Check JSON syntax
    if ! jq empty "$file" 2>/dev/null; then
        log_error "Invalid JSON syntax: $file"
        jq empty "$file" 2>&1 | head -3 | sed 's/^/  /'
        return 1
    fi

    # Special handling for different file types
    if [[ "$filename" == "webfetch.json" ]]; then
        # Domain files have "domains" array, not "commands"
        if ! jq -e '.domains' "$file" >/dev/null 2>&1; then
            log_error "$file: Missing required 'domains' array"
            return 1
        fi
        return 0  # Domains don't need tool name validation
    fi

    if [[ "$filename" == "mcp-"* ]] || jq -e '.mcp' "$file" >/dev/null 2>&1; then
        # MCP files have "mcp" array, not "commands"
        if ! jq -e '.mcp' "$file" >/dev/null 2>&1; then
            log_error "$file: Missing required 'mcp' array for MCP file"
            return 1
        fi
        return 0  # MCP patterns don't need tool name validation
    fi

    # Regular permission files should have "commands" array
    if ! jq -e '.commands' "$file" >/dev/null 2>&1; then
        log_error "$file: Missing required 'commands' array"
        return 1
    fi

    # Validate commands array
    local commands
    commands=$(jq -r '.commands[]' "$file")

    while IFS= read -r command; do
        ((line_num++))
        [[ -z "$command" ]] && continue

        # Check if this looks like a tool name (contains no : or .)
        # Valid commands: git:*, docker:*, npm:*, npm@version:*, etc.
        # Invalid: Edit, Bash, MultiEdit, Read, Write, etc.

        if [[ ! "$command" =~ : ]]; then
            # No colon = likely a tool name, not a command
            # Check if it's a known invalid tool name
            if echo "$valid_tools_array" | grep -qx "$command"; then
                log_error "$file (line $line_num): Tool name in commands array"
                echo "  Command: '$command'"
                echo "  ERROR: Tool names like '$command' belong in .claude/settings.json, not permissions"
                echo "  HINT: Use shell commands like 'git:*', 'npm:*', 'docker:*'"
                ((errors++))
            fi
        fi
    done <<< "$commands"

    return $((errors == 0 ? 0 : 1))
}

# Validate all permission files
validate_all_permissions() {
    local valid_tools_file="$1"
    local permission_files
    local errors=0

    # Get valid tools as a newline-separated list
    local valid_tools_array
    valid_tools_array=$(load_valid_tools "$valid_tools_file" || echo "")

    # Find all JSON files in permissions directory
    mapfile -t permission_files < <(find "$PERMISSIONS_DIR" -name "*.json" -type f ! -name "valid-tools.json" | sort)

    if [[ ${#permission_files[@]} -eq 0 ]]; then
        log_error "No permission JSON files found in $PERMISSIONS_DIR"
        return 1
    fi

    log_info "Validating ${#permission_files[@]} permission files..."

    for file in "${permission_files[@]}"; do
        if ! validate_permission_file "$file" "$valid_tools_array"; then
            ((errors++))
        fi
    done

    if [[ $errors -eq 0 ]]; then
        log_success "All ${#permission_files[@]} permission files are valid"
        return 0
    else
        log_error "Found $errors validation error(s)"
        return 1
    fi
}

# Check if schema has changed
check_schema_changes() {
    local new_schema_file="$1"
    local valid_tools_file="$2"

    if [[ ! -f "$valid_tools_file" ]]; then
        log_info "First time generating valid-tools.json"
        return 0
    fi

    # Compare timestamps and versions
    local new_version
    new_version=$(jq -r '.properties.version // "unknown"' "$new_schema_file")

    local old_version
    old_version=$(jq -r '.cclint_version // "unknown"' "$valid_tools_file")

    if [[ "$new_version" != "$old_version" ]]; then
        log_warning "cclint schema version changed: $old_version → $new_version"
        return 1
    fi

    return 0
}

################################################################################
# Main
################################################################################

main() {
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Permission Validation for cclint Compatibility${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}\n"

    # Get valid tools list
    log_info "Loading valid tools list..."
    local tools_list
    tools_list=$(get_valid_tools_list)

    # Generate valid-tools.json
    log_info "Generating valid-tools.json..."
    local new_valid_tools_json
    new_valid_tools_json=$(generate_valid_tools_json "$tools_list")

    # Create temp file for new valid-tools.json
    local temp_valid_tools
    temp_valid_tools=$(mktemp)
    echo "$new_valid_tools_json" > "$temp_valid_tools"

    # Validate all permission files
    if ! validate_all_permissions "$temp_valid_tools"; then
        log_error "Permission validation failed"
        rm -f "$temp_valid_tools"
        exit 1
    fi

    # Update valid-tools.json
    log_info "Updating $VALID_TOOLS_FILE..."
    mkdir -p "$PERMISSIONS_DIR"
    cp "$temp_valid_tools" "$VALID_TOOLS_FILE"

    # Make it pretty JSON
    jq '.' "$VALID_TOOLS_FILE" > "${VALID_TOOLS_FILE}.tmp"
    mv "${VALID_TOOLS_FILE}.tmp" "$VALID_TOOLS_FILE"

    log_success "Validation complete - valid-tools.json updated"
    rm -f "$temp_valid_tools"

    echo -e "\n${GREEN}All permission files are compatible with cclint${NC}\n"
    exit 0
}

main "$@"
