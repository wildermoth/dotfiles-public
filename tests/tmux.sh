#!/usr/bin/env bash
# Loads tmux.conf on an isolated socket. Window-list formats are checked
# via a control-mode client resized with refresh-client -C.
set -uo pipefail

dotfiles_dir=${DOTFILES_DIR:-$HOME/dotfiles}
source "$dotfiles_dir/tests/lib.sh" || exit

tmp_dir=$(mktemp -d) || exit
socket="$tmp_dir/tmux.sock"

cleanup() {
	tmux -S "$socket" kill-server &>/dev/null || true
	rm -rf "$tmp_dir"
}
trap cleanup EXIT

tmux_loads_config() {
	tmux -S "$socket" -f "$dotfiles_dir/configs/tmux/tmux.conf" \
		new-session -d -s dtf_test -x 80 -y 24 || return 1
	tmux -S "$socket" has-session -t dtf_test 2>/dev/null
}

# Control-mode client at WxH, then expand the window list the status line uses.
window_list_at_width() {
	local width=$1
	local fmt
	fmt='#{W:#{E:window-status-format},#{E:window-status-current-format}}'
	{
		printf '%s\n' "refresh-client -C ${width}x24"
		sleep 0.25
		printf 'display-message -p "%s"\n' "$fmt"
		sleep 0.25
	} | tmux -S "$socket" -C attach-session -t dtf_test | awk '
		/^%begin/ { grab=1; next }
		/^%/ { grab=0; next }
		grab { payload=$0 }
		END { print payload }
	'
}

narrow_status_uses_index_only() {
	tmux -S "$socket" rename-window -t dtf_test:1 NarrowTestTab || return 1
	local out
	out=$(window_list_at_width 40) || return 1
	[[ $out != *NarrowTestTab* ]] || return 1
	[[ $out == *1* ]]
}

wide_status_uses_window_name() {
	tmux -S "$socket" rename-window -t dtf_test:1 NarrowTestTab || return 1
	local out
	out=$(window_list_at_width 120) || return 1
	[[ $out == *NarrowTestTab* ]]
}

section 'tmux config loads'
check 'tmux loads configs/tmux/tmux.conf' tmux_loads_config
check 'narrow client window list is index only' narrow_status_uses_index_only
check 'wide client window list includes window name' \
	wide_status_uses_window_name

persistent="$dotfiles_dir/configs/tmux/bin/tmux-session-persistent"

session_persistent_requires_name() {
	local out
	out=$("$persistent" 2>&1) && return 1
	[[ $out == Usage* ]]
}

session_persistent_rejects_unknown() {
	local out
	out=$("$persistent" not-a-real-session 2>&1) && return 1
	[[ $out == unknown\ session:* ]]
}

session_persistent_uses_dotfiles_dir() {
	local out
	out=$(env DOTFILES_DIR=/no/such/dotfiles "$persistent" dotfiles 2>&1) &&
		return 1
	[[ $out == directory\ not\ found:\ /no/such/dotfiles ]]
}

session_persistent_uses_obsidian_path() {
	local out
	out=$(env OBSIDIAN_PATH=/no/such/vault "$persistent" obsidian 2>&1) &&
		return 1
	[[ $out == directory\ not\ found:\ /no/such/vault ]]
}

session_persistent_uses_dotfiles_ai_dir() {
	local out
	out=$(env DOTFILES_AI_DIR=/no/such/ai "$persistent" dotfiles-ai 2>&1) &&
		return 1
	[[ $out == directory\ not\ found:\ /no/such/ai ]]
}

section 'tmux session helpers'
check 'tmux-session-persistent requires a name' \
	session_persistent_requires_name
check 'tmux-session-persistent rejects unknown names' \
	session_persistent_rejects_unknown
check 'tmux-session-persistent uses DOTFILES_DIR' \
	session_persistent_uses_dotfiles_dir
check 'tmux-session-persistent uses OBSIDIAN_PATH' \
	session_persistent_uses_obsidian_path
check 'tmux-session-persistent uses DOTFILES_AI_DIR' \
	session_persistent_uses_dotfiles_ai_dir

pane_history="$dotfiles_dir/configs/tmux/bin/tmux-pane-history"

pane_history_requires_pane_id() {
	local out
	out=$("$pane_history" 2>&1) && return 1
	[[ $out == Usage* ]]
}

check 'tmux-pane-history requires a pane-id' pane_history_requires_pane_id

finish
