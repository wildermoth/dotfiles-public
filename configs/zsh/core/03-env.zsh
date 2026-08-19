# PATH
path=(~/bin $path)
export PATH="$HOME/.local/bin:/usr/local/bin:$DOTFILES_DIR/scripts:$PATH"
[[ -d "$HOME/.opencode/bin" ]] && export PATH="$HOME/.opencode/bin:$PATH"

# Core environment
export GPG_TTY=$TTY
export EDITOR='nvim'
export PAGER='nvim -R -'
export MANPAGER='nvim +Man!'
unset GIT_PAGER
# Shared dirs. Override in the environment or ~/.env.zsh.
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
export DOTFILES_AI_DIR="${DOTFILES_AI_DIR:-$HOME/dotfiles-ai}"
export OBSIDIAN_PATH="${OBSIDIAN_PATH:-$HOME/obsidian}"
export FZF_TOOLS_DIR="${FZF_TOOLS_DIR:-$HOME/fzf-tools}"

# Source env. See env.zsh.example
z4h source ~/.env.zsh
