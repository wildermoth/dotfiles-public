# Install/update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. Must run after 01-zstyles.zsh (which configures z4h's
# behavior) and before every other core file (they assume z4h is ready).
z4h init || return
