# Case-insensitive globbing: *.pdf also matches .PDF
setopt EXTENDED_GLOB NO_CASE_GLOB

# Resolve a name to a directory: exact, case-insensitive here, ~named dir, then zoxide
_smartdir() {
  local n=$1; local -a m
  [[ -d $n ]] && { REPLY=$n; return 0 }
  m=( (#i)${~${(b)n}}(N/) )
  (( $#m == 1 )) && { REPLY=$m[1]; return 0 }
  [[ -n ${nameddirs[$n]} ]] && { REPLY=${nameddirs[$n]}; return 0 }
  (( $+commands[zoxide] )) && REPLY=$(zoxide query -- "$n" 2>/dev/null) && return 0
  return 1
}

# On Enter: "name" or "cd name" that isn't a command/folder -> cd to the best match
_smartcd_accept() {
  local -a w=( ${(z)BUFFER} )
  if (( $#w == 1 )) && ! whence -- "$w[1]" >/dev/null && _smartdir "${(Q)w[1]}"; then
    BUFFER="cd ${(q-)REPLY}"
  elif (( $#w == 2 )) && [[ $w[1] == cd && $w[2] != [-~+]* && ! -d ${(Q)w[2]} ]] \
       && _smartdir "${(Q)w[2]}"; then
    BUFFER="cd ${(q-)REPLY}"
  fi
  zle .accept-line
}
zle -N accept-line _smartcd_accept
