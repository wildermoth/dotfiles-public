#!/usr/bin/env bash
# Run Kanata in the foreground. For testing.
set -uo pipefail

dotfiles_dir=${DOTFILES_DIR:-$HOME/dotfiles}
kanata_dir=$dotfiles_dir/configs/keyboard/kanata
macos_dir=$kanata_dir/os/macos
resolved_kbd=$kanata_dir/main.resolved.kbd
bin_candidates=(
	/usr/local/bin/kanata-cmd-allowed
	/opt/homebrew/bin/kanata-cmd-allowed
	/usr/local/bin/kanata_cmd_allowed
	/opt/homebrew/bin/kanata_cmd_allowed
	/usr/local/bin/kanata_macos_cmd_allowed_arm64
	/opt/homebrew/bin/kanata_macos_cmd_allowed_arm64
	"$macos_dir/kanata_macos_cmd_allowed_arm64"
	"$macos_dir/kanata_macos_cmd_allowed_x64"
)

bin=
for candidate in "${bin_candidates[@]}"; do
	if [[ -x $candidate ]]; then
		bin=$candidate
		break
	fi
done

if [[ -z $bin ]]; then
	printf 'Could not find a cmd-enabled Kanata binary.\n'
	printf 'Install one of these names first:\n'
	printf '  %s\n' "${bin_candidates[@]}"
	exit 1
fi

sed "s|__DOTFILES_DIR__|$dotfiles_dir|g" \
	"$kanata_dir/main.kbd" >"$resolved_kbd" || exit
if grep -q '__DOTFILES_DIR__' "$resolved_kbd"; then
	printf 'unexpanded __DOTFILES_DIR__ in %s\n' "$resolved_kbd" >&2
	exit 1
fi

exec "$bin" -n --cfg "$resolved_kbd"
