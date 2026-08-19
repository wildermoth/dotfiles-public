#!/usr/bin/env bash
# Symlinks dotfiles-managed configs into their expected locations, backing up
# any pre-existing real files first. Sourced by install.sh; not run standalone.

mkdir -p "$CONFIG_DIR" || exit

if is_macos; then
	lazygit_config_dir="$HOME/Library/Application Support/lazygit"
else
	lazygit_config_dir=$CONFIG_DIR/lazygit
fi
mkdir -p "$lazygit_config_dir" || exit
mkdir -p "$CONFIG_DIR/atuin" || exit

backup_and_symlink \
	"$CONFIG_DIR/nvim" \
	"$DOTFILES_DIR/configs/nvim"
backup_and_symlink \
	"$HOME/.zshrc" \
	"$DOTFILES_DIR/configs/zsh/zshrc"
backup_and_symlink \
	"$HOME/.zshenv" \
	"$DOTFILES_DIR/configs/zsh/zshenv"
backup_and_symlink \
	"$HOME/.p10k.zsh" \
	"$DOTFILES_DIR/configs/zsh/p10k.zsh"
backup_and_symlink \
	"$HOME/.tmux.conf" \
	"$DOTFILES_DIR/configs/tmux/tmux.conf"
backup_and_symlink \
	"$HOME/.gitignore_global" \
	"$DOTFILES_DIR/configs/git/gitignore_global"
backup_and_symlink \
	"$HOME/.gitconfig" \
	"$DOTFILES_DIR/configs/git/gitconfig"
local_gitconfig="$HOME/.gitconfig.local"
if [[ -f $local_gitconfig ]]; then
	log_unchanged "$(pretty_path "$local_gitconfig")"
else
	cp "$DOTFILES_DIR/configs/git/gitconfig.local.example" \
		"$local_gitconfig" || exit
	chmod 600 "$local_gitconfig" || exit
	log_ok "$(pretty_path "$local_gitconfig") (from example)"
	log_note 'edit ~/.gitconfig.local for name, email, signing'
fi
backup_and_symlink \
	"$lazygit_config_dir/config.yml" \
	"$DOTFILES_DIR/configs/lazygit/config.yml"
backup_and_symlink \
	"$CONFIG_DIR/atuin/config.toml" \
	"$DOTFILES_DIR/configs/atuin/config.toml"
