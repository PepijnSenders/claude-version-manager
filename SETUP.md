# Setup Guide

Quick setup instructions for using Claude Version Manager in your projects.

## Installation Options

### Option 1: Global Plugin (Recommended)

Install once, use everywhere:

```bash
# Clone to Claude Code plugins directory
mkdir -p ~/.config/claude-code/plugins
cd ~/.config/claude-code/plugins
git clone https://github.com/PepijnSenders/claude-version-manager.git

# Or symlink if you cloned elsewhere
ln -s ~/Documents/GitHub/claude-version-manager ~/.config/claude-code/plugins/version-manager
```

Restart Claude Code, and `/bump` will be available in all projects.

### Option 2: Per-Project Installation

Copy `.claude` directory to your project:

```bash
# From this repository
cp -r /path/to/claude-version-manager/.claude /your/project/

# Now /bump works in that project only
```

### Option 3: Development/Testing

For testing or contributing to this plugin:

```bash
# Symlink this repo to plugins directory
ln -s ~/Documents/GitHub/claude-version-manager ~/.config/claude-code/plugins/version-manager

# Make changes in this repo
# Restart Claude Code to reload
```

## First Use

1. Open Claude Code in any project with git + package.json
2. Type `/bump`
3. Follow the interactive prompts

## Verification

Test the plugin is working:

```bash
# In Claude Code
/bump

# You should see:
# 🔍 Analyzing current repository state...
```

If you see "Command not found", try:
- Restart Claude Code
- Check plugin installation path
- Verify `.claude/claude-code.json` exists

## Troubleshooting

### Plugin not found after installation

1. Check plugins directory exists:
   ```bash
   ls ~/.config/claude-code/plugins/
   ```

2. Verify `.claude/claude-code.json` is present:
   ```bash
   cat ~/.config/claude-code/plugins/version-manager/.claude/claude-code.json
   ```

3. Restart Claude Code completely

### `/bump` command not working

1. Ensure you're in a git repository:
   ```bash
   git status
   ```

2. Ensure package.json exists:
   ```bash
   cat package.json | grep version
   ```

3. Check Claude Code logs for errors

### Skills not available

Skills are invoked automatically by the `/bump` command. You can also use them directly:

```
In Claude Code:
> analyze-changes
> generate-changelog
```

## Uninstallation

```bash
# Remove global plugin
rm -rf ~/.config/claude-code/plugins/version-manager

# Remove per-project
rm -rf /your/project/.claude
```

## Next Steps

- Read [README.md](README.md) for full documentation
- Try `/bump` in a test project
- Customize behavior in `.claude/commands/bump.md`
- Star the repo if you find it useful!
