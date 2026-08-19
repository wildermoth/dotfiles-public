# Powerlevel10k instant prompt compatibility. Must run last: needs all
# console-output-producing setup, including modules/, to have already run.
unsetopt prompt_cr
(( ! ${+functions[p10k]} )) || p10k finalize
