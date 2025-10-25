# Claude Version Manager

> Intelligent version management plugin for Claude Code with semantic versioning, changelog generation, and automated workflows.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Features

🎯 **Intelligent Version Analysis** - Automatically analyzes git history to recommend semantic version bumps
📝 **Smart Changelog Generation** - Creates meaningful, user-focused changelog entries from commits
🔄 **Interactive Workflow** - Step-by-step guidance with confirmation at each stage
✨ **Best Practices** - Follows semantic versioning and Keep a Changelog conventions
🚀 **Zero Configuration** - Works out of the box with any npm/Node.js project

## Installation

### As a Claude Code Plugin

1. Clone this repository to your Claude Code plugins directory:

```bash
# Via Claude Code plugins directory
cd ~/.config/claude-code/plugins  # or appropriate config directory
git clone https://github.com/PepijnSenders/claude-version-manager.git

# Or clone anywhere and symlink
git clone https://github.com/PepijnSenders/claude-version-manager.git ~/plugins/claude-version-manager
ln -s ~/plugins/claude-version-manager ~/.config/claude-code/plugins/version-manager
```

2. Restart Claude Code or reload plugins

3. The `/bump` command will now be available in any project

### Manual Installation (Copy .claude directory)

Alternatively, copy the `.claude` directory to your project:

```bash
cp -r claude-version-manager/.claude /path/to/your/project/
```

## Usage

### Quick Start

In any project with a git repository and package.json:

```bash
/bump
```

This launches an interactive workflow that:

1. **Analyzes your changes** - Reviews commits, file changes, and determines version bump type
2. **Recommends a version** - Suggests major/minor/patch based on semantic versioning rules
3. **Generates changelog** - Creates detailed, user-focused changelog entries
4. **Updates files** - Modifies package.json and CHANGELOG.md
5. **Creates git tag** - Commits changes and tags the new version
6. **Optionally pushes** - Can push to remote with tags

### Example Workflow

```
$ /bump

🔍 Analyzing current repository state...

Current version: 1.4.0
Last release: v1.4.0
Commits since last release: 7 commits
Files changed: 12 files

📊 Recommended Version Bump: MINOR

New version: 1.5.0

Reasoning:
- Added new hook helpers API (withLogging, createLoggingHooks)
- Added getRawText() utility function
- Refactored codebase with modular architecture
- No breaking changes detected

Key changes:
1. Add hook helpers API for easy integration
2. Add getRawText() utility for content extraction
3. Refactor to modular architecture
4. Fix system message null handling
5. Expand test coverage significantly

Would you like to proceed with version 1.5.0? (yes/no/different)
> yes

✅ Generating changelog entry...

## [1.5.0] - 2025-01-15

### Added
- Add hook helpers API with withLogging() for easy integration
- Add getRawText() utility to extract content from any message type
- Support for all SDK hook types

### Changed
- Refactor codebase into modular architecture
- Improve test coverage with dedicated formatter tests

### Fixed
- Fix system message handling for null content

Would you like to commit these changes? (yes/no)
> yes

✅ Version bumped to 1.5.0
✅ CHANGELOG.md updated
✅ Changes committed and tagged as v1.5.0

Push to remote? (yes/no)
> yes

✅ Pushed to origin with tags
```

## How It Works

### 1. Semantic Version Analysis

The plugin analyzes your changes using multiple signals:

**MAJOR (Breaking Changes)**
- Commits mentioning "BREAKING", "breaking change"
- Removal of public APIs
- Changes to core behavior requiring user intervention

**MINOR (New Features)**
- New exports in main files
- Commits with "feat:", "feature:", "add:"
- Backward-compatible enhancements

**PATCH (Bug Fixes)**
- Commits with "fix:", "bug:", "bugfix:"
- Documentation updates
- Internal refactoring
- Dependency updates

### 2. Changelog Generation

Creates meaningful entries by:

- Parsing conventional commit messages
- Analyzing file changes (new files, modified APIs)
- Grouping related changes
- Writing user-focused descriptions
- Including commit hashes for traceability
- Highlighting breaking changes with migration examples

### 3. Best Practices

Follows industry standards:

- [Semantic Versioning 2.0.0](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Conventional Commits](https://www.conventionalcommits.org/) (when present)

## Commands

### `/bump`

Interactive version bump workflow.

**Usage:**
```bash
/bump
```

**Options:**
- No options needed - fully interactive
- The workflow prompts for all decisions

## Skills

The plugin includes two powerful skills you can use independently:

### `analyze-changes`

Analyzes git repository to determine appropriate version bump.

**Usage:**
```
analyze-changes
```

**Output:**
- Recommended version bump type
- Reasoning for recommendation
- List of key changes
- Confidence level

### `generate-changelog`

Generates changelog entry for a version.

**Usage:**
```
generate-changelog
```

**Output:**
- Formatted changelog section
- Categorized changes (Added/Changed/Fixed/etc.)
- User-focused descriptions

## Configuration

### Default Behavior

Works with zero configuration for npm/Node.js projects with:
- `package.json` with version field
- Git repository with tags (optional)
- `CHANGELOG.md` file (created if missing)

### Customization

You can customize behavior by modifying the `.claude/commands/bump.md` file:

- Change version bump heuristics
- Modify changelog format
- Add custom commit message templates
- Integrate with additional tools

## Requirements

- Git repository
- `package.json` (or equivalent version file)
- Git tags following `vX.Y.Z` format (optional, but recommended)

## Examples

### First Release (No Tags)

```bash
$ /bump
No previous tags found. This appears to be the first release.
Current version in package.json: 0.1.0

Recommended: MINOR (1.0.0 - first stable release)
Would you like to proceed?
```

### Monorepo Support

The plugin can work with monorepos by running it in each package directory:

```bash
cd packages/my-package
/bump
```

### Pre-release Versions

For alpha/beta/rc versions, you can override the recommendation:

```bash
$ /bump
Recommended: MINOR (1.5.0)

Would you like to proceed with version 1.5.0? (yes/no/different)
> different

Please specify version: 1.5.0-beta.1
```

## Comparison with Other Tools

| Feature | Version Manager | Changesets | Semantic Release |
|---------|----------------|------------|------------------|
| Interactive workflow | ✅ | ✅ | ❌ |
| AI-powered analysis | ✅ | ❌ | ❌ |
| Meaningful changelogs | ✅ | ⚠️ Manual | ⚠️ Auto-generated |
| Works in Claude Code | ✅ | ❌ | ❌ |
| Zero config | ✅ | ❌ | ❌ |
| Monorepo support | ⚠️ Per-package | ✅ | ✅ |

## Troubleshooting

### "No package.json found"

Make sure you're in a Node.js project with a package.json file.

### "Not a git repository"

Initialize git: `git init` and make at least one commit.

### Changelog entries are too generic

The AI analyzes commit messages and file changes. For best results:
- Write descriptive commit messages
- Use conventional commits format when possible
- Provide context in commit messages about what changed and why

### Version recommendation seems wrong

You can always override the recommendation. The AI provides suggestions based on analysis, but you have final say.

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `/bump` in a real project
5. Submit a pull request

## License

MIT © Pepijn Senders

## Related

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## Credits

Built with ❤️ using Claude Code's plugin system.
