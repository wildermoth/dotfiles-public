#!/usr/bin/env bash
# Checks AHK include fragments exist and kanata sources stay portable.
set -uo pipefail

dotfiles_dir=${DOTFILES_DIR:-$HOME/dotfiles}
source "$dotfiles_dir/tests/lib.sh" || exit

ahk_host="$dotfiles_dir/configs/keyboard/ahk/main.ahk"
ahk_split="$dotfiles_dir/configs/keyboard/ahk/split"

ahk_includes_in_split() {
	local line dest found=0
	while IFS= read -r line || [[ -n $line ]]; do
		[[ $line == '#Include'* ]] || continue
		dest=${line##*/}
		dest=${dest%$'\r'}
		if [[ ! -f $ahk_split/$dest ]]; then
			printf 'missing split fragment: %s\n' "$dest"
			return 1
		fi
		found=1
	done <"$ahk_host"
	if ((found == 0)); then
		printf 'main.ahk has no #Include lines\n'
		return 1
	fi
	return 0
}

file_exists() {
	[[ -f $1 ]]
}

section 'ahk layout'
check 'configs/keyboard/ahk/main.ahk exists' file_exists "$ahk_host"
check 'main.ahk #Include files exist in split/' ahk_includes_in_split

no_users_path() {
	! grep -q '/Users/' "$1"
}

kanata_kbd="$dotfiles_dir/configs/keyboard/kanata/main.kbd"
kanata_plist="$dotfiles_dir/configs/keyboard/kanata/os/macos/launchd"
kanata_plist+='/com.james.keyboard.kanata.plist'

section 'kanata paths'
check 'main.kbd has no /Users/' no_users_path "$kanata_kbd"
check 'kanata plist has no /Users/' no_users_path "$kanata_plist"
check 'main.kbd templates __DOTFILES_DIR__' \
	grep -q '__DOTFILES_DIR__' "$kanata_kbd"
check 'kanata plist templates __DOTFILES_DIR__' \
	grep -q '__DOTFILES_DIR__' "$kanata_plist"

finish
