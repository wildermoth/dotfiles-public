# tssh: SSH in a new Alacritty window. Host from $TSSH_HOST or argv.
tssh() {
  emulate -L zsh
  setopt local_options no_sh_word_split

  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    cat <<'EOF'
Usage: tssh [host]

  Opens a new Alacritty window and runs ssh, then exec zsh so the
  window stays up after ssh exits. SKIP_TMUX=1 so only remote tmux runs.

  Default host is $TSSH_HOST (set in ~/.env.zsh). Prefer a Tailscale
  MagicDNS name from `tailscale status` over a 100.x IP. User is
  $TSSH_USER if set, else $USER.

Examples:
  tssh
  tssh some-node
EOF
    return 0
  fi

  local host="${1:-$TSSH_HOST}"
  local user="${TSSH_USER:-$USER}"

  if [[ -z "$host" ]]; then
    echo "tssh: set TSSH_HOST in ~/.env.zsh or pass a host" >&2
    return 1
  fi

  local alacritty="/Applications/Alacritty.app/Contents/MacOS/alacritty"
  if [[ ! -x "$alacritty" ]]; then
    echo "tssh: Alacritty not found at $alacritty" >&2
    return 1
  fi

  local target="${user}@${host}"

  # open -na starts a new instance. env SKIP_TMUX must be set before zsh
  # reads zshrc. Host and user go in $1/$2 so they are not interpolated
  # into the -c string.
  open -na Alacritty --args \
    --title "tssh: ${target}" \
    -e /usr/bin/env SKIP_TMUX=1 zsh -i -c 'ssh -- "$1@$2"; exec zsh' \
    zsh "$user" "$host"
}
