#!/usr/bin/env bash
# Symlinks utility scripts into ~/bin.
# Sourced by install.sh; not run standalone.

mkdir -p "$HOME/bin" || exit

backup_and_symlink \
	"$HOME/bin/tmux-session-persistent" \
	"$DOTFILES_DIR/configs/tmux/bin/tmux-session-persistent"
backup_and_symlink \
	"$HOME/bin/tmux-pane-history" \
	"$DOTFILES_DIR/configs/tmux/bin/tmux-pane-history"
