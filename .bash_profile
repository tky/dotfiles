if [ -f ~/.bashrc ]; then
      . ~/.bashrc   # --> Read /etc/bashrc, if present.
  fi

  alias ll='ls -l'
  alias up='cd ../;ll'
  export SVN_EDITOR=vi




#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
#[[ -s "/Users/t-murata/.gvm/bin/gvm-init.sh" ]] && source "/Users/t-murata/.gvm/bin/gvm-init.sh"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
