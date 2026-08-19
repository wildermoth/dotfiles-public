#!/usr/bin/env bash
# Shared helpers sourced by every install/*.sh step and by
# scripts/sync-windows.sh. Not meant to be executed directly.

is_macos() {
	[[ $(uname -s) == Darwin ]]
}

is_termux() {
	[[ -n ${TERMUX_VERSION-} ]] || [[ ${PREFIX-} == *'com.termux'* ]]
}

is_wsl() {
	grep -qi microsoft /proc/version 2>/dev/null
}

# pretty_path path
# Echoes path with $HOME replaced by ~.
pretty_path() {
	local path=$1
	if [[ $path == "$HOME" || $path == "$HOME"/* ]]; then
		printf '~%s' "${path#"$HOME"}"
	else
		printf '%s' "$path"
	fi
}

# log kind message
# Status line: kind left-padded to 7 chars so messages share a column.
log() {
	local kind=$1
	shift
	printf '%-8s%s\n' "$kind" "$*"
}

log_section() {
	printf '\n== %s ==\n' "$*"
}

log_ok() {
	log ok "$*"
}

log_run() {
	log run "$*"
}

log_skip() {
	log skip "$*"
}

log_unchanged() {
	log_skip "$* (unchanged)"
}

log_warn() {
	log warn "$*"
}

log_note() {
	log note "$*"
}

log_link() {
	local left right
	left=$(pretty_path "$1")
	right=$(pretty_path "$2")
	log link "$left -> $right"
}

log_backup() {
	local left right
	left=$(pretty_path "$1")
	right=$(pretty_path "$2")
	log backup "$left -> $right"
}

log_copy() {
	local left right
	left=$(pretty_path "$1")
	right=$(pretty_path "$2")
	log copy "$left -> $right"
}

# backup_and_symlink target source
# Backs up an existing non-symlink at target, then links target -> source.
backup_and_symlink() {
	local target=$1
	local source=$2
	local current_source stamp backup

	if [[ -L $target ]]; then
		if current_source=$(readlink "$target") &&
			[[ $current_source == "$source" ]]; then
			log_unchanged "$(pretty_path "$target")"
			return 0
		fi
	fi

	if [[ ! -e $source && ! -L $source ]]; then
		log_warn "missing source $(pretty_path "$source")"
		return 0
	fi

	if [[ -e $target && ! -L $target ]]; then
		stamp=$(date +%Y%m%d_%H%M%S)
		backup="$target.backup.$stamp"
		log_backup "$target" "$backup"
		mv "$target" "$backup" || exit
	fi

	log_link "$target" "$source"
	ln -sfn "$source" "$target" || exit
}

# backup_copy file
# Copies an existing file to file.backup.<timestamp> (leaves original).
backup_copy() {
	local file=$1
	local stamp backup

	if [[ -f $file ]]; then
		stamp=$(date +%Y%m%d_%H%M%S)
		backup="$file.backup.$stamp"
		log_backup "$file" "$backup"
		cp "$file" "$backup" || exit
	fi
}
