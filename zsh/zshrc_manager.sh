time_out () { perl -e 'alarm shift; exec @ARGV' "$@"; }

if [ "$TMUX" = "" ]; then exec tmux attach-session; fi

source ~/.dotfiles/zsh/zshrc.sh
