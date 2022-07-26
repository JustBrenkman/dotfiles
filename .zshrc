# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/justb/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$PATH:$HOME/repos/flutter-elinux/bin"
alias ls='ls --color=auto'

eval "$(starship init zsh)"

neofetch
