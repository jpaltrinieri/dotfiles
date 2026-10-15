#!/bin/bash
# Install CLI tools into ~/.local/bin from GitHub releases (Linux x86_64, no root needed)
set -u
BIN=~/.local/bin; mkdir -p "$BIN"

latest() {  # repo, asset regex -> download URL of latest release
  curl -s "https://api.github.com/repos/$1/releases/latest" \
    | grep -o '"browser_download_url": *"[^"]*"' | cut -d'"' -f4 | grep -E "$2" | head -1
}
get() {     # repo, asset regex, binary name
  local url tmp f
  url=$(latest "$1" "$2")
  [ -z "$url" ] && { echo "!! $3: no matching download found"; return; }
  tmp=$(mktemp -d)
  curl -sL "$url" -o "$tmp/pkg" && tar -xf "$tmp/pkg" -C "$tmp"
  f=$(find "$tmp" -type f -name "$3" | head -1)
  [ -n "$f" ] && install -m 755 "$f" "$BIN/" && echo "ok  $3" || echo "!! $3: install failed"
  rm -rf "$tmp"
}

M='x86_64-unknown-linux-musl\.tar\.gz$'
get starship/starship      "$M"                       starship
get ajeetdsouza/zoxide     "$M"                       zoxide
get junegunn/fzf           'linux_amd64\.tar\.gz$'    fzf
get eza-community/eza      "eza_$M"                   eza
get sharkdp/bat            "$M"                       bat
get BurntSushi/ripgrep     "$M"                       rg
get sharkdp/fd             "$M"                       fd
get dandavison/delta       "$M"                       delta
get jesseduffield/lazygit  '[Ll]inux_x86_64\.tar\.gz$' lazygit
get aristocratos/btop      'x86_64-linux-musl\.tbz$'  btop
get tldr-pages/tlrc        "$M"                       tldr

# zsh plugins
P=~/.local/share/zsh/plugins; mkdir -p "$P"
for r in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting; do
  d="$P/${r#*/}"
  [ -d "$d" ] && git -C "$d" pull -q || git clone -q "https://github.com/$r" "$d"
  echo "ok  ${r#*/}"
done

# iTerm2 integration + utilities
curl -sL https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh && echo "ok  iterm2 integration"
for u in imgcat it2dl it2ul; do
  curl -sL "https://iterm2.com/utilities/$u" -o "$BIN/$u" && chmod +x "$BIN/$u" && echo "ok  $u"
done

# Tokyo Night theme for bat
mkdir -p ~/.config/bat/themes
curl -sL https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme \
  -o ~/.config/bat/themes/tokyonight_night.tmTheme && "$BIN/bat" cache --build >/dev/null && echo "ok  bat theme"
