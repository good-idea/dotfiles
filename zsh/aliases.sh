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
alias whatsize="du -h -d 1 . | sort -hr"
# Kill processes matched by pgrep or using a port and report each result. Unlike
# macOS's built-in `pkill`, this leaves `pkill` unchanged and always prints
# feedback. A sole numeric target or :<port> targets that port; all other
# targets are passed to pgrep.
# Usage: ppkill [-SIGNAL] [pgrep options] pattern | <port> | :<port>
ppkill() {
  local -a pgrep_args
  local arg matches line pid process signal=TERM query_status noun port
  local -i index=1 killed=0 failed=0

  # A leading signal (for example -KILL, -SIGTERM, or -9) is a pkill-style
  # convenience. Everything else is passed to pgrep for matching.
  if (( $# > 0 )) && [[ $1 == -* ]] && kill -l "${1#-}" &>/dev/null; then
    signal=${1#-}
    index=2
  fi

  for (( ; index <= $#; index++ )); do
    arg=${@[index]}
    # `-I` belongs to pkill; ppkill intentionally does not prompt per PID.
    [[ $arg == -I ]] && continue
    pgrep_args+=("$arg")
  done

  # A standalone port target is resolved through lsof; keep pgrep options and
  # all other patterns behaving exactly as before.
  if (( ${#pgrep_args[@]} == 1 )) && [[ ${pgrep_args[1]} == (<->|:<->) ]]; then
    port=${pgrep_args[1]#:}
    if (( port < 1 || port > 65535 )); then
      print -u2 -r -- "ppkill: invalid port: $port"
      return 2
    fi
    matches=$(command lsof -nP -ti ":$port" 2>/dev/null)
  else
    matches=$(command pgrep -l "${pgrep_args[@]}" 2>/dev/null)
  fi
  query_status=$?
  if (( query_status != 0 )); then
    if (( query_status == 1 )); then
      print -u2 -r -- "ppkill: no matching processes"
    else
      print -u2 -r -- "ppkill: could not find processes (exit status $query_status)"
    fi
    return $query_status
  fi

  while IFS= read -r line; do
    if [[ -n $port ]]; then
      pid=$line
      process=$(command ps -p "$pid" -o comm= 2>/dev/null)
      [[ -n $process ]] || process='<exited>'
    else
      pid=${line%% *}
      process=${line#* }
    fi
    if command kill -s "$signal" "$pid"; then
      print -r -- "ppkill: sent SIG${signal} to $pid $process"
      (( killed++ ))
    else
      print -u2 -r -- "ppkill: failed to signal $pid $process"
      (( failed++ ))
    fi
  done <<< "$matches"

  if (( failed > 0 )); then
    print -u2 -r -- "ppkill: failed ($killed succeeded, $failed failed)"
    return 1
  fi

  noun=process
  (( killed != 1 )) && noun=processes
  print -r -- "ppkill: success ($killed $noun signalled)"
}

# Show the processes currently using a TCP or UDP port.
# Usage: plist 3000
plist() {
  local port=$1 output result

  if (( $# != 1 )) || [[ ! $port == <-> ]] || (( port < 1 || port > 65535 )); then
    print -u2 -r -- "Usage: plist <port (1-65535)>"
    return 2
  fi

  output=$(command lsof -nP -i ":$port" 2>/dev/null)
  result=$?
  if (( result == 0 )); then
    print -r -- "Processes using port $port:"
    print -r -- "$output"
  elif (( result == 1 )); then
    print -r -- "plist: no processes are using port $port"
  else
    print -u2 -r -- "plist: could not inspect port $port (exit status $result)"
  fi

  return $result
}

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
