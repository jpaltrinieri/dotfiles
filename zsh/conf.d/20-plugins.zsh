_load_plugin() {
  local f
  for f in ${HOMEBREW_PREFIX:-/opt/homebrew}/share/$1/$1.zsh \
           $HOME/.local/share/zsh/plugins/$1/$1.zsh; do
    [[ -r $f ]] && { source $f; return }
  done
}

# fzf: Ctrl-R history, Ctrl-T files, Alt-C dirs (Tokyo Night colours)
if command -v fzf >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border \
    --color=fg:#c0caf5,bg:-1,hl:#ff9e64,fg+:#c0caf5,bg+:#283457,hl+:#ff9e64 \
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#bb9af7,marker:#9ece6a,spinner:#9ece6a,header:#565f89"
  source <(fzf --zsh)
fi

command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

if command -v starship >/dev/null; then
  export STARSHIP_CONFIG=$DOTFILES/starship.toml
  eval "$(starship init zsh)"
fi

_load_plugin zsh-autosuggestions
_load_plugin zsh-syntax-highlighting   # must be loaded last
