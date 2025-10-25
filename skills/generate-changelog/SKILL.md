---
name: generate-changelog
description: Generate meaningful changelog entries from git history in Keep a Changelog format. Use when creating changelog entries, writing release notes, or documenting version changes.
---

# Generate Changelog

Generates detailed, user-focused changelog entries from git commit history following the Keep a Changelog standard.

## When to use this skill

Use this skill when you need to:
- Create changelog entries for a new version
- Document what changed in a release
- Generate release notes from commits
- Format changes in Keep a Changelog style

## How it works

This skill will:

1. **Gather git history:**
   - Get commits since last release (or since current version tag)
   - Parse commit messages for conventional commit patterns
   - Identify commit hashes for traceability

2. **Categorize changes:**
   - **Breaking Changes**: BREAKING, breaking change
   - **Added**: feat:, feature:, add:
   - **Changed**: refactor:, improve:, enhance:, update:
   - **Fixed**: fix:, bug:, bugfix:

3. **Generate formatted output:**
   - Keep a Changelog markdown format
   - Date in ISO format (YYYY-MM-DD)
   - Sections: Breaking Changes, Added, Changed, Fixed
   - Include commit hashes for reference
   - Clean up conventional commit prefixes

## Instructions

You can run the changelog generator script:

```bash
# Generate for current version + 1 patch
bash generate.sh

# Or specify version explicitly
bash generate.sh 2.0.0
```

The script [generate.sh](generate.sh) handles all the formatting automatically.

## Output format

Generates Keep a Changelog format:

```markdown
## [VERSION] - YYYY-MM-DD

### ⚠️ BREAKING CHANGES
- Description of breaking change (commit-hash)

### Added
- New feature description (commit-hash)
- Another feature (commit-hash)

### Changed
- Enhancement description (commit-hash)
- Refactoring details (commit-hash)

### Fixed
- Bug fix description (commit-hash)
- Another fix (commit-hash)
```

## Best practices for output

**Good changelog entries:**
- ✅ "Add withLogging() hook helper for easy integration" (abc123)
- ✅ "Fix system message handling for null content" (def456)
- ✅ "Refactor codebase into modular architecture" (ghi789)

**What the skill does:**
- Removes conventional commit prefixes (feat:, fix:)
- Includes commit hash for traceability
- Groups by category
- Prioritizes breaking changes

## Tips for better changelogs

- Write descriptive commit messages
- Use conventional commits when possible
- Explain what changed and why, not how
- Focus on user-visible changes
- Include context in commit messages
