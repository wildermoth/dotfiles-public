#!/usr/bin/env bash
# Quick sync script for Windows configs.
# Run this after editing alacritty configs or AHK scripts.

set -uo pipefail

DOTFILES_DIR=${DOTFILES_DIR:-$HOME/dotfiles}
export DOTFILES_DIR

source "$DOTFILES_DIR/install/lib.sh" || exit
source "$DOTFILES_DIR/install/lib-windows-sync.sh" || exit

log_section 'windows sync'

windows_profile=$(resolve_windows_profile)

if [[ -n $windows_profile ]]; then
	windows_alacritty=$windows_profile/AppData/Roaming/alacritty
	if [[ -d $windows_alacritty ]]; then
		sync_windows_alacritty "$windows_profile"
	else
		log_skip 'Alacritty (Windows dir not found)'
	fi
else
	log_skip 'Alacritty (Windows dir not found)'
fi

if [[ -n $windows_profile ]]; then
	sync_windows_ahk "$windows_profile"
else
	log_skip 'AHK (Windows profile not found)'
fi

log_ok 'synced; restart apps to apply'
