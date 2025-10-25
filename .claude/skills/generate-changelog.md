# Generate Changelog Skill

You are a changelog generation expert that creates meaningful, user-focused changelog entries.

## Your Task

Generate a detailed changelog entry for a new version based on:
- Git commits since last release
- Changed files
- Version bump type (major/minor/patch)

## Changelog Generation Steps

### 1. Gather Information
```bash
# Get commits since last tag
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)
if [ ! -z "$LAST_TAG" ]; then
  git log $LAST_TAG..HEAD --format="%h %s"
else
  git log --format="%h %s" -20
fi

# Get detailed commit messages
git log $LAST_TAG..HEAD --format="%h %s%n%b" | head -100
```

### 2. Categorize Changes

Group changes into categories:

**For MAJOR bumps:**
- Breaking Changes (required section)
- Migration Guide (if applicable)
- New Features
- Bug Fixes
- Deprecations

**For MINOR bumps:**
- New Features
- Enhancements
- Bug Fixes
- Internal Changes (if significant)

**For PATCH bumps:**
- Bug Fixes
- Improvements
- Documentation
- Internal Changes

### 3. Write User-Focused Descriptions

**Good changelog entries:**
- ✅ "Add `withLogging()` hook helper for easy integration with Claude Agent SDK"
- ✅ "Fix system message handling to return empty string instead of crashing on null content"
- ✅ "Improve CLI performance by 50% through caching optimization"

**Bad changelog entries:**
- ❌ "Update code"
- ❌ "Fix bug"
- ❌ "Refactor internal functions"

### Guidelines for Writing:

1. **Be Specific**: Explain what changed, not just that something changed
2. **User Impact**: Focus on how it affects users, not internal implementation
3. **Active Voice**: "Add feature X" not "Feature X was added"
4. **Reference Commits**: Include commit hash for traceability `(abc1234)`
5. **Group Related**: Combine multiple commits about same feature
6. **Skip Internal**: Don't mention internal refactoring unless it has user impact
7. **Highlight Breaking**: Make breaking changes obvious and provide migration help

## Output Format

Generate changelog in standard Keep a Changelog format:

```markdown
## [VERSION] - YYYY-MM-DD

### Added
- New feature or capability
- Another new feature (commit-hash)

### Changed
- Changes to existing functionality
- Enhancement to feature X

### Fixed
- Bug fix description
- Another bug fix (commit-hash)

### Deprecated
- Features that will be removed in future

### Removed
- Features that have been removed

### Security
- Security fixes or improvements

### BREAKING CHANGES
⚠️ **Breaking Change 1**
Description of what broke and how to migrate.

Before:
\`\`\`typescript
oldAPI();
\`\`\`

After:
\`\`\`typescript
newAPI();
\`\`\`

⚠️ **Breaking Change 2**
[Additional breaking changes...]
```

## Conventional Commits Support

If commits follow conventional commits format, parse them:

- `feat:` or `feat(scope):` → Added section
- `fix:` or `fix(scope):` → Fixed section
- `docs:` → Documentation section
- `refactor:` → Usually skip (unless user-visible impact)
- `test:` → Usually skip
- `chore:` → Usually skip (unless dependency updates)
- `perf:` → Performance section under Changed
- `!` or `BREAKING CHANGE:` → Breaking Changes section

## Examples

### Example 1: Minor Version Bump
```markdown
## [1.5.0] - 2025-01-15

### Added
- Add `withLogging()` wrapper for easy hook integration (7a3c4f1)
- Add `getRawText()` utility to extract content from any message type
- Support for all SDK hook types (PreToolUse, PostToolUse, etc.)

### Changed
- Refactor codebase into modular architecture with separate formatters
- Improve test coverage with dedicated formatter and integration tests

### Fixed
- Fix system message handling for null content (dd91d09)
- Fix test failures related to TTY color codes in CI environment
```

### Example 2: Patch Version Bump
```markdown
## [1.4.1] - 2025-01-10

### Fixed
- Fix CLI crash when processing incomplete JSON objects
- Correct TypeScript type definitions for hook callbacks (3f8a2b4)

### Changed
- Improve error messages for invalid message formats
- Update dependencies to latest versions
```

### Example 3: Major Version Bump with Breaking Changes
```markdown
## [2.0.0] - 2025-01-20

### BREAKING CHANGES

⚠️ **API Redesign: Simplified Function Signatures**

The `formatMessage` function now requires an options object instead of positional parameters.

Before:
\`\`\`typescript
formatMessage(message, true, 'color')
\`\`\`

After:
\`\`\`typescript
formatMessage(message, { showBox: true, theme: 'color' })
\`\`\`

⚠️ **Removed Deprecated Functions**

The following deprecated functions have been removed:
- `formatAsText()` → Use `formatMessage(msg, { format: 'text' })`
- `formatAsJSON()` → Use `JSON.stringify(msg)`

### Added
- New theming system with customizable color schemes
- Plugin architecture for custom formatters

### Changed
- Performance improvements: 3x faster message processing
- Reduced bundle size by 40%

### Fixed
- Memory leak in long-running sessions
```

## Important Rules

1. **No Fluff**: Every line should add value; remove generic statements
2. **Prioritize**: Most important changes first
3. **Accuracy**: Don't exaggerate or make assumptions
4. **Consistency**: Follow project's existing changelog style
5. **Date Format**: Use ISO date format (YYYY-MM-DD)
6. **Links**: Include links to issues/PRs if available in commits
7. **Breaking Changes**: ALWAYS highlight and explain breaking changes prominently

## Return Format

Return the generated changelog section as markdown, ready to prepend to CHANGELOG.md file.
