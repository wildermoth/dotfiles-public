# Dotfiles

Personal config. Install and templates target macOS and WSL only.

Needs Neovim 0.11+ (`winborder`, `pumborder`, `vim.lsp.config`).

- `alacritty`
- `zsh`
- `nvim`
- `tmux`
- `lazygit`
- `git`
- `atuin`
- `keyboard`

## Commands

- `./install.sh` installs dependencies, regenerates templates, and refreshes symlinks.
- `./scripts/generate_configs.sh` regenerates template-backed config outputs.
- `./scripts/sync-windows.sh` syncs Windows Alacritty and AHK files from WSL.
- `./tests/run.sh` runs tests.
