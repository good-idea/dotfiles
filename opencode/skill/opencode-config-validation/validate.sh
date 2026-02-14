#!/bin/bash
# validate.sh - Validates OpenCode configurations
#
# Usage:
#   validate.sh                    # Validate all configs
#   validate.sh agents             # Validate agents only
#   validate.sh skills             # Validate skills only
#   validate.sh commands           # Validate commands only
#   validate.sh file <path>        # Validate a specific file

set -uo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Track errors
ERRORS=0
WARNINGS=0

# Config directories
GLOBAL_CONFIG="$HOME/.opencode"
LOCAL_CONFIG=".opencode"

log_error() {
  echo -e "${RED}ERROR:${NC} $1"
  ((ERRORS++))
}

log_warning() {
  echo -e "${YELLOW}WARNING:${NC} $1"
  ((WARNINGS++))
}

log_success() {
  echo -e "${GREEN}OK:${NC} $1"
}

log_info() {
  echo -e "$1"
}

# Validate agents using OpenCode CLI
validate_agents() {
  log_info "\n=== Validating Agents ==="
  
  # OpenCode's agent list command validates all agents
  output=$(opencode agent list 2>&1)
  exit_code=$?
  
  if echo "$output" | grep -q "^Error:"; then
    # Extract and display errors
    echo "$output" | grep -E "^(\[91m|Error:|↳)" | while read -r line; do
      # Strip ANSI codes for cleaner output
      clean_line=$(echo "$line" | sed 's/\x1b\[[0-9;]*m//g')
      log_error "$clean_line"
    done
  else
    # Count agents
    agent_count=$(echo "$output" | grep -c "(primary)\|(subagent)" || echo "0")
    log_success "All agents valid ($agent_count found)"
  fi
}

# Validate a single skill directory
validate_skill() {
  local skill_dir="$1"
  local skill_name=$(basename "$skill_dir")
  local skill_file="$skill_dir/SKILL.md"
  
  # Check SKILL.md exists
  if [[ ! -f "$skill_file" ]]; then
    log_error "Skill '$skill_name': Missing SKILL.md file"
    return 1
  fi
  
  # Extract frontmatter (only the first YAML block between --- markers)
  local frontmatter=$(awk '/^---$/{if (!found) {found=1; start=NR; next}} found && /^---$/{end=NR; exit} found{print}' "$skill_file")
  
  if [[ -z "$frontmatter" ]]; then
    log_error "Skill '$skill_name': Missing or invalid frontmatter"
    return 1
  fi
  
  # Check required 'name' field (only first match, stop at first non-matching line)
  local name_field=$(echo "$frontmatter" | awk '/^name:/{gsub(/^name:[[:space:]]*/, ""); print; exit}')
  if [[ -z "$name_field" ]]; then
    log_error "Skill '$skill_name': Missing required 'name' field"
    return 1
  fi
  
  # Check name matches directory
  if [[ "$name_field" != "$skill_name" ]]; then
    log_error "Skill '$skill_name': Name field '$name_field' doesn't match directory name"
    return 1
  fi
  
  # Check required 'description' field
  local description=$(echo "$frontmatter" | awk '/^description:/{gsub(/^description:[[:space:]]*/, ""); print; exit}')
  if [[ -z "$description" ]]; then
    log_error "Skill '$skill_name': Missing required 'description' field"
    return 1
  fi
  
  # Check description length (rough check)
  local desc_len=${#description}
  if [[ $desc_len -gt 1024 ]]; then
    log_error "Skill '$skill_name': Description exceeds 1024 characters ($desc_len)"
    return 1
  fi
  
  # Validate naming convention
  if ! [[ "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    log_error "Skill '$skill_name': Invalid name format (must be lowercase alphanumeric with single hyphens)"
    return 1
  fi
  
  # Check for consecutive hyphens
  if [[ "$skill_name" == *"--"* ]]; then
    log_error "Skill '$skill_name': Name contains consecutive hyphens"
    return 1
  fi
  
  log_success "Skill '$skill_name' is valid"
  return 0
}

# Validate all skills
validate_skills() {
  log_info "\n=== Validating Skills ==="
  
  local skill_count=0
  
  # Check global skills
  if [[ -d "$GLOBAL_CONFIG/skill" ]]; then
    for skill_dir in "$GLOBAL_CONFIG/skill"/*/; do
      [[ -d "$skill_dir" ]] || continue
      validate_skill "$skill_dir"
      ((skill_count++))
    done
  fi
  
  # Check local skills
  if [[ -d "$LOCAL_CONFIG/skill" ]]; then
    for skill_dir in "$LOCAL_CONFIG/skill"/*/; do
      [[ -d "$skill_dir" ]] || continue
      validate_skill "$skill_dir"
      ((skill_count++))
    done
  fi
  
  if [[ $skill_count -eq 0 ]]; then
    log_info "No skills found"
  fi
}

# Validate a single command file
validate_command() {
  local cmd_file="$1"
  local cmd_name=$(basename "$cmd_file" .md)
  
  # Extract frontmatter
  local frontmatter=$(sed -n '/^---$/,/^---$/p' "$cmd_file" | sed '1d;$d')
  
  # Commands can have just content without frontmatter, but if frontmatter exists, validate it
  if [[ -n "$frontmatter" ]]; then
    # Check for at least template or description
    local has_template=$(echo "$frontmatter" | grep -c "^template:" || echo "0")
    local has_description=$(echo "$frontmatter" | grep -c "^description:" || echo "0")
    
    if [[ "$has_template" -eq 0 && "$has_description" -eq 0 ]]; then
      log_warning "Command '$cmd_name': Has frontmatter but no template or description"
    fi
  fi
  
  # Check content exists after frontmatter
  local content=$(sed '1,/^---$/d' "$cmd_file" | sed '1,/^---$/d')
  if [[ -z "${content// }" ]]; then
    # If no frontmatter, check whole file
    content=$(cat "$cmd_file")
    if [[ "$content" == "---"* ]]; then
      log_warning "Command '$cmd_name': No content after frontmatter"
    fi
  fi
  
  # Validate naming convention
  if ! [[ "$cmd_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    log_warning "Command '$cmd_name': Name should be lowercase alphanumeric"
  fi
  
  log_success "Command '$cmd_name' is valid"
  return 0
}

# Validate all commands
validate_commands() {
  log_info "\n=== Validating Commands ==="
  
  local cmd_count=0
  
  # Check global commands
  if [[ -d "$GLOBAL_CONFIG/command" ]]; then
    for cmd_file in "$GLOBAL_CONFIG/command"/*.md; do
      [[ -f "$cmd_file" ]] || continue
      validate_command "$cmd_file"
      ((cmd_count++))
    done
  fi
  
  # Check local commands
  if [[ -d "$LOCAL_CONFIG/command" ]]; then
    for cmd_file in "$LOCAL_CONFIG/command"/*.md; do
      [[ -f "$cmd_file" ]] || continue
      validate_command "$cmd_file"
      ((cmd_count++))
    done
  fi
  
  if [[ $cmd_count -eq 0 ]]; then
    log_info "No commands found"
  fi
}

# Validate a specific file
validate_file() {
  local file="$1"
  
  if [[ ! -f "$file" ]]; then
    log_error "File not found: $file"
    return 1
  fi
  
  # Determine type from path
  if [[ "$file" == *"/agent/"* ]]; then
    log_info "Validating as agent..."
    # For single agent, we still use opencode agent list (validates all)
    # but we can check if this specific file causes issues
    validate_agents
  elif [[ "$file" == *"/skill/"* ]]; then
    log_info "Validating as skill..."
    local skill_dir=$(dirname "$file")
    validate_skill "$skill_dir"
  elif [[ "$file" == *"/command/"* ]]; then
    log_info "Validating as command..."
    validate_command "$file"
  else
    log_error "Cannot determine config type from path: $file"
    return 1
  fi
}

# Print summary
print_summary() {
  echo ""
  echo "================================"
  if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
    echo -e "${GREEN}All validations passed!${NC}"
  elif [[ $ERRORS -eq 0 ]]; then
    echo -e "${YELLOW}Validation complete with $WARNINGS warning(s)${NC}"
  else
    echo -e "${RED}Validation failed: $ERRORS error(s), $WARNINGS warning(s)${NC}"
  fi
  echo "================================"
  
  return $ERRORS
}

# Main
main() {
  local mode="${1:-all}"
  
  case "$mode" in
    agents)
      validate_agents
      ;;
    skills)
      validate_skills
      ;;
    commands)
      validate_commands
      ;;
    file)
      if [[ -z "${2:-}" ]]; then
        log_error "Usage: validate.sh file <path>"
        exit 1
      fi
      validate_file "$2"
      ;;
    all)
      validate_agents
      validate_skills
      validate_commands
      ;;
    *)
      echo "Usage: validate.sh [agents|skills|commands|file <path>|all]"
      exit 1
      ;;
  esac
  
  print_summary
}

main "$@"
