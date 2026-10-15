# --- bat ---
if command -v bat >/dev/null; then
  [[ -f ~/.config/bat/themes/tokyonight_night.tmTheme ]] && export BAT_THEME=tokyonight_night
  alias cat='bat --paging=never'      # behaves like plain cat when piped
fi

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias dots='cd $DOTFILES'
mkcd() { mkdir -p "$1" && cd "$1" }

# --- Git ---
alias g='git'
alias gst='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpl='git pull'
alias gsw='git switch'
alias gl='git log --graph --oneline --decorate -20'
alias gla='git log --graph --oneline --decorate --all'
alias lg='lazygit'

# --- Helpers ---
alias reload='exec zsh'
alias path='print -l $path'           # PATH, one entry per line

extract() {
  local f
  for f in "$@"; do
    case $f in
      *.tar.gz|*.tgz) tar xzf "$f" ;;
      *.tar.xz)       tar xJf "$f" ;;
      *.tar.bz2)      tar xjf "$f" ;;
      *.tar)          tar xf  "$f" ;;
      *.zip)          unzip   "$f" ;;
      *.gz)           gunzip  "$f" ;;
      *.bz2)          bunzip2 "$f" ;;
      *.xz)           unxz    "$f" ;;
      *) echo "extract: don't know how to unpack '$f'" ;;
    esac
  done
}
