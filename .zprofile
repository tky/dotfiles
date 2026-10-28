eval "$(/opt/homebrew/bin/brew shellenv)"

export PYENV_ROOT="$HOME/.pyenv"

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
