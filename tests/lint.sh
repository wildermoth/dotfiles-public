#!/usr/bin/env bash
# Checks shell scripts and Python syntax.
set -uo pipefail

dotfiles_dir=${DOTFILES_DIR:-$HOME/dotfiles}
source "$dotfiles_dir/tests/lib.sh" || exit

cache_dir=$(mktemp -d) || exit
trap 'rm -rf "$cache_dir"' EXIT

section 'bash syntax (install scripts tests tmux keyboard)'
check 'bash -n install.sh' bash -n "$dotfiles_dir/install.sh"
while IFS= read -r -d '' f; do
	check "bash -n ${f#"$dotfiles_dir"/}" bash -n "$f"
done < <(find_shell_scripts \
	"$dotfiles_dir/install" \
	"$dotfiles_dir/scripts" \
	"$dotfiles_dir/tests" \
	"$dotfiles_dir/configs/tmux" \
	"$dotfiles_dir/configs/keyboard")

section 'zsh syntax (configs/zsh/)'
check 'zsh -n configs/zsh/zshrc' zsh -n "$dotfiles_dir/configs/zsh/zshrc"
while IFS= read -r -d '' f; do
	check "zsh -n ${f#"$dotfiles_dir"/}" zsh -n "$f"
done < <(find \
	"$dotfiles_dir/configs/zsh/core" \
	"$dotfiles_dir/configs/zsh/modules" \
	-name '*.zsh' -print0)

section 'python syntax'
while IFS= read -r -d '' f; do
	check "py_compile ${f#"$dotfiles_dir"/}" \
		env PYTHONPYCACHEPREFIX="$cache_dir" python3 -m py_compile "$f"
done < <(find \
	"$dotfiles_dir/scripts" \
	"$dotfiles_dir/configs/keyboard" \
	-name '*.py' -print0)

section 'shellcheck'
if command -v shellcheck &>/dev/null; then
	while IFS= read -r -d '' f; do
		check "shellcheck ${f#"$dotfiles_dir"/}" \
			shellcheck -x -e SC1090,SC1091 "$f"
	done < <(find_shell_scripts \
		"$dotfiles_dir/install" \
		"$dotfiles_dir/scripts" \
		"$dotfiles_dir/tests" \
		"$dotfiles_dir/configs/tmux" \
		"$dotfiles_dir/configs/keyboard")
else
	info 'shellcheck' echo 'not installed, skipping'
fi

finish
