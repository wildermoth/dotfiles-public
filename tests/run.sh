#!/usr/bin/env bash
# Runs each test script in a subprocess and reports all failures.
set -uo pipefail

dotfiles_dir=${DOTFILES_DIR:-$HOME/dotfiles}
tests_dir=$dotfiles_dir/tests

overall_status=0
results=()

for suite in "$tests_dir"/*.sh; do
	name=${suite##*/}
	name=${name%.sh}
	[[ $name == 'lib' || $name == 'run' ]] && continue

	printf '\n########## %s ##########\n' "$name"
	if bash "$suite"; then
		results+=("PASS  $name")
	else
		results+=("FAIL  $name")
		overall_status=1
	fi
done

printf '\n========== summary ==========\n'
printf '%s\n' "${results[@]}"

exit "$overall_status"
