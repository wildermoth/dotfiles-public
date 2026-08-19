# Kanata

Working Kanata migration.

- `main.kbd`: config meant to stay cross-platform
- `os/macos/`: launch/start/install files for macOS

## Current state

- [`main.kbd`](main.kbd) is the active config.
- macOS-first and working.
- Assumes stock `U.S.` at the OS level and applies Colemak-DH ANSI Wide in Kanata.
- `Caps+\`` live-reloads the config.
- `Caps+1..5` call [`switch_window.sh`](os/macos/switch_window.sh) for FlashSpace workspace switching.

## macOS files

- [`os/macos/install.sh`](os/macos/install.sh): installs and restarts the launchd services
- [`os/macos/start.sh`](os/macos/start.sh): manual foreground launcher for testing
- [`os/macos/launchd/com.james.keyboard.kanata.plist`](os/macos/launchd/com.james.keyboard.kanata.plist): Kanata service
- [`os/macos/launchd/com.james.keyboard.karabiner-vhidmanager.plist`](os/macos/launchd/com.james.keyboard.karabiner-vhidmanager.plist): activates the Karabiner virtual HID driver
- [`os/macos/launchd/com.james.keyboard.karabiner-vhid.plist`](os/macos/launchd/com.james.keyboard.karabiner-vhid.plist): runs the Karabiner virtual HID daemon

## Install

```bash
sudo ./kanata/os/macos/install.sh
```

Then grant the Kanata binary, e.g. `/usr/local/bin/kanata-cmd-allowed`, in macOS System Settings:

- `Privacy & Security -> Input Monitoring`
- `Privacy & Security -> Accessibility`

Recommended while Kanata is active:

- keep macOS input source on stock `U.S.`
- quit `Karabiner-Elements`

## Operations

Restart services:

```bash
sudo launchctl kickstart -k system/com.james.keyboard.karabiner-vhidmanager
sudo launchctl kickstart -k system/com.james.keyboard.karabiner-vhid
sudo launchctl kickstart -k system/com.james.keyboard.kanata
```

Stop Kanata:

```bash
sudo launchctl bootout system /Library/LaunchDaemons/com.james.keyboard.kanata.plist
```

Logs:

```bash
sudo tail -n 80 /Library/Logs/Kanata/kanata.stderr.log /Library/Logs/Kanata/kanata.stdout.log
```

## Windows

Not wired yet. When adding it:

- keep `main.kbd` as the shared base
- add explicit Windows-specific modifier/output aliases
- add Windows startup helpers only once the key behavior is confirmed
