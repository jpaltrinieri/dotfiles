# iTerm2 shell integration (prompt marks, imgcat/it2dl support, per-host profiles)
[[ -r ~/.iterm2_shell_integration.zsh ]] && source ~/.iterm2_shell_integration.zsh

# Notify when a command takes >= 30 s
zmodload zsh/datetime
typeset -g _nt_start=0 _nt_cmd=""
_nt_preexec() { _nt_start=$EPOCHSECONDS; _nt_cmd=$1 }
_nt_precmd() {
  local st=$?
  (( _nt_start )) || return 0
  local dt=$(( EPOCHSECONDS - _nt_start )); _nt_start=0
  case ${_nt_cmd%% *} in vim|nvim|less|man|ssh|btop|lazygit|lg|tmux|bat|zi) return 0 ;; esac
  (( dt >= 30 )) && printf '\e]9;%s\a' "${_nt_cmd:0:40} — done in ${dt}s (exit $st)"
  return 0
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec _nt_preexec
precmd_functions=(_nt_precmd $precmd_functions)   # run first, to catch the real exit code
