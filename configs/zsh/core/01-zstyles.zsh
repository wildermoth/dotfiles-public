# z4h behavior settings. Must be sourced before `z4h init` (02-z4h-init.zsh).
zstyle ':z4h:' auto-update 'no' # Run `z4h update` to update.
zstyle ':z4h:bindkey' keyboard  'pc' # Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:' prompt-at-bottom 'no'
zstyle ':z4h:' term-shell-integration 'yes' # Mark up shell
zstyle ':z4h:autosuggestions' forward-char 'accept'
zstyle ':z4h:fzf-complete' recurse-dirs 'no' # Recurse on tab completions
zstyle ':z4h:ssh:*' enable 'yes' # SSH Teleportation
zstyle ':z4h:ssh-agent:' start yes # Start SSH if not running

# Start tmux on launch unless SKIP_TMUX is set.
[[ -z "$SKIP_TMUX" ]] &&
  zstyle ':z4h:' start-tmux command tmux -u new-session -A -D -s root -c "$HOME"
