#!/usr/bin/env bash
# Measure nvim --startuptime over repeated runs (min/avg/max).
# Usage: nvim-startup-bench.sh [-n|--runs N] [--cold]
set -uo pipefail

dotfiles_dir=${DOTFILES_DIR:-$HOME/dotfiles}
bench_dir=$dotfiles_dir/tmp/nvim-bench
log_file=$bench_dir/startuptime.log
times_file=$bench_dir/times.txt

runs=5
cold=0

while [[ $# -gt 0 ]]; do
	case $1 in
	-n | --runs)
		runs=$2
		shift 2
		;;
	--cold)
		cold=1
		shift
		;;
	*)
		runs=$1
		shift
		;;
	esac
done

mkdir -p "$bench_dir/config" "$bench_dir/cache" \
	"$bench_dir/data" "$bench_dir/state" || exit
ln -sfn "$dotfiles_dir/configs/nvim" "$bench_dir/config/nvim" ||
	exit

export XDG_CONFIG_HOME=$bench_dir/config
export XDG_CACHE_HOME=$bench_dir/cache
export XDG_DATA_HOME=$bench_dir/data
export XDG_STATE_HOME=$bench_dir/state

: >"$times_file"

for ((i = 1; i <= runs; i++)); do
	if ((cold == 1)); then
		rm -rf "$bench_dir/cache/nvim" \
			"$bench_dir/data/nvim" \
			"$bench_dir/state/nvim"
	fi

	: >"$log_file"
	nvim --headless --startuptime "$log_file" +qall \
		>/dev/null 2>&1 || exit

	total=$(grep 'NVIM STARTED' "$log_file" | tail -n 1 |
		awk '{print $1}')
	if [[ -z $total ]]; then
		printf 'no NVIM STARTED line in %s\n' "$log_file" >&2
		exit 1
	fi
	printf 'run %d: %s s\n' "$i" "$total"
	printf '%s\n' "$total" >>"$times_file"
done

min=$(sort -n "$times_file" | head -n 1)
max=$(sort -n "$times_file" | tail -n 1)
avg=$(awk '{sum += $1} END {if (NR>0) printf "%.3f", sum/NR}' \
	"$times_file")

printf 'min/avg/max: %s/%s/%s s\n' "$min" "$avg" "$max"
