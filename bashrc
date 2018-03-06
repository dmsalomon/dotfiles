#
# ~/.bashrc: Dov Salomon <dovisal1@gmail.com>
#


# exit if not interactive
case $- in
    *i*) ;;
      *) return;;
esac


[ -f ~/.config/bash/aliases ] && source ~/.config/bash/aliases
[ -d ~/.zfunc ] && PATH="$PATH:$HOME/.zfunc"

bash_greeting
PS1='\[\033]2;\u@\h:\w\007\]\[$(tput setaf 3)\]\u@\h\[$(tput sgr0)\]:\[$(tput setaf 4)\]$(prompt_pwd)\[$(tput sgr0)\]\$ '

export EDITOR=vim

dsx="dovi@192.168.1.46"

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=10000
HISTFILESIZE=50000

shopt -s checkwinsize
shopt -s globstar

# make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls, and color aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# basic ls aliases
alias ll='ls -alF'
alias la='ls -lAh'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
