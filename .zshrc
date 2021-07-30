#
# .zshrc
#
# @author Fabio A. Gomez Diaz
#

########
# Path #
########

# If you come from bash you might have to change your ${PATH}.

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:${HOME}/bin:~/.local/bin:${PATH}";
export PATH="${HOME}/.fastlane/bin:${PATH}";
export PATH="/usr/local/git/bin:${PATH}";
export PATH="${HOME}/go/bin:${PATH}";
export PATH="/opt/homebrew/bin:${PATH}";
export PATH="//usr/local/Caskroom:${PATH}";
export PATH="${HOME}/.nvm:${PATH}";
export PATH="/usr/local/opt/openssl/bin:${PATH}";
export PATH="${HOME}/Library/Python/3.8/bin:$PATH";
export PATH="${HOME}/.gem/ruby/3.0.0/bin:${PATH}";
export PATH="${HOME}/.rvm/bin:${PATH}";
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}";

export ANDROID_HOME="${HOME}/Library/Android/sdk";
export GOPATH="${HOME}/go";
export SDKMAN_DIR="${HOME}/.sdkman";

#######
# Zsh #
#######

# TODO: Will need to automate installation of iTerm2, plugins, and all that

# Path to your oh-my-zsh installation.
export ZSH="/Users/${USER}/.oh-my-zsh";

ZSH_THEME="agnoster"
#ZSH_THEME="powerlevel9k/powerlevel9k"

# Enable plugins.
plugins=(git brew history kubectl history-substring-search)

source ${ZSH}/oh-my-zsh.sh;

# Don't require escaping globbing characters in zsh.
unsetopt nomatch;

# Nicer prompt.
#export PS1=$'\n'"%F{green} %*%F %3~ %F{white}"$'\n'"$ "

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.aliases ]
then
  source ~/.aliases;
  echo "Loaded aliases";
fi

########
# Brew #
########

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS="604800";

##########
# Colors #
##########

# LS Colors
export CLICOLOR="1";
export CLICOLOR_FORCE="1";
export LSCOLORS="ExFxBxDxCxegedabagacad";

##########
# DOCKER #
##########

# Super useful Docker container oneshots.
# Usage: dockrun, or dockrun [centos7|fedora27|debian9|debian8|ubuntu1404|etc.]
function dockrun() {
  docker run -it geerlingguy/docker-"${1:-ubuntu1604}"-ansible /bin/bash;
}

# Enter a running Docker container.
function denter() {
  if [[ ! "$1" ]] ; then
    echo "You must supply a container ID or name."
    return 0
  fi

  docker exec -it $1 bash
  return 0
}

#######
# Git #
#######

function gitrebase() {
  BRANCH="$1";

  if [[ "$BRANCH" == "" ]]; then
    BRANCH="master";
  fi

  REMOTE="$2";

  if [[ "$REMOTE" == "" ]]; then
    REMOTE="origin";
  fi

  git stash;
  git fetch "${REMOTE}";
  git rebase "${REMOTE}/${BRANCH}";
  git stash pop;
}

# Completions.
autoload -Uz compinit && compinit
# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Git upstream branch syncer.
# Usage: gsync master (checks out master, pull upstream, push origin).
function gsync() {
  if [[ ! "$1" ]] ; then
    echo "You must supply a branch."
    return 0
  fi

  BRANCHES=$(git branch --list $1)
  if [ ! "$BRANCHES" ] ; then
    echo "Branch $1 does not exist."
    return 0
  fi

  git checkout "$1" && \
  git pull upstream "$1" && \
  git push origin "$1"
}

################
# Google Cloud #
################
CASKROOM="/usr/local/Caskroom";
source "${CASKROOM}/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "${CASKROOM}/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

########
# JAVA #
########

[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh";

###########
# Node.js #
###########

# Node Version Manager (NVM)
# This loads nvm
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh";

# This loads nvm bash_completion
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm";

########################
# Ruby or RVM or rbenv #
########################

#source ~/.profile
export SDKROOT=$(xcrun --show-sdk-path);

# Load RVM into a shell session *as a function*
[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm";

# For rbenv
eval "$(rbenv init -)";