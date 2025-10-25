#!/bin/bash
set -e

# Analyze git repository and determine semantic version bump

echo "## Version Bump Analysis"
echo ""

# Get current version from package.json
CURRENT_VERSION=$(cat package.json 2>/dev/null | grep '"version"' | head -1 | sed 's/.*"version": "\(.*\)".*/\1/' || echo "unknown")
echo "**Current Version:** $CURRENT_VERSION"

# Get last version tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [ -z "$LAST_TAG" ]; then
  echo "**Last Tag:** No tags found"
  echo "**Commits Since Last Release:** All commits (first release)"
  COMPARISON_BASE="$(git rev-list --max-parents=0 HEAD)"
else
  echo "**Last Tag:** $LAST_TAG"
  COMMIT_COUNT=$(git rev-list $LAST_TAG..HEAD --count)
  echo "**Commits Since Last Release:** $COMMIT_COUNT commits"
  COMPARISON_BASE="$LAST_TAG"
fi

echo ""

# Check if current version has a tag
CURRENT_TAG="v$CURRENT_VERSION"
if git rev-parse "$CURRENT_TAG" >/dev/null 2>&1; then
  echo "**Note:** Current package.json version ($CURRENT_VERSION) already has a git tag ($CURRENT_TAG)"
  echo "**Comparing from:** $CURRENT_TAG to HEAD"
  COMPARISON_BASE="$CURRENT_TAG"
  COMMIT_COUNT=$(git rev-list $CURRENT_TAG..HEAD --count)
  echo "**Commits since $CURRENT_TAG:** $COMMIT_COUNT commits"
  echo ""
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
  echo "⚠️  **Warning: Uncommitted changes detected**"
  echo ""
  echo "You have unstaged or uncommitted changes:"
  git status --short | head -10
  echo ""
  echo "Consider committing these changes before bumping the version."
  echo ""
fi

# Get commits since comparison base
echo "### Recent Commits:"
echo '```'
git log $COMPARISON_BASE..HEAD --oneline --no-decorate | head -20
echo '```'
echo ""

# Get changed files
echo "### Changed Files:"
echo '```'
git diff --name-status $COMPARISON_BASE..HEAD | head -30
echo '```'
echo ""

# Analyze for breaking changes
echo "### Change Analysis:"
echo ""

BREAKING_COUNT=$(git log $COMPARISON_BASE..HEAD --oneline --grep="BREAKING\|breaking change\|!" --extended-regexp | wc -l | tr -d ' ')
FEAT_COUNT=$(git log $COMPARISON_BASE..HEAD --oneline --grep="^feat\|^feature\|^add" --extended-regexp -i | wc -l | tr -d ' ')
FIX_COUNT=$(git log $COMPARISON_BASE..HEAD --oneline --grep="^fix\|^bug" --extended-regexp -i | wc -l | tr -d ' ')

echo "**Breaking Changes Found:** $BREAKING_COUNT"
if [ "$BREAKING_COUNT" -gt 0 ]; then
  git log $COMPARISON_BASE..HEAD --oneline --grep="BREAKING\|breaking change\|!" --extended-regexp | head -5 | sed 's/^/- /'
  echo ""
fi

echo "**New Features Found:** $FEAT_COUNT"
if [ "$FEAT_COUNT" -gt 0 ]; then
  git log $COMPARISON_BASE..HEAD --oneline --grep="^feat\|^feature\|^add" --extended-regexp -i | head -5 | sed 's/^/- /'
  echo ""
fi

echo "**Bug Fixes Found:** $FIX_COUNT"
if [ "$FIX_COUNT" -gt 0 ]; then
  git log $COMPARISON_BASE..HEAD --oneline --grep="^fix\|^bug" --extended-regexp -i | head -5 | sed 's/^/- /'
  echo ""
fi

# Determine recommended bump
echo "### Recommended Bump:"
echo ""

if [ "$BREAKING_COUNT" -gt 0 ]; then
  echo "**MAJOR** - Breaking changes detected"
  NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print ($1+1)".0.0"}')
elif [ "$FEAT_COUNT" -gt 0 ]; then
  echo "**MINOR** - New features added"
  NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print $1"."($2+1)".0"}')
elif [ "$FIX_COUNT" -gt 0 ] || [ "$COMMIT_COUNT" -gt 0 ]; then
  echo "**PATCH** - Bug fixes or minor changes"
  NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print $1"."$2"."($3+1)}')
else
  echo "**PATCH** - Default (no significant changes detected)"
  NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{print $1"."$2"."($3+1)}')
fi

echo "**New Version:** $NEW_VERSION"
echo ""

echo "### Confidence Level:"
if [ "$BREAKING_COUNT" -gt 0 ] || [ "$FEAT_COUNT" -gt 0 ]; then
  echo "**High** - Clear indicators found in commit messages"
elif [ "$FIX_COUNT" -gt 0 ]; then
  echo "**Medium** - Bug fixes detected"
else
  echo "**Low** - No conventional commit patterns found, defaulting to PATCH"
  echo ""
  echo "💡 *Tip: Use conventional commit messages (feat:, fix:, etc.) for better analysis*"
fi
