#!/usr/bin/env bash
# Renders config templates via generate_configs.sh.
# Sourced by install.sh; not run standalone.

"$DOTFILES_DIR/scripts/generate_configs.sh" || exit
