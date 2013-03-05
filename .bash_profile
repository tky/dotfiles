if [ -f ~/.bashrc ]; then
  . ~/.bashrc   # --> Read /etc/bashrc, if present.
fi

alias ll='ls -al'
alias up='cd ../;ll'

export JAVA_HOME=/usr/bin/java

##########################
# add Scala env.
##########################
SCALA_HOME=/usr/local/bin/scala
export SCALA_HOME
export PATH=$PATH:$SCALA_HOME/bin

export ANT_HOME=/usr/local/apache-ant-1.8.4
export PATH=$PATH:$ANT_HOME/bin

export SVN_EDITOR=vi
