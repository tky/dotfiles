## install other libraries

```
$ brew install peco
$ brew install pyenv
$ brew install node
```

```
$ npm install --global yarn
```


Install python 

```
$ pyenv install {LATEST VERSION}
$ pyenv global {INSTALLED VERSION}
```


$ pip install pynvim
$ npm install -g neovim

## zplug
```
$ brew install zplug
$ export ZPLUG_HOME=~/.zplug
$ git clone https://github.com/zplug/zplug $ZPLUG_HOME
```

## Neovim

```
$ brew install neovim
```

## vim-plug

https://github.com/junegunn/vim-plug#neovim

```
$ sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

And `:PlugInstall` to install vim plugins.

After completing installation, `:checkhealth` is a better way to check your vim settings.

