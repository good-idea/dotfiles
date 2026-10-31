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
# Start pi from the nearest project root.
# A project root contains .pi, .agents, or .git (but ~/.pi itself is not one).
pi() {
  local dir=$PWD
  local pi_home=$HOME/.pi

  while true; do
    # Do not let ~/.pi, or its parent $HOME (which contains ~/.pi), act as a root.
    [[ "$dir" == "$pi_home" ]] && break

    if [[ "$dir" != "$HOME" && ( -d "$dir/.pi" || -d "$dir/.agents" || -d "$dir/.git" ) ]]; then
      cd -- "$dir" || return

      # Match Pi's initial theme to tmux's workspace theme. `--use-theme`
      # affects only this invocation, so Pi's saved preference stays untouched.
      local pi_theme
      if [[ -n ${TMUX:-} ]]; then
        case "$(tmux show-option -gv @dotfiles_theme 2>/dev/null)" in
          light) pi_theme="kanagawa-lotus" ;;
          dark) pi_theme="dark" ;;
        esac
      fi

      if [[ -n ${pi_theme:-} ]]; then
        ASDF_NODEJS_VERSION=24.16.0 command pi --use-theme "$pi_theme" "$@"
      else
        ASDF_NODEJS_VERSION=24.16.0 command pi "$@"
      fi
      return
    fi

    [[ "$dir" == / ]] && break
    dir=${dir:h}
  done

  print -u2 "pi: no project root found from $PWD"
  return 1
}

# `, <desc>`  — AI shell-command suggester (no need to quote ? * ~ etc.)
# `? <question>` — quick pi answer (uses the `q` script on PATH)
# `noglob` keeps zsh from glob-expanding things like ? and * in the args,
# and is a precommand modifier so it doesn't recurse into the alias.
alias ','='noglob ,'
alias '?'='noglob q'
