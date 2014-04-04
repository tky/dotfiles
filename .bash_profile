if [ -f ~/.bashrc ]; then
      . ~/.bashrc   # --> Read /etc/bashrc, if present.
  fi

  alias ll='ls -l'
  alias up='cd ../;ll'
  export SVN_EDITOR=vi

export PATH=/usr/local/bin:$PATH


[[ -s "$HOME/.nvm/nvm.sh" ]] && . "$HOME/.nvm/nvm.sh"

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
#[[ -s "/Users/t-murata/.gvm/bin/gvm-init.sh" ]] && source "/Users/t-murata/.gvm/bin/gvm-init.sh"
eval "$(rbenv init -)"
