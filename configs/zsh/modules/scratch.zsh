# vt [ext]: open a scratch file in nvim (default .txt).
vt() {
  local tmp="$(mktemp)"
  mv "$tmp" "$tmp.${1:-txt}"
  nvim "$tmp.${1:-txt}"
}
