# Add user-installed pip3 scripts to PATH. Cache by sys.prefix so a
# version bump misses the old file and recomputes.
if command -v python3 &>/dev/null; then
  _py_prefix=$(python3 -c 'import sys; print(sys.prefix)' 2>/dev/null) || _py_prefix=
  if [[ -n $_py_prefix ]]; then
    _py_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
    _py_cache="$_py_cache_dir/python-scripts-${_py_prefix//\//_}"
    if [[ ! -f $_py_cache ]]; then
      mkdir -p "$_py_cache_dir"
      python3 -c 'import sysconfig; print(sysconfig.get_path("scripts"))' >"$_py_cache"
    fi
    export PATH="$(<"$_py_cache"):$PATH"
  fi
  unset _py_prefix _py_cache_dir _py_cache
fi
alias python=python3
