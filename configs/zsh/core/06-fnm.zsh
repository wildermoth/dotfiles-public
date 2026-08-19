# fnm (must be sourced after OS-specific config so it wins over brew's node)
FNM_PATH="$HOME/.local/share/fnm"
[ -d "$FNM_PATH" ] && export PATH="$FNM_PATH:$PATH"
if command -v fnm &>/dev/null; then
  export FNM_LOGLEVEL="quiet"
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
