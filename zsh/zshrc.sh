ZSH_THEME="agnoster"
# Vars
	HISTFILE=~/.zsh_history
	SAVEHIST=1000 
	setopt inc_append_history # To save every command before it is executed 
	setopt share_history # setopt inc_append_history

	git config --global push.default current


# Aliases
	# mkdir -p /tmp/log
	
# Convert simplified wildcard pattern to regex and grep a file listing using
# Silver Searcher (`brew install the_silver_searcher`)
lsgrep ()
{
    NEEDLE="$(echo $@|sed -E 's/\.([a-z0-9]+)$/\\.\1/'|sed -E 's/\?/./'| sed -E 's/[ *]/.*?/g')";
	  ag -l --nocolor -g "$NEEDLE"
}
	# This is currently causing problems (fails when you run it anywhere that isn't a git project's root directory)
	# alias vs="v `git status --porcelain | sed -ne 's/^ M //p'`"

# Settings
	export VISUAL=vim

source ~/.dotfiles/zsh/plugins/fixls.zsh

#Functions
	# Loop a command and show the output in vim
	loop() {
		echo ":cq to quit\n" > /tmp/log/output 
		fc -ln -1 > /tmp/log/program
		while true; do
			cat /tmp/log/program >> /tmp/log/output ;
			$(cat /tmp/log/program) |& tee -a /tmp/log/output ;
			echo '\n' >> /tmp/log/output
			vim + /tmp/log/output || break;
			rm -rf /tmp/log/output
		done;
	}

 	# Custom cd
 	customcd() {
 		cd $1;
 		ls;
 	}
 	alias cd="customcd"

# For vim mappings: 
	stty -ixon

# Completions
# These are all the plugin options available: https://github.com/robbyrussell/oh-my-zsh/tree/291e96dcd034750fbe7473482508c08833b168e3/plugins
#
# Edit the array below, or relocate it to ~/.zshrc before anything is sourced
# For help create an issue at github.com/parth/dotfiles

autoload -U compinit

plugins=(
	docker
	git
  # nvm-auto
)

# This isn't actually working? Just gonna source them manually below :shrug:
# for plugin ($plugins); do
#   echo "$plugin"
#     fpath=(~/.dotfiles/zsh/plugins/oh-my-zsh/plugins/$plugin $fpath)
# done

compinit

source ~/.dotfiles/zsh/plugins/zsh-nvm/zsh-nvm.plugin.zsh
source ~/.dotfiles/zsh/plugins/nvm-auto/nvm-auto.plugin.zsh
source ~/.dotfiles/zsh/plugins/oh-my-zsh/lib/history.zsh
source ~/.dotfiles/zsh/plugins/oh-my-zsh/lib/key-bindings.zsh
source ~/.dotfiles/zsh/plugins/oh-my-zsh/lib/completion.zsh
source ~/.dotfiles/zsh/plugins/vi-mode.plugin.zsh
source ~/.dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.dotfiles/zsh/plugins/zsh-manydots-magic/manydots-magic
source ~/.dotfiles/zsh/keybindings.sh
source ~/.dotfiles/zsh/aliases.sh

# Fix for arrow-key searching
# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
	autoload -U up-line-or-beginning-search
	zle -N up-line-or-beginning-search
	bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
	autoload -U down-line-or-beginning-search
	zle -N down-line-or-beginning-search
	bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

source ~/.dotfiles/zsh/prompt.sh
# Composer
PATH=$PATH:$HOME/.composer/vendor/bin
PATH=$PATH:/usr/local/opt/rbenv/shims:/usr/local/sbin

PATH=$PATH:/Users/Joseph/.themekit

unset GEM_HOME

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Aliases

nvm_auto_switch

export PATH=$PATH:$HOME/.dotfiles/utils
export PATH=$PATH:$HOME/.dotfiles/bin

# ASDF

. $HOME/.asdf/asdf.sh
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit
compinit
