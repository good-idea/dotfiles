precmd() {
  if [ -n "$TMUX" ]; then
    eval "$(tmux show-environment -s)"
    eval "$($HOME/.tmux/plugins/tmux-continuum/scripts/continuum_save.sh)"
  fi

  history -a
}

PROMPT_COMMAND=precmd
