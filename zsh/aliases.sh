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
# `, <desc>`  — AI shell-command suggester (no need to quote ? * ~ etc.)
# `? <question>` — quick pi answer (uses the `q` script on PATH)
# `noglob` keeps zsh from glob-expanding things like ? and * in the args,
# and is a precommand modifier so it doesn't recurse into the alias.
alias ','='noglob ,'
alias '?'='noglob q'
