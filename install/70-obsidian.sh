#!/usr/bin/env bash
# Configures obsidian-cli's default vault.
# Sourced by install.sh; not run standalone.

if ! command -v obsidian-cli &>/dev/null; then
	log_skip 'obsidian-cli not installed'
	return 0
fi

mkdir -p "$CONFIG_DIR/obsidian" || exit

vault_path=${OBSIDIAN_PATH%/}
if command -v sha256sum &>/dev/null; then
	vault_id=$(printf '%s' "$vault_path" | sha256sum | cut -c1-16)
else
	vault_id=$(printf '%s' "$vault_path" | shasum -a 256 | cut -c1-16)
fi

obsidian_json="$CONFIG_DIR/obsidian/obsidian.json"
if [[ ! -f $obsidian_json ]]; then
	log_run 'Obsidian config'
	cat >"$obsidian_json" <<EOF || exit
{
  "vaults": {
    "$vault_id": {
      "path": "$vault_path",
      "ts": 1729872000000,
      "open": true
    }
  }
}
EOF
else
	log_unchanged 'Obsidian config'
fi

if [[ -d $vault_path ]]; then
	vault_name=${vault_path##*/}
	if obsidian-cli set-default "$vault_name"; then
		log_ok "default vault: $vault_name"
	else
		log_note "obsidian-cli set-default $vault_name"
	fi
else
	log_skip "vault dir $(pretty_path "$vault_path")"
fi
