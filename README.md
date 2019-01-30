## install macvim with lua, python. set for system vim.
```
brew install macvim --with-override-system-vim --with-luajit --with-lua --with-python --with-python3
```

## install other libraries
### peco
```
brew install peco
```

## zplug
```
$ export ZPLUG_HOME=~/.zplug
$ git clone https://github.com/zplug/zplug $ZPLUG_HOME
```

## Quick Start
1. git Setup:

    ``` 
    $ git init
    $ git remote add origin https://github.com/taka-/dotfiles
    $ git pull origin master
    ``` 

2. Neobundle Setup:

    ``` 
    $ mkdir -p ~/.vim/bundle
    $ git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
    ``` 
    


