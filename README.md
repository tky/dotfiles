# Dotfiles

## Clone the repository

```
$ git init
$ git remote add origin https://github.com/taka-/dotfiles
$ git pull origin main
$ git remote set-url origin git@github.com:tky/dotfiles.git
```

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


```
$ pip install pynvim
$ pip install flake8
```

```
$ npm install -g neovim
```

## zplug
```
$ brew install zplug
$ export ZPLUG_HOME=~/.zplug
$ git clone https://github.com/zplug/zplug $ZPLUG_HOME
```

## Java

https://www.java.com/ja/download/

```
$ brew tap homebrew/cask-versions
$ brew install --cask adoptopenjdk
$ brew install openjdk@17
```

```
sudo ln -sfn /usr/local/opt/openjdk@17/libexec/openjdk.jdk \
     /Library/Java/JavaVirtualMachines/openjdk-17.jdk
```

## Vim Metals

https://get-coursier.io/docs/cli-installation#macos-brew-based-installation

```
$ brew install coursier/formulas/coursier
$ cs setup
```

```
$ cs install metals
```

```
$ brew install coursier/formulas/coursier
```

build metals-vim

https://scalameta.org/metals/docs/editors/vim/#files-and-directories-to-include-in-your-gitignore

```
coursier bootstrap \
  --java-opt -Xss4m \
  --java-opt -Xms100m \
  --java-opt -Dmetals.client=vim-lsc \
  org.scalameta:metals_2.13:0.11.8 \
  -r bintray:scalacenter/releases \
  -r sonatype:snapshots \
  -o /usr/local/bin/metals-vim -f
```

If you get such a exception, you sudo use commad with sudo.

```
Exception in thread "main" java.nio.file.AccessDeniedException: /usr/local/bin/metals-vim
```

Make sure metals-vim is installed.

```
$ which metals-vim
/usr/local/bin/metals-vim
```


```
$ cs install bloop
$ bloop about
```

If you can't jump your Class, check the java vesion that bloop uses to compile your code.

https://scalacenter.github.io/bloop/docs/server-reference#custom-java-home

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


## Coc Setting

```
:CocInstall coc-tsserver
```

```
:CocInstall coc-metals
```
