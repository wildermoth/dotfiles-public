#!/usr/bin/env bash
# Generates templates and checks config syntax.
set -uo pipefail

dotfiles_dir=${DOTFILES_DIR:-$HOME/dotfiles}
source "$dotfiles_dir/tests/lib.sh" || exit

validate_toml() {
	python3 -c \
		'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' "$1"
}

validate_yaml() {
	python3 -c \
		'import sys, yaml; yaml.safe_load(open(sys.argv[1]))' "$1"
}

no_unexpanded_vars() {
	! grep -qE '<<[A-Za-z_]|<%' "$1"
}

no_identity_keys() {
	! grep -qE '^\s*(email|name|signingkey)\s*=' "$1"
}

# Must match scripts/generate_configs.sh render_template outputs.
generated=(
	"$dotfiles_dir/configs/lazygit/config.yml"
	"$dotfiles_dir/configs/tmux/tmux.conf"
	"$dotfiles_dir/configs/zsh/core/05-os.zsh"
	"$dotfiles_dir/configs/zsh/p10k.zsh"
	"$dotfiles_dir/configs/alacritty/alacritty.toml"
	"$dotfiles_dir/configs/alacritty/os-windows.toml"
)

section 'generate configs'
check 'scripts/generate_configs.sh' \
	env DOTFILES_DIR="$dotfiles_dir" "$dotfiles_dir/scripts/generate_configs.sh"

section 'generated output has no leftover jinja'
for f in "${generated[@]}"; do
	check "${f#"$dotfiles_dir"/} has no leftover << or <%" \
		no_unexpanded_vars "$f"
done

section 'generated output parses'
check 'lazygit config.yml parses' validate_yaml \
	"$dotfiles_dir/configs/lazygit/config.yml"

section 'static configs parse'
for f in "$dotfiles_dir"/configs/alacritty/*.toml; do
	check "alacritty ${f##*/} parses" validate_toml "$f"
done
check 'gitconfig parses' git config -f \
	"$dotfiles_dir/configs/git/gitconfig" --list
check 'gitconfig has no identity keys' no_identity_keys \
	"$dotfiles_dir/configs/git/gitconfig"

finish
