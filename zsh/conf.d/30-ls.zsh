command -v eza >/dev/null || return

# Turn a hex colour (e.g. 7aa2f7) into a terminal colour code
_rgb() { printf '38;2;%d;%d;%d' 0x${1:0:2} 0x${1:2:2} 0x${1:4:2} }
# Colour every listed extension with one hex colour
_paint() { local c=$(_rgb $1); shift; local e; for e in $@; do EZA_COLORS+="*.$e=$c:"; done }

EZA_COLORS="di=1;$(_rgb 7aa2f7):ex=$(_rgb 9ece6a):"           # folders: bold blue, executables: green
_paint e0af68 py ipynb                                         # Python: yellow
_paint bb9af7 f f90 F F90 for f77                              # Fortran: purple
_paint 7dcfff c cc cpp cxx h hh hpp                            # C/C++: light blue
_paint ff9e64 m wl nb                                          # Mathematica: orange
_paint 9ece6a md txt tex bib rst                               # text/docs: green
_paint 73daca sh zsh toml yaml yml json cfg ini                # scripts/config: teal
_paint f7768e pdf ps eps                                       # PDF/PS: pink-red
_paint db4b4b zip tar gz tgz xz bz2                            # archives: dark red
_paint 2ac3de png jpg jpeg svg gif                             # images: cyan
_paint b4f9f8 root dat csv h5 hdf5 lhe                         # data: pale cyan
_paint 565f89 log out err                                      # logs: grey
export EZA_COLORS
unfunction _rgb _paint

alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --git --group-directories-first'
alias la='eza -la --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'
