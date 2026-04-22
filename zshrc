if [[ "$(uname)" == "Darwin" ]]; then
  # Homebrew (Apple Silicon first, fall back to Intel)
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  # History
  HISTFILE=~/.zsh_history
  HISTSIZE=10000
  SAVEHIST=10000
  setopt appendhistory sharehistory incappendhistory histignorealldups

  # Completions
  autoload -Uz compinit && compinit

  # Starship prompt
  if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
  fi

  # fzf
  source <(fzf --zsh)

elif [[ "$(uname)" == "Linux" ]]; then
  USE_POWERLINE="true"
  HAS_WIDECHARS="false"
  export QT_QPA_PLATFORMTHEME=qt5ct

  if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
    source /usr/share/zsh/manjaro-zsh-config
  fi
  if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
    source /usr/share/zsh/manjaro-zsh-prompt
  fi

  source <(fzf --zsh)
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

alias vim=nvim
alias cat=bat
alias ls=eza
alias man=tldr
alias top=bottom
export PATH="$HOME/.local/bin:$PATH"
