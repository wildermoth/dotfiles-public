#!/usr/bin/env bash
# Install launchd services for Kanata + Karabiner VirtualHID.
# sudo ./install.sh
set -uo pipefail

dotfiles_dir=${DOTFILES_DIR:-$HOME/dotfiles}
kanata_dir=$dotfiles_dir/configs/keyboard/kanata
macos_dir=$kanata_dir/os/macos
resolved_kbd=$kanata_dir/main.resolved.kbd
launchd_dir=$macos_dir/launchd
kanata_plist_src=$launchd_dir/com.james.keyboard.kanata.plist
vhid_plist_src=$launchd_dir/com.james.keyboard.karabiner-vhid.plist
vhid_mgr_src=$launchd_dir
vhid_mgr_src+='/com.james.keyboard.karabiner-vhidmanager.plist'
kanata_plist_dst=/Library/LaunchDaemons/com.james.keyboard.kanata.plist
vhid_plist_dst=/Library/LaunchDaemons
vhid_plist_dst+='/com.james.keyboard.karabiner-vhid.plist'
vhid_mgr_dst=/Library/LaunchDaemons
vhid_mgr_dst+='/com.james.keyboard.karabiner-vhidmanager.plist'
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

euid=${EUID:-$(id -u)}
if ((euid != 0)); then
	printf 'Run this as root:\n'
	printf '  sudo %s/install.sh\n' "$macos_dir"
	exit 1
fi

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
if [[ -n ${SUDO_USER:-} ]]; then
	chown "$SUDO_USER" "$resolved_kbd" || exit
fi

mkdir -p /Library/Logs/Kanata || exit
chown root:wheel /Library/Logs/Kanata || exit

mkdir -p /Library/LaunchDaemons || exit
sed -e "s|__KANATA_BIN__|$bin|g" \
	-e "s|__DOTFILES_DIR__|$dotfiles_dir|g" \
	"$kanata_plist_src" >"$kanata_plist_dst" || exit
chmod 644 "$kanata_plist_dst" || exit
install -m 644 "$vhid_plist_src" "$vhid_plist_dst" || exit
install -m 644 "$vhid_mgr_src" "$vhid_mgr_dst" || exit
chown root:wheel \
	"$kanata_plist_dst" "$vhid_plist_dst" "$vhid_mgr_dst" ||
	exit

vhid_manager=/Applications/.Karabiner-VirtualHIDDevice-Manager.app
vhid_manager+='/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager'
"$vhid_manager" activate || true

launchctl bootout system "$kanata_plist_dst" 2>/dev/null || true
launchctl bootout system "$vhid_plist_dst" 2>/dev/null || true
launchctl bootout system "$vhid_mgr_dst" 2>/dev/null || true
launchctl bootstrap system "$vhid_mgr_dst" || exit
launchctl bootstrap system "$vhid_plist_dst" || exit
launchctl bootstrap system "$kanata_plist_dst" || exit
launchctl kickstart -k \
	system/com.james.keyboard.karabiner-vhidmanager || exit
launchctl kickstart -k system/com.james.keyboard.karabiner-vhid ||
	exit
launchctl kickstart -k system/com.james.keyboard.kanata || exit

cat <<EOF
Installed macOS keyboard services.

Services:
  $vhid_mgr_dst
  $vhid_plist_dst
  $kanata_plist_dst

Management:
  sudo launchctl kickstart -k system/com.james.keyboard.karabiner-vhidmanager
  sudo launchctl kickstart -k system/com.james.keyboard.karabiner-vhid
  sudo launchctl kickstart -k system/com.james.keyboard.kanata
  sudo launchctl bootout system $kanata_plist_dst
  sudo launchctl bootout system $vhid_plist_dst
  sudo launchctl bootout system $vhid_mgr_dst

Notes:
  - Keep macOS input source on stock U.S. while Kanata is active.
  - Using Kanata binary: $bin
  - Add $bin to System Settings > Privacy & Security > Input Monitoring.
  - Add $bin to System Settings > Privacy & Security > Accessibility.
  - Caps+\` reloads the Kanata config in place.
  - Caps+1..5 call the existing FlashSpace wrapper.
EOF
