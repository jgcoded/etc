#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME/dotfiles/arch'

fish
