#!/usr/bin/env bash
# Dotfiles installation script
#
# Runs each numbered step in install/ in order.

set -uo pipefail

DOTFILES_DIR=${DOTFILES_DIR:-$HOME/dotfiles}
export DOTFILES_DIR
CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}
export CONFIG_DIR
OBSIDIAN_PATH=${OBSIDIAN_PATH:-$HOME/obsidian}
export OBSIDIAN_PATH

source "$DOTFILES_DIR/install/lib.sh" || exit
source "$DOTFILES_DIR/install/lib-windows-sync.sh" || exit

log_section 'dotfiles install'

shopt -s nullglob
steps=("$DOTFILES_DIR"/install/[0-9]*.sh)
shopt -u nullglob

for step in "${steps[@]}"; do
	step_name=${step##*/}
	step_name=${step_name#*-}
	step_name=${step_name%.sh}
	step_name=${step_name//-/ }
	log_section "$step_name"
	source "$step" || exit
done
