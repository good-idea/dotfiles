source /opt/homebrew/share/antigen/antigen.zsh
# General Config
ZSH_THEME="agnoster"
HISTFILE=~/.zsh_history
SAVEHIST=1000
setopt inc_append_history # To save every command before it is executed
setopt share_history # setopt inc_append_history


# git
git config --global push.default current

# Expo made me add this
export LANG=en_US.UTF-8

# XCode, Java & Android Studio
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export JAVA_HOME_11=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Rust
export PATH=$HOME/.cargo/bin:$PATH

# Ghostty CLI
export PATH=$PATH:/Applications/Ghostty.app/Contents/MacOS

# Python
export PATH=$Home/.local/bin:$PATH

# PHP
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
# Ruby
export PATH=$PATH:$HOME/.gem/ruby/3.0.0/bin

# opencode
export PATH=/Users/joseph/.opencode/bin:$PATH


# Settings
export VISUAL="nvim"
export EDITOR="nvim"


# # For vim mappings:
# 	stty -ixon


# plugins from oh-my-zsh
antigen bundle cp # use rsync for cp commands
antigen bundle git
antigen bundle docker
antigen bundle history
antigen bundle key-bindings
antigen bundle completion

# other plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle knu/zsh-manydots-magic

antigen apply

# autoload -U edit-command-line
# zle -N edit-command-line
# # bindkey -M vicmd v edit-command-line
# bindkey '^Xe' edit-command-line
# <Ctrl-x><Ctrl-e> to edit command-line in EDITOR
# autoload -Uz edit-command-line
# zle -N edit-command-line
# # bindkey "${key_info[Control]}x${key_info[Control]}e" edit-command-line
# bindkey "${key_info[Control]}x" edit-command-line
# # bindkey "${key_info[Control]}e" echo "foo"
# edit-command-line


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

# ASDF
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
# Custom commands (including the pinned pi wrapper) must precede asdf shims.
export PATH="$HOME/.dotfiles/bin:$PATH"
# append completions to fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# Environtmenv Variables
eval "$(direnv hook zsh)"

# Zoxide - smarter cd command (replaces cd)
# Usage: cd <partial-path> jumps to best match, cdi for interactive picker
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# initialise completions with ZSH's compinit
# autoload -Uz compinit
# compinit
