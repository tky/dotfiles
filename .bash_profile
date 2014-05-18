if [ -f ~/.bashrc ]; then
      . ~/.bashrc   # --> Read /etc/bashrc, if present.
  fi

  alias ll='ls -l'
  alias up='cd ../;ll'
  export SVN_EDITOR=vi

export PATH=/usr/local/bin:$PATH


[[ -s "$HOME/.nvm/nvm.sh" ]] && . "$HOME/.nvm/nvm.sh"

[ -s ${HOME}/.rvm/scripts/rvm ] && source ${HOME}/.rvm/scripts/rvm
