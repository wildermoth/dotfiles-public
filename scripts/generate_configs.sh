#!/usr/bin/env bash
# Generate configuration files from templates using palette.json and OS
# (mac/wsl, from install/lib.sh). Run standalone or from
# install/10-configs.sh.

set -uo pipefail

DOTFILES_DIR=${DOTFILES_DIR:-$HOME/dotfiles}
export DOTFILES_DIR

source "$DOTFILES_DIR/install/lib.sh" || exit

# jinjanate resolves {% include %} paths against the cwd, so templates can use
# repo-relative includes (configs/tmux/conf.d/*.conf.j2).
cd "$DOTFILES_DIR" || exit

palette_file=$DOTFILES_DIR/configs/theme/palette.json
if [[ ! -f $palette_file ]]; then
	log_warn "palette.json not found at $(pretty_path "$palette_file")"
	exit 1
fi

if ! command -v uv &>/dev/null; then
	log_warn 'uv not found (needed for uvx jinjanate)'
	exit 1
fi

if is_macos; then
	OS=mac
elif is_wsl; then
	OS=wsl
else
	log_warn 'OS must be mac or wsl'
	exit 1
fi
export OS

render_template() {
	local label=$1
	local template=$2
	local output=$3

	if [[ ! -f $template ]]; then
		log_skip "$label (template not found)"
		return 0
	fi

	uvx --quiet --from jinjanator jinjanate \
		--quiet \
		--customize "$DOTFILES_DIR/scripts/jinja_customize.py" \
		-f json \
		"$template" "$palette_file" -o "$output" || exit
	log_ok "$label"
}

render_template 'lazygit' \
	"$DOTFILES_DIR/configs/lazygit/config.yml.j2" \
	"$DOTFILES_DIR/configs/lazygit/config.yml"
render_template 'tmux' \
	"$DOTFILES_DIR/configs/tmux/tmux.conf.j2" \
	"$DOTFILES_DIR/configs/tmux/tmux.conf"
render_template 'zsh os core' \
	"$DOTFILES_DIR/configs/zsh/core/05-os.zsh.j2" \
	"$DOTFILES_DIR/configs/zsh/core/05-os.zsh"
render_template 'zsh p10k' \
	"$DOTFILES_DIR/configs/zsh/p10k.zsh.j2" \
	"$DOTFILES_DIR/configs/zsh/p10k.zsh"
alacritty_j2=$DOTFILES_DIR/configs/alacritty/alacritty.toml.j2
render_template 'alacritty' \
	"$alacritty_j2" \
	"$DOTFILES_DIR/configs/alacritty/alacritty.toml"
# Native Windows Alacritty is not an install OS. Same template, OS=windows.
OS=windows render_template 'alacritty windows' \
	"$alacritty_j2" \
	"$DOTFILES_DIR/configs/alacritty/os-windows.toml"
