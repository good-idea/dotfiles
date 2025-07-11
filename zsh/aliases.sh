alias vi="nvim"
alias vim="nvim"
alias v="nvim -p"
alias :q="exit"
alias q="exit"
alias c="clear"
alias la="exa -abghl --git --color=automatic"
alias flushDNS="sudo killall -HUP mDNSResponder"
alias flushdns="sudo killall -HUP mDNSResponder"
alias y="yarn"
alias ys="yarn start"
alias lg="lazygit"
alias localip="ipconfig getifaddr en0"

yw() {
  yarn workspace $(yarn workspaces info --json | jq '.data' -r | jq "[keys][0] []" -r | fzf) $@
}
