#!/usr/bin/env bash
# Helpers sourced by each test script.

pass_count=0
fail_count=0

section() {
	printf '\n== %s ==\n' "$1"
}

# check label -- cmd [args...]
# Runs a command and updates the pass or fail count.
check() {
	local label=$1
	shift
	local output
	if output=$("$@" 2>&1); then
		printf 'PASS  %s\n' "$label"
		((pass_count += 1))
	else
		printf 'FAIL  %s\n' "$label"
		while IFS= read -r line || [[ -n $line ]]; do
			printf '      %s\n' "$line"
		done <<<"$output"
		((fail_count += 1))
	fi
}

# info label -- cmd [args...]
# Runs a command and prints its output without updating the counts.
info() {
	local label=$1
	shift
	printf '\n-- %s (informational) --\n' "$label"
	while IFS= read -r line || [[ -n $line ]]; do
		printf '      %s\n' "$line"
	done < <("$@" 2>&1)
}

# find_shell_scripts dir [dir...]
# Prints executable shell scripts as NUL-separated paths.
find_shell_scripts() {
	local f first_line
	while IFS= read -r -d '' f; do
		first_line=
		IFS= read -r first_line <"$f" || [[ -n $first_line ]]
		if [[ $first_line =~ ^#!.*(ba|z)?sh ]]; then
			printf '%s\0' "$f"
		fi
	done < <(find "$@" -type f -print0)
}

finish() {
	printf '\n%d passed, %d failed\n' "$pass_count" "$fail_count"
	((fail_count == 0))
}
