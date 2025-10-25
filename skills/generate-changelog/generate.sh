#!/bin/bash
set -e

# Generate changelog entry from git history

# Get version from argument or determine automatically
NEW_VERSION="${1:-}"
if [ -z "$NEW_VERSION" ]; then
  CURRENT_VERSION=$(cat package.json 2>/dev/null | grep '"version"' | head -1 | sed 's/.*"version": "\(.*\)".*/\1/' || echo "1.0.0")
  NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print $1"."$2"."($3+1)}')
fi

# Get last tag or fallback to first commit
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || git rev-list --max-parents=0 HEAD)

# Check if current version already has a tag
CURRENT_VERSION=$(cat package.json 2>/dev/null | grep '"version"' | head -1 | sed 's/.*"version": "\(.*\)".*/\1/')
CURRENT_TAG="v$CURRENT_VERSION"
if git rev-parse "$CURRENT_TAG" >/dev/null 2>&1; then
  LAST_TAG="$CURRENT_TAG"
fi

DATE=$(date +%Y-%m-%d)

echo "## [$NEW_VERSION] - $DATE"
echo ""

# Collect changes by category
ADDED_CHANGES=()
CHANGED_CHANGES=()
FIXED_CHANGES=()
BREAKING_CHANGES=()

# Parse commits
while IFS= read -r commit; do
  HASH=$(echo "$commit" | awk '{print $1}')
  MSG=$(echo "$commit" | cut -d' ' -f2-)

  # Categorize based on conventional commits or keywords
  if echo "$MSG" | grep -qiE '^feat|^feature|^add'; then
    ADDED_CHANGES+=("$MSG ($HASH)")
  elif echo "$MSG" | grep -qiE '^fix|^bug'; then
    FIXED_CHANGES+=("$MSG ($HASH)")
  elif echo "$MSG" | grep -qiE 'BREAKING|breaking change'; then
    BREAKING_CHANGES+=("$MSG ($HASH)")
  elif echo "$MSG" | grep -qiE '^refactor|^improve|^enhance|^update'; then
    CHANGED_CHANGES+=("$MSG ($HASH)")
  else
    # Default to Changed for other commits
    CHANGED_CHANGES+=("$MSG ($HASH)")
  fi
done < <(git log $LAST_TAG..HEAD --oneline --no-decorate)

# Print Breaking Changes first (if any)
if [ ${#BREAKING_CHANGES[@]} -gt 0 ]; then
  echo "### ⚠️  BREAKING CHANGES"
  echo ""
  for change in "${BREAKING_CHANGES[@]}"; do
    # Clean up the commit message
    clean_msg=$(echo "$change" | sed -E 's/^(BREAKING|breaking)://i' | sed 's/^ *//')
    echo "- $clean_msg"
  done
  echo ""
fi

# Print Added section
if [ ${#ADDED_CHANGES[@]} -gt 0 ]; then
  echo "### Added"
  echo ""
  for change in "${ADDED_CHANGES[@]}"; do
    # Clean up conventional commit prefixes
    clean_msg=$(echo "$change" | sed -E 's/^(feat|feature|add)://i' | sed 's/^ *//')
    echo "- $clean_msg"
  done
  echo ""
fi

# Print Changed section
if [ ${#CHANGED_CHANGES[@]} -gt 0 ]; then
  echo "### Changed"
  echo ""
  for change in "${CHANGED_CHANGES[@]}"; do
    # Clean up conventional commit prefixes
    clean_msg=$(echo "$change" | sed -E 's/^(refactor|improve|enhance|update|change)://i' | sed 's/^ *//')
    echo "- $clean_msg"
  done
  echo ""
fi

# Print Fixed section
if [ ${#FIXED_CHANGES[@]} -gt 0 ]; then
  echo "### Fixed"
  echo ""
  for change in "${FIXED_CHANGES[@]}"; do
    # Clean up conventional commit prefixes
    clean_msg=$(echo "$change" | sed -E 's/^(fix|bug|bugfix)://i' | sed 's/^ *//')
    echo "- $clean_msg"
  done
  echo ""
fi

# If no categorized changes, show a generic entry
if [ ${#ADDED_CHANGES[@]} -eq 0 ] && [ ${#CHANGED_CHANGES[@]} -eq 0 ] && [ ${#FIXED_CHANGES[@]} -eq 0 ] && [ ${#BREAKING_CHANGES[@]} -eq 0 ]; then
  echo "### Changed"
  echo ""
  echo "- Minor updates and improvements"
  echo ""
fi
