# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a dotfiles repository containing personal Linux/Unix shell and editor configurations meant to be symlinked to home directory locations.

## Key Files

- `.zshrc` - Shell configuration for macOS with prompt setup, git aliases, and the `gsw` branch-switching function
- `.bashrc` - Shell configuration for Windows (Git Bash) with identical functionality to `.zshrc`
- `.gitconfig` - Git configuration with optimized defaults (histogram diff, auto-rebase, rerere, etc.)
- `init.lua` - Neovim configuration using lazy.nvim package manager
- `settings.local.json` - Claude Code user settings to be copied to other projects
- `.claude-scripts/` - Claude Code hook scripts to be placed in home directory

## Git Aliases Defined

The `.zshrc` defines these git shortcuts: `gs` (status), `gc` (commit), `gd` (diff), `gch` (checkout), `gcp` (cherry-pick), `gl` (log --first-parent), `ga` (add), `gb` (branch), `gr` (restore).

The `gsw` function switches to a branch by substring match, checking local branches first then remotes.

## Installation

Files can be symlinked or sourced from their target locations:

**macOS:**
- `.zshrc` -> `~/.zshrc` (symlink or source)
- `.gitconfig` -> `~/.gitconfig`
- `init.lua` -> `~/.config/nvim/init.lua`

**Windows (Git Bash):**
- Add `source /c/path/to/linuxconfig/.bashrc` to `~/.bashrc`
- `.gitconfig` -> `~/.gitconfig`

**Claude Code (all platforms):**
- Copy `settings.local.json` to `.claude/settings.local.json` in other projects
- Copy `.claude-scripts/` to `~/.claude-scripts/`
