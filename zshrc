# Use powerline
USE_POWERLINE="true"
# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

alias vim=nvim
alias cat=bat
alias ls=eza
alias man=tldr
alias top=bottom

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
