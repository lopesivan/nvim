export CLICOLOR=1
export LANG="en_US.UTF-8"

export PS1="\$ "

PYENV_ROOT="$HOME/.pyenv"
export PATH=$PATH:"$PYENV_ROOT/bin"

[[ `which pyenv 2>/dev/null` ]] && eval "$(pyenv init --path)"
[[ `which pyenv 2>/dev/null` ]] && eval "$(pyenv init -)"

#Load pyenv virtualenv if the virtualenv plugin is installed.
if pyenv virtualenv-init - &> /dev/null; then
  eval "$(pyenv virtualenv-init - bash)"
fi
