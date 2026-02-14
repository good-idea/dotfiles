---
name: create-skill-scripts
description: Guides the creation of scripts for OpenCode skills with best practices for co-location, environment handling, project root detection, and security
---

# Create Skill Scripts

## Overview

This skill guides the creation of scripts that accompany OpenCode skills. Scripts should be co-located with their skill definitions, discover resources dynamically, and follow security best practices.

**Core principle:** Scripts must be portable, self-contained, and never make assumptions about directory structure depth.

**Announce at start:** "I'm using the create-skill-scripts skill to build a well-structured script for this skill."

## When to Use

Load this skill when:

- Creating a new skill that needs an accompanying script
- Refactoring an existing skill's script to follow best practices
- Reviewing a script for portability and security issues
- Converting inline bash commands to a dedicated script

## Co-location

Scripts must live in the `scripts/` subdirectory within their skill folder, not in a global scripts directory.

**Correct structure:**
```
skill/
  my-skill/
    SKILL.md          # Skill definition
    scripts/          # Scripts subdirectory
      run.sh          # Co-located script (or any executable)
```

**Why co-location matters:**
- Skills are portable - moving or sharing the skill directory includes its scripts
- Version control is unified - script changes are tracked with skill changes
- Discovery is automatic - scripts are where the skill definition expects them
- No path assumptions - scripts can reference resources relative to their location
- Scripts are organized separately from documentation in the skill directory

## Environment Handling

Scripts must **never** expect environment variables to be passed from the sub-agent. Instead, implement a find-up function to locate `.env` files.

**Required pattern:**

1. Implement a `find_up_env()` function that walks up the directory tree
2. Start from the current working directory (`$PWD` or the script's invocation context)
3. Search for `.env` files in each directory until reaching the root
4. Parse the `.env` file to extract required variables

**Why this matters:**
- Sub-agents run in isolated contexts with sanitized environments
- Environment variables set in the parent process aren't guaranteed to be inherited
- Users can place `.env` files at project root, workspace root, or home directory
- Scripts remain functional regardless of how they're invoked

## Project Root Detection

Scripts must **never** hard-code the number of directory levels to traverse (e.g., `cd ../../..`). Instead, detect the project root dynamically.

**Primary method:** Use git to find the project root:
```bash
git rev-parse --show-toplevel
```

**Fallback method:** If git isn't available or the directory isn't versioned, implement a `find_up()` function that searches for project markers (`.git`, `package.json`, `pyproject.toml`, etc.) by walking up the directory tree.

**Why this matters:**
- Directory nesting levels change as projects evolve
- Skills may be used in different project structures
- Scripts must work in monorepos, subdirectories, and varying workspace layouts
- Hard-coded levels create brittle, breaking assumptions

## Security Practices

**Input validation:**
- Sanitize all user input before using it in commands
- Quote variables to prevent word splitting
- Use `--` to separate options from arguments where supported
- Validate file paths before reading/writing

**Secrets handling:**
- Never echo or log secrets or API keys
- Use environment variables for sensitive data, not command-line arguments
- Clear sensitive variables from memory when no longer needed
- Avoid including secrets in error messages or debug output

**Command execution:**
- Avoid `eval` with user-controlled data
- Prefer explicit command invocations over string interpolation
- Use `set -euo pipefail` (bash) or equivalent to fail fast on errors
- Validate exit codes and handle failures gracefully

**File operations:**
- Check permissions before reading sensitive files
- Don't create world-writable files
- Clean up temporary files, even on error (use traps)
- Validate that paths are within expected boundaries

## Script Design

**Self-containment:**
- Scripts should have no external dependencies beyond standard system tools
- If dependencies are required, check for them early and provide clear error messages
- Document dependencies in the skill's SKILL.md

**Error handling:**
- Exit with non-zero status on failure
- Provide meaningful error messages to stderr
- Include context about what failed and why

**Portability:**
- Use POSIX-compliant syntax when possible for broader compatibility
- Test on different shells if writing shell scripts
- Document which interpreters are supported (bash, zsh, dash, etc.)

## When NOT to Create a Script

Not every skill needs a separate script. Consider inline bash in the skill instructions when:

- The logic is a single command or simple pipeline
- No environment detection is needed
- The operation is standard tooling (git, npm, docker, etc.)
- The skill instructions are clearer with inline examples

Use a dedicated script when:

- Complex logic is needed (conditionals, loops, error handling)
- Environment or project root detection is required
- The operation needs to be reusable across multiple skill contexts
- Testing and versioning the logic separately is beneficial

## Integration with Skills

**From SKILL.md:**

Reference the script using a path relative to the skill directory. Since skills are installed to `~/.opencode/skill/<name>/`, reference scripts in the `scripts/` subdirectory:

```markdown
## Usage

Run the co-located script:

```bash
~/.opencode/skill/my-skill/scripts/run.sh
```
```

**Testing the script:**

1. Ensure the script is executable: `chmod +x scripts/run.sh`
2. Test from different working directories (project root, subdirectories)
3. Test without expected env vars to verify error handling
4. Test in a fresh shell without inherited environment variables

## Common Patterns

**Finding .env files:**

Scripts often need to load configuration from `.env` files. Walk up the directory tree starting from the invocation context to find them.

**Finding project root:**

Use `git rev-parse --show-toplevel` when in a git repository. This returns the absolute path to the repository root, which works regardless of the current working directory depth.

**Handling missing resources:**

When a required `.env` file or project marker isn't found:
- Exit with a non-zero status
- Print a helpful message to stderr explaining what was searched for
- Suggest how the user can provide the missing resource

**Parsing .env files:**

Env files may contain:
- Simple assignments: `KEY=value`
- Quoted values: `KEY="value"` or `KEY='value'`
- Comments: `# this is a comment`
- Empty lines

Write a parser that handles these cases, or use a robust approach like sourcing the file in a subshell with appropriate safeguards.

## Summary

Good skill scripts are:
- **Co-located** with their skill definition
- **Self-contained** with no external utility dependencies
- **Portable** using find-up patterns instead of hard-coded paths
- **Secure** with proper input validation and secrets handling
- **Resilient** with clear error messages and proper exit codes

When creating a script, always ask: "Would this work if the skill was moved to a different directory structure?" If the answer is no, use find-up patterns.
