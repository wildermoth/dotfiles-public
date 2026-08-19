# Per-repo env vars: reads $XDG_CONFIG_HOME/git-envs/<repo>.env on cd.
# All worktrees of the same repo share the same file. Leave unsets those keys.
_git_env_current=""
_git_env_keys=()

function _unload_git_repo_env() {
  local k
  for k in "${_git_env_keys[@]}"; do
    unset "$k"
  done
  _git_env_keys=()
}

function _git_env_collect_keys() {
  local line name
  _git_env_keys=()
  while IFS= read -r line || [[ -n $line ]]; do
    [[ $line == \#* || -z ${line// /} ]] && continue
    line=${line#export }
    name=${line%%=*}
    name=${name%%[[:space:]]*}
    [[ $name == [A-Za-z_]* ]] && _git_env_keys+=("$name")
  done < "$1"
}

function _load_git_repo_env() {
  local common_dir repo_key env_file
  common_dir=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || {
    _unload_git_repo_env
    _git_env_current=""
    return
  }
  repo_key=$(basename "$(dirname "$common_dir")")
  [[ "$repo_key" == "$_git_env_current" ]] && return
  _unload_git_repo_env
  _git_env_current="$repo_key"
  env_file="${XDG_CONFIG_HOME:-$HOME/.config}/git-envs/${repo_key}.env"
  if [[ -f $env_file ]]; then
    _git_env_collect_keys "$env_file"
    source "$env_file"
  fi
}

add-zsh-hook chpwd _load_git_repo_env
_load_git_repo_env
