#!/usr/bin/env bash
# Runs safe install steps in a temporary home, then checks expected links.
# install/00-deps.sh is omitted because it installs packages.
set -uo pipefail

dotfiles_dir=${DOTFILES_DIR:-$HOME/dotfiles}
source "$dotfiles_dir/tests/lib.sh" || exit
source "$dotfiles_dir/install/lib.sh" || exit

sandbox=$(mktemp -d) || exit
trap 'rm -rf "$sandbox"' EXIT
home="$sandbox/home"
config_dir="$home/.config"

dryrun_script="$sandbox/dryrun.sh"
cat >"$dryrun_script" <<EOF
#!/usr/bin/env bash
set -uo pipefail
export DOTFILES_DIR="$dotfiles_dir"
export HOME="$home"
export CONFIG_DIR="\$HOME/.config"
export OBSIDIAN_PATH="\$HOME/obsidian"
mkdir -p "\$HOME" || exit

source "$dotfiles_dir/install/lib.sh" || exit
source "$dotfiles_dir/install/lib-windows-sync.sh" || exit
# Keep Windows files outside the test scope.
resolve_windows_profile() {
	:
}

steps=(
	20-symlinks
	40-alacritty
	60-bin-symlinks
	70-obsidian
)
for step in "\${steps[@]}"; do
	source "$dotfiles_dir/install/\$step.sh" || exit
done
EOF

section 'sandboxed install steps (20-symlinks .. 70-obsidian)'
check 'install steps run without error' bash "$dryrun_script"

link_points_to() {
	local link=$1
	local expected=$2
	local actual
	if [[ ! -L $link ]]; then
		printf 'not a symlink: %s\n' "$link"
		return 1
	fi
	actual=$(readlink "$link")
	if [[ $actual != "$expected" ]]; then
		printf '%s -> %s (expected %s)\n' "$link" "$actual" "$expected"
		return 1
	fi
	if [[ ! -e $link ]]; then
		printf 'broken symlink: %s -> %s\n' "$link" "$actual"
		return 1
	fi
	return 0
}

gitconfig_local_from_example() {
	local dest=$1
	local src=$2
	if [[ -L $dest ]]; then
		printf 'gitconfig.local is a symlink\n'
		return 1
	fi
	if [[ ! -f $dest ]]; then
		printf 'gitconfig.local missing\n'
		return 1
	fi
	if ! cmp -s "$dest" "$src"; then
		printf 'gitconfig.local does not match example\n'
		return 1
	fi
	return 0
}

verify_symlinks() {
	local broken=0
	local link
	local link_count=0
	while IFS= read -r -d '' link; do
		((link_count += 1))
		if [[ ! -e $link ]]; then
			printf 'broken symlink: %s -> %s\n' "$link" \
				"$(readlink "$link")"
			broken=1
		fi
	done < <(find "$home" -type l -print0)
	if ((link_count == 0)); then
		printf 'no symlinks created\n'
		return 1
	fi
	return "$broken"
}

section 'expected symlink destinations'
check '~/.config/nvim points at configs/nvim' link_points_to \
	"$config_dir/nvim" "$dotfiles_dir/configs/nvim"
check '~/.zshrc points at configs/zsh/zshrc' link_points_to \
	"$home/.zshrc" "$dotfiles_dir/configs/zsh/zshrc"
check '~/.zshenv points at configs/zsh/zshenv' link_points_to \
	"$home/.zshenv" "$dotfiles_dir/configs/zsh/zshenv"
check '~/.p10k.zsh points at configs/zsh/p10k.zsh' link_points_to \
	"$home/.p10k.zsh" "$dotfiles_dir/configs/zsh/p10k.zsh"
check '~/.tmux.conf points at configs/tmux/tmux.conf' link_points_to \
	"$home/.tmux.conf" "$dotfiles_dir/configs/tmux/tmux.conf"
check '~/.gitignore_global points at gitignore_global' link_points_to \
	"$home/.gitignore_global" \
	"$dotfiles_dir/configs/git/gitignore_global"
check '~/.gitconfig points at configs/git/gitconfig' link_points_to \
	"$home/.gitconfig" "$dotfiles_dir/configs/git/gitconfig"
check '~/.config/atuin/config.toml points at atuin' link_points_to \
	"$config_dir/atuin/config.toml" \
	"$dotfiles_dir/configs/atuin/config.toml"
check '~/.config/alacritty/alacritty.toml points at alacritty' \
	link_points_to \
	"$config_dir/alacritty/alacritty.toml" \
	"$dotfiles_dir/configs/alacritty/alacritty.toml"
check '~/bin/tmux-session-persistent points at tmux bin' \
	link_points_to \
	"$home/bin/tmux-session-persistent" \
	"$dotfiles_dir/configs/tmux/bin/tmux-session-persistent"
check '~/bin/tmux-pane-history points at tmux bin' link_points_to \
	"$home/bin/tmux-pane-history" \
	"$dotfiles_dir/configs/tmux/bin/tmux-pane-history"

if is_macos; then
	lazygit_config="$home/Library/Application Support/lazygit/config.yml"
else
	lazygit_config="$config_dir/lazygit/config.yml"
fi
check 'lazygit config.yml points at configs/lazygit' link_points_to \
	"$lazygit_config" "$dotfiles_dir/configs/lazygit/config.yml"

check '~/.gitconfig.local copied from example' \
	gitconfig_local_from_example \
	"$home/.gitconfig.local" \
	"$dotfiles_dir/configs/git/gitconfig.local.example"

section 'symlink targets exist on disk'
check 'no broken symlink targets' verify_symlinks

finish
