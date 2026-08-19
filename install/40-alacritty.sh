#!/usr/bin/env bash
# Symlinks the generated Alacritty config. On WSL also copies the Windows
# render to native Alacritty and syncs AHK.
# Sourced by install.sh; not run standalone.

mkdir -p "$CONFIG_DIR/alacritty" || exit

backup_and_symlink \
	"$CONFIG_DIR/alacritty/alacritty.toml" \
	"$DOTFILES_DIR/configs/alacritty/alacritty.toml"

if ! is_wsl; then
	return 0
fi

windows_profile=$(resolve_windows_profile)
if [[ -z $windows_profile ]]; then
	log_skip 'Windows profile not found'
	return 0
fi

sync_windows_alacritty "$windows_profile"
sync_windows_ahk "$windows_profile"
