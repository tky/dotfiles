eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$HOME/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
