#!/usr/bin/env bash
# Switch to a FlashSpace workspace; cycle windows if already active.
# Usage: switch_window.sh "Workspace Name"
workspace=$1
fs=/opt/homebrew/bin/flashspace
current=$($fs get-workspace 2>/dev/null | tr -d '\n')
if [[ $current == "$workspace" ]]; then
	$fs focus --next-window
else
	$fs workspace --name "$workspace"
fi
