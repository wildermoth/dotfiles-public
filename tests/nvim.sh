#!/usr/bin/env bash
# Checks headless startup. Isolated HOME / XDG_*.
# checkhealth prints issues only.
set -uo pipefail

dotfiles_dir=${DOTFILES_DIR:-$HOME/dotfiles}
source "$dotfiles_dir/tests/lib.sh" || exit

orig_home=$HOME
tmp_dir=$(mktemp -d) || exit
health_file="$tmp_dir/health.txt"
trap 'rm -rf "$tmp_dir"' EXIT

export HOME="$tmp_dir/home"
export XDG_CONFIG_HOME="$tmp_dir/config"
export XDG_CACHE_HOME="$tmp_dir/cache"
export XDG_DATA_HOME="$tmp_dir/data"
export XDG_STATE_HOME="$tmp_dir/state"
# Headless nvim has TERM=dumb. Unset TMUX so :checkhealth does not
# query the live server.
unset TMUX TMUX_PANE
mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" \
	"$XDG_DATA_HOME" "$XDG_STATE_HOME" || exit
# Point nvim at repo config. Do not set XDG_CONFIG_HOME to configs/:
# plugins mkdir sibling dirs (kitty) inside the repo.
ln -s "$dotfiles_dir/configs/nvim" "$XDG_CONFIG_HOME/nvim" || exit
# Reuse already-installed plugins; do not clone into the sandbox.
if [[ -d $orig_home/.local/share/nvim ]]; then
	ln -s "$orig_home/.local/share/nvim" "$XDG_DATA_HOME/nvim"
fi

nvim_starts_cleanly() {
	local out rc
	out=$(nvim -i NONE --headless -c 'quitall!' 2>&1)
	rc=$?
	if ((rc != 0)) \
		|| grep -qE 'Error executing lua|stack traceback:|E5108' <<<"$out"; then
		printf '%s\n' "$out"
		return 1
	fi
	return 0
}

show_health() {
	local error_count rc warn_count
	nvim -i NONE --headless \
		-c 'checkhealth' -c "write! $health_file" -c 'qall!' &>/dev/null
	rc=$?
	if ((rc != 0)); then
		printf 'checkhealth exited with status %d\n' "$rc"
	fi
	if [[ ! -f $health_file ]]; then
		printf 'checkhealth produced no report\n'
		return 0
	fi
	error_count=$(grep -c ' ERROR' "$health_file" || true)
	warn_count=$(grep -c ' WARNING' "$health_file" || true)
	printf '%d error(s), %d warning(s)\n' "$error_count" "$warn_count"
	awk '
		/^={10,}/ { next }
		/^[A-Za-z].*:/ { sec = $0; next }
		/ ERROR| WARNING/ { if (sec != "") { print sec; sec = "" } print }
	' "$health_file"
}

section 'nvim headless startup'
check 'nvim -i NONE --headless -c quitall!' nvim_starts_cleanly
info ':checkhealth' show_health

finish
