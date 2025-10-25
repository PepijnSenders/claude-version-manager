---
name: analyze-changes
description: Analyze git repository changes to determine semantic version bump (major/minor/patch). Use when determining what version bump is needed, analyzing commits since last release, or checking for breaking changes.
---

# Analyze Changes

Analyzes git repository to determine the appropriate semantic version bump based on commits and file changes.

## When to use this skill

Use this skill when you need to:
- Determine if version bump should be MAJOR, MINOR, or PATCH
- Understand what changed since the last release
- Check if current package.json version already has a git tag
- Detect uncommitted changes
- Get detailed analysis of commits and file changes

## How it works

This skill will:

1. **Check current state:**
   - Get current version from package.json
   - Find last git tag
   - Check if current version already has a tag (important!)
   - Detect uncommitted changes and warn user

2. **Analyze git history:**
   - List commits since last release (or since current version tag)
   - Show changed files
   - Categorize commits by type (breaking/feature/fix)
   - Count changes in each category

3. **Recommend version bump:**
   - **MAJOR**: Breaking changes detected
   - **MINOR**: New features added
   - **PATCH**: Bug fixes or minor changes
   - Includes confidence level based on commit patterns

## Instructions

Run the analysis by checking:

```bash
# Get current version
CURRENT_VERSION=$(cat package.json | grep '"version"' | head -1 | sed 's/.*"version": "\(.*\)".*/\1/')

# Check if current version has a tag
CURRENT_TAG="v$CURRENT_VERSION"
if git rev-parse "$CURRENT_TAG" >/dev/null 2>&1; then
  echo "Current version $CURRENT_VERSION already has tag $CURRENT_TAG"
  COMPARISON_BASE="$CURRENT_TAG"
else
  COMPARISON_BASE=$(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
  echo "⚠️ Warning: Uncommitted changes detected"
  git status --short
fi

# Get commits since comparison base
git log $COMPARISON_BASE..HEAD --oneline

# Analyze commit patterns
BREAKING=$(git log $COMPARISON_BASE..HEAD --grep="BREAKING\|!" --extended-regexp -i | wc -l)
FEATURES=$(git log $COMPARISON_BASE..HEAD --grep="^feat\|^feature" --extended-regexp -i | wc -l)
FIXES=$(git log $COMPARISON_BASE..HEAD --grep="^fix\|^bug" --extended-regexp -i | wc -l)

# Recommend bump type
if [ "$BREAKING" -gt 0 ]; then
  echo "Recommend: MAJOR"
elif [ "$FEATURES" -gt 0 ]; then
  echo "Recommend: MINOR"
else
  echo "Recommend: PATCH"
fi
```

## Output format

The skill provides:
- Current version and comparison base
- Warning if uncommitted changes exist
- List of commits since last release
- Changed files
- Count of breaking changes, features, and fixes
- Recommended bump type (MAJOR/MINOR/PATCH)
- New version number
- Confidence level

## Tips for better analysis

- Use conventional commit messages (feat:, fix:, etc.)
- Include "BREAKING" in commit messages for breaking changes
- Write descriptive commit messages explaining what changed
- Commit pending changes before running version bump
