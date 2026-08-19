# Load order-independent standalone features.
for custom_zsh in "$DOTFILES_DIR/configs/zsh/modules"/*.zsh(N); do
  source "$custom_zsh"
done
unset custom_zsh
