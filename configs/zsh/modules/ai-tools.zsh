# fnm harness wrappers: pin these to fnm's default node version.
alias gemini='fnm exec --using=default -- gemini'
alias pi='fnm exec --using=default -- pi'
alias codex='fnm exec --using=default -- codex'

# Claude Code thinking level
export CLAUDE_CODE_EFFORT_LEVEL=max
export CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1
