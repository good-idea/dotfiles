#!/bin/bash
# fetch-aa-models: Fetches LLM model data from Artificial Analysis API
# 
# Looks for ARTIFICIAL_ANALYSIS_API_KEY in:
# 1. Environment variable (if already set)
# 2. .env file in current directory or any parent directory
#
# Usage: ~/.opencode/skill/fetch-aa-models/scripts/fetch.sh

set -euo pipefail

# Function to find .env file by walking up directory tree
find_env_file() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.env" ]]; then
      echo "$dir/.env"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  
  # Also check home directory
  if [[ -f "$HOME/.env" ]]; then
    echo "$HOME/.env"
    return 0
  fi
  
  return 1
}

# Function to extract value from .env file
get_env_value() {
  local file="$1"
  local key="$2"
  
  # Parse .env file, handling quotes and comments
  grep -E "^${key}=" "$file" 2>/dev/null | head -1 | sed -E 's/^[^=]+=//; s/^["'"'"']//; s/["'"'"']$//'
}

# Try to get API key
API_KEY="${ARTIFICIAL_ANALYSIS_API_KEY:-}"

if [[ -z "$API_KEY" ]]; then
  ENV_FILE=$(find_env_file) || true
  
  if [[ -n "$ENV_FILE" ]]; then
    API_KEY=$(get_env_value "$ENV_FILE" "ARTIFICIAL_ANALYSIS_API_KEY")
  fi
fi

# If still no key, exit with helpful message
if [[ -z "$API_KEY" ]]; then
  cat <<EOF
{
  "error": "ARTIFICIAL_ANALYSIS_API_KEY not found",
  "searched": [
    "Environment variable ARTIFICIAL_ANALYSIS_API_KEY",
    ".env file in current or parent directories",
    "~/.env"
  ],
  "setup": "Add ARTIFICIAL_ANALYSIS_API_KEY=your_key to a .env file or export it"
}
EOF
  exit 1
fi

# Fetch the data
curl -s -X GET "https://artificialanalysis.ai/api/v2/data/llms/models" \
  -H "x-api-key: $API_KEY"
