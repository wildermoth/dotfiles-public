#!/usr/bin/env bash
# Installs system/tooling dependencies.
# Sourced by install.sh; not run standalone.

brew_url='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

source_brew_shellenv() {
	local brew_bin=$1
	local env_file
	env_file=$(mktemp) || exit
	"$brew_bin" shellenv >"$env_file" || exit
	source "$env_file" || exit
	rm -f "$env_file"
}

if is_termux; then
	log_skip 'Homebrew (Termux uses pkg)'
elif command -v brew &>/dev/null; then
	log_unchanged 'Homebrew'
else
	log_run 'Homebrew'
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL "$brew_url")" ||
		exit

	if is_macos && [[ -x /opt/homebrew/bin/brew ]]; then
		source_brew_shellenv /opt/homebrew/bin/brew
	elif is_macos && [[ -x /usr/local/bin/brew ]]; then
		source_brew_shellenv /usr/local/bin/brew
	elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
		source_brew_shellenv /home/linuxbrew/.linuxbrew/bin/brew
	fi
fi

# brew_pkg bin formula [extra brew args...]
brew_pkg() {
	local bin=$1
	local formula=$2
	shift 2
	if command -v "$bin" &>/dev/null; then
		log_unchanged "$bin"
	elif command -v brew &>/dev/null; then
		log_run "$formula"
		brew install "$formula" "$@" || exit
	else
		log_skip "$bin (needs Homebrew)"
	fi
}

brew_pkg nvim neovim
brew_pkg tmux tmux
if is_macos; then
	brew_pkg alacritty alacritty
	brew_pkg kanata kanata
fi
brew_pkg delta git-delta
brew_pkg lazygit lazygit
brew_pkg rg ripgrep
brew_pkg fzf fzf

# nvim-treesitter main requires the parser generator on macOS and Linux/WSL.
brew_pkg tree-sitter tree-sitter-cli

# apt fallback for tmux only. Never alacritty here: WSL uses Windows Alacritty.
if command -v apt &>/dev/null; then
	if command -v tmux &>/dev/null; then
		log_unchanged 'tmux'
	else
		log_run 'apt: tmux'
		sudo apt update || exit
		sudo apt install -y tmux || exit
	fi
else
	log_skip 'apt'
fi

if command -v obsidian-cli &>/dev/null; then
	log_unchanged 'obsidian-cli'
elif command -v brew &>/dev/null; then
	log_run 'obsidian-cli'
	brew tap yakitrak/yakitrak 2>/dev/null || true
	brew install yakitrak/yakitrak/obsidian-cli || exit
else
	log_warn 'Homebrew not found; skip obsidian-cli'
	log_note 'brew install yakitrak/yakitrak/obsidian-cli'
fi

if command -v uv &>/dev/null; then
	log_unchanged 'uv'
elif command -v brew &>/dev/null; then
	log_run 'uv'
	brew install uv || exit
else
	log_warn 'Homebrew not found; skip uv'
	log_note 'brew install uv'
fi

okf_repo='git+https://github.com/wildermoth/okf.git'
if command -v uv &>/dev/null; then
	okf_output=$(uv tool install "$okf_repo" 2>&1) || exit
	if [[ $okf_output == *'Checked '* ]]; then
		log_unchanged 'okf'
	else
		log_run 'okf (updated from GitHub)'
		printf '%s\n' "$okf_output"
	fi
else
	log_warn 'uv not found; skip okf'
	log_note "uv tool install $okf_repo"
fi

if command -v rustc &>/dev/null; then
	log_unchanged 'Rust'
else
	log_run 'Rust (rustup)'
	curl -sSf https://sh.rustup.rs | sh -s -- -y || exit
	if [[ -f $HOME/.cargo/env ]]; then
		source "$HOME/.cargo/env"
	fi
fi

atuin_version='18.12.1'

if ! command -v cargo &>/dev/null; then
	log_warn 'cargo not found; skip atuin'
elif command -v atuin &>/dev/null; then
	installed_atuin_version=$(atuin --version 2>/dev/null)
	# "atuin 18.12.1 ()" -> 18.12.1 (second word, not last)
	installed_atuin_version=${installed_atuin_version#* }
	installed_atuin_version=${installed_atuin_version%% *}
	if [[ $installed_atuin_version == "$atuin_version" ]]; then
		log_unchanged "atuin $atuin_version"
	else
		was=${installed_atuin_version:-unknown}
		log_run "atuin $atuin_version (was $was)"
		cargo install --locked --force atuin --version "$atuin_version" ||
			exit
	fi
else
	log_run "atuin $atuin_version"
	cargo install --locked atuin --version "$atuin_version" || exit
fi

if command -v fnm &>/dev/null; then
	log_unchanged 'fnm'
else
	log_run 'fnm'
	curl -fsSL https://fnm.vercel.app/install | bash -s -- \
		--install-dir "$HOME/.local/share/fnm" --skip-shell || exit
fi
