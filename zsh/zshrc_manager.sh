time_out () { perl -e 'alarm shift; exec @ARGV' "$@"; }

# Run tmux if exists
if command -v tmux>/dev/null; then
	[ -z $TMUX ] && exec tmux attach
else 
	echo "tmux not installed. Run ./deploy to configure dependencies"
fi

# echo "Updating configuration"
# (cd ~/.dotfiles && git pull && git submodule update --init --recursive)
source ~/.dotfiles/zsh/zshrc.sh
