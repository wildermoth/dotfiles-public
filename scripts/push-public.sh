#!/usr/bin/env bash
# Snapshot HEAD as a parentless commit and force-push to the public GitHub
# repo. Private history is not sent.

set -uo pipefail

DOTFILES_DIR=${DOTFILES_DIR:-$HOME/dotfiles}
export DOTFILES_DIR

source "$DOTFILES_DIR/install/lib.sh" || exit

PUBLIC_REMOTE="${PUBLIC_REMOTE:-public}"
PUBLIC_URL="${PUBLIC_URL:-https://github.com/wildermoth/dotfiles-public.git}"
PUBLIC_BRANCH="${PUBLIC_BRANCH:-main}"

usage() {
	cat <<'EOF'
Usage: push-public.sh [--dry-run]

Snapshot the current HEAD tree as a parentless commit and force-push
it to the public GitHub repo. Private history is not sent.

The commit message is a local datetime.
Refuses to push if HEAD matches a /Users/<name>/ home path or a
PEM private key.

Environment:
  PUBLIC_REMOTE  remote name (default: public)
  PUBLIC_URL     remote URL
  PUBLIC_BRANCH  branch to force-push (default: main)
EOF
}

dry_run=0
for arg in "$@"; do
	case $arg in
	--dry-run)
		dry_run=1
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		log_warn "unknown argument: $arg"
		usage >&2
		exit 1
		;;
	esac
done

git_c() {
	git -C "$DOTFILES_DIR" "$@"
}

if ! git_c rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	log_warn "$(pretty_path "$DOTFILES_DIR") is not a git repo"
	exit 1
fi

if [[ -n $(git_c status --porcelain) ]]; then
	log_warn 'working tree dirty; snapshot is HEAD only'
fi

msg=$(date '+%Y-%m-%dT%H:%M:%S%z')
tree=$(git_c rev-parse 'HEAD^{tree}') || exit

log_section 'public snapshot'
log_note "tree $tree"
log_note "message $msg"
log_note "remote $PUBLIC_REMOTE ($PUBLIC_URL)"
log_note "branch $PUBLIC_BRANCH"

leaks=$(git_c grep -nI -E \
	'/Users/[A-Za-z0-9._-]+/|BEGIN [A-Z ]*PRIVATE KEY' HEAD || true)
if [[ -n $leaks ]]; then
	printf '%s\n' "$leaks"
	log_warn 'refusing push: leak pattern in HEAD'
	exit 1
fi

if ((dry_run == 1)); then
	log_skip 'push (--dry-run)'
	exit 0
fi

if git_c remote get-url "$PUBLIC_REMOTE" >/dev/null 2>&1; then
	url=$(git_c remote get-url "$PUBLIC_REMOTE")
	if [[ $url != "$PUBLIC_URL" ]]; then
		log_warn "remote $PUBLIC_REMOTE is $url, expected $PUBLIC_URL"
		exit 1
	fi
else
	git_c remote add "$PUBLIC_REMOTE" "$PUBLIC_URL" || exit
	log_ok "added remote $PUBLIC_REMOTE"
fi

commit=$(git_c commit-tree "$tree" -m "$msg") || exit
log_ok "orphan commit $commit"

git_c push --force "$PUBLIC_REMOTE" \
	"$commit:refs/heads/$PUBLIC_BRANCH" || exit
log_ok "pushed to $PUBLIC_REMOTE $PUBLIC_BRANCH"
