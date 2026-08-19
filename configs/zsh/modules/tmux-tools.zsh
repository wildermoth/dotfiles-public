# Ctrl+S: fuzzy-pick a tool from fzf-tools in a tmux popup.
_fzf_menu_widget() {
  [[ -n $TMUX ]] || return 0
  tmux display-popup -E -w 90% -h 80% \
    "${FZF_TOOLS_DIR:-$HOME/fzf-tools}/bin/fzf-menu"
  zle reset-prompt
}
zle -N _fzf_menu_widget
bindkey '^s' _fzf_menu_widget
