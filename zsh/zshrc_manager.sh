time_out () { perl -e 'alarm shift; exec @ARGV' "$@"; }

if [ "$TMUX" = "" ]; then exec tmux; fi

source ~/.dotfiles/zsh/zshrc.sh
