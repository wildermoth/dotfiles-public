#!/usr/bin/env bash
# WSL -> Windows sync helpers, shared by install/40-alacritty.sh and
# scripts/sync-windows.sh. Requires install/lib.sh and $DOTFILES_DIR.
# Not meant to be executed directly.

# resolve_windows_profile
# Echoes the Unix path to the Windows user profile dir, or nothing if not found.
resolve_windows_profile() {
	local windows_user profile
	windows_user=$(cmd.exe /c 'echo %USERNAME%' 2>/dev/null \
		| tr -d '\r\n' || true)
	[[ -n $windows_user ]] || windows_user=$(whoami)

	profile="/mnt/c/Users/$windows_user"
	[[ -d $profile ]] && printf '%s\n' "$profile"
}

# sync_windows_alacritty profile_dir
# Copies the generated Windows Alacritty config as the live Windows file.
sync_windows_alacritty() {
	local profile_dir=$1
	local dest=$profile_dir/AppData/Roaming/alacritty/alacritty.toml
	local src=$DOTFILES_DIR/configs/alacritty/os-windows.toml

	mkdir -p "${dest%/*}" || exit
	backup_copy "$dest"
	cp "$src" "$dest" || exit
	log_copy "$src" "$dest"
}

# sync_windows_ahk profile_dir
# Copies AHK host + split fragments. Dest names stay
# extend_layer_wide_std* so live Windows #Includes keep working.
sync_windows_ahk() {
	local profile_dir=$1
	local dest_dir="$profile_dir/Desktop/AHK Scripts"
	local src_host=$DOTFILES_DIR/configs/keyboard/ahk/main.ahk
	local src_split=$DOTFILES_DIR/configs/keyboard/ahk/split
	local dest_host=$dest_dir/extend_layer_wide_std.ahk
	local dest_split=$dest_dir/extend_layer_wide_std_split

	mkdir -p "$dest_dir" "$dest_split" || exit
	backup_copy "$dest_host"
	cp "$src_host" "$dest_host" || exit
	log_copy "$src_host" "$dest_host"
	cp "$src_split/"*.ahk "$dest_split/" || exit
	log_copy "$src_split" "$dest_split"
}
