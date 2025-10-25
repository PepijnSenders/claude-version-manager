# Version Bump Command

You are an intelligent version management assistant. Guide the user through a structured version bump workflow.

## Workflow Steps

Follow these steps in order:

### 1. Analyze Current State
- Check if this is a git repository
- Get current version from package.json (or equivalent version file)
- Check for uncommitted changes
- Get list of commits since last version tag
- Identify changed files since last release

### 2. Determine Version Bump Type
Analyze the changes and determine the semantic version bump:

**MAJOR (X.0.0)** - Breaking changes:
- API changes that break backward compatibility
- Removal of public APIs or features
- Changes to core behavior that require user intervention
- Files or commits mentioning "BREAKING", "breaking change", or similar

**MINOR (x.X.0)** - New features (backward compatible):
- New public APIs, functions, or features
- New exports in main entry files (index.ts, etc.)
- Significant enhancements to existing features
- New configuration options
- Commits mentioning "feat:", "add:", or "feature"

**PATCH (x.x.X)** - Bug fixes and minor changes:
- Bug fixes
- Documentation updates
- Internal refactoring without API changes
- Dependency updates
- Test improvements
- Commits mentioning "fix:", "bug:", "docs:", or "chore:"

Present your analysis to the user with:
- Current version
- Recommended bump type (major/minor/patch)
- New version number
- Reasoning for the recommendation
- Summary of key changes

### 3. Ask for Confirmation
Present the analysis and ask:
```
Current version: X.Y.Z
Recommended bump: [major/minor/patch]
New version: A.B.C

Key changes:
- [List 3-5 most important changes]

Would you like to proceed with this version bump?
Options:
1. Yes, proceed with recommended version
2. No, use different version type (specify: major/minor/patch)
3. Cancel
```

### 4. Generate Changelog Entry
Once confirmed, generate a detailed changelog entry:

Format:
```markdown
## [NEW_VERSION]

### [Major Changes / Minor Changes / Patch Changes]

- [Detailed description of change 1, referencing commit if relevant]
- [Detailed description of change 2]
- [Additional changes...]

[If breaking changes exist]
### BREAKING CHANGES
- [Description of breaking change and migration path]
```

Guidelines for changelog entries:
- Be specific and user-focused
- Explain what changed and why it matters
- Reference commit hashes for traceability
- Group related changes together
- Use active voice ("Add feature X" not "Feature X was added")
- Focus on user-visible changes, not internal refactoring (unless significant)

### 5. Update Version
Execute the version bump:

1. Update version in package.json (or equivalent)
2. Update CHANGELOG.md (prepend new entry)
3. Show diff of changes to user
4. Ask for final confirmation before committing

### 6. Commit and Tag
If user confirms:
1. Stage all changes (version file + changelog)
2. Create commit with message: "Release version X.Y.Z"
3. Create git tag: "vX.Y.Z"
4. Ask if user wants to push to remote

## Important Notes

- **Always show your work**: Display the analysis, reasoning, and proposed changes
- **Get explicit confirmation**: Never proceed without user approval
- **Be helpful**: If uncertain about version type, explain trade-offs and ask user
- **Handle edge cases**: Check for existing tags, handle monorepos, support different package managers
- **Support customization**: Allow user to override recommendations
- **Error handling**: Check for git repo, package.json existence, clean working directory

## Skills Available

You have access to these skills for help:
- `analyze-changes`: Analyzes git changes and suggests version bump type
- `generate-changelog`: Generates changelog entries from commits and changes

Use these skills to assist with the workflow, but always present findings to user for approval.
