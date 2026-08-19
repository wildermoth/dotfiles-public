# Wrap `gerrit` so a `.cd-next` file from the CLI cds the shell after the command.
gerrit() {
  command gerrit "$@"
  local code=$?
  local cd_file="${XDG_CONFIG_HOME:-$HOME/.config}/gerrit/.cd-next"
  if [[ -f "$cd_file" ]]; then
    local dest=$(<"$cd_file")
    rm -f "$cd_file"
    [[ -n "$dest" ]] && builtin cd -- "$dest"
  fi
  return $code
}
