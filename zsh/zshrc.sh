source /opt/homebrew/share/antigen/antigen.zsh
# General Config
ZSH_THEME="agnoster"
HISTFILE=~/.zsh_history
SAVEHIST=1000
setopt inc_append_history # To save every command before it is executed
setopt share_history # setopt inc_append_history

git config --global push.default current


# XCode & Android Studio

export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Ruby

export PATH=$PATH:$HOME/.gem/ruby/3.0.0/bin


# Settings
export VISUAL=vim


# # For vim mappings:
# 	stty -ixon


# plugins from oh-my-zsh
antigen bundle cp # use rsync for cp commands
antigen bundle git
antigen bundle tmux
antigen bundle docker
antigen bundle history
antigen bundle key-bindings
antigen bundle completion

# other plugins
# zplug "jeffreytse/zsh-vi-mode"
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle knu/zsh-manydots-magic

antigen apply


# Custom keybindings and aliases
source ~/.dotfiles/zsh/keybindings.sh
source ~/.dotfiles/zsh/aliases.sh
source ~/.dotfiles/zsh/prompt.sh

KEYTIMEOUT=1
bindkey -v

# Plugin configuration
# if zplug check zsh-users/zsh-history-substring-search; then
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
# fi
autoload -Uz manydots-magic
manydots-magic

# Aliases

export PATH=$PATH:$HOME/.dotfiles/utils
export PATH=$PATH:$HOME/.dotfiles/bin

# ASDF
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
# autoload -Uz compinit
# compinit
