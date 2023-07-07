#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias a='printf "\033[2J\033[3J\033[1;1H"'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Environment variables
PATH=~/.local/bin:$PATH
PATH=.:$PATH
VISUAL="lvim"
EDITOR="nvim"
TERMINAL="kitty"
XDG_DATA_HOME="$HOME/.local/share"
XDG_CONFIG_HOME="$HOME/.config"
XDG_STATE_HOME="$HOME/.local/state"
XDG_CACHE_HOME="$HOME/.cache"
CARGO_HOME="$XDG_DATA_HOME/cargo"
GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Custom prompt
# Colors
user="\[$(tput setaf 171)\]"
host="\[$(tput setaf 141)\]"
dir="\[$(tput setaf 51)\]"
reset="\[$(tput sgr0)\]"

exitstatus()
{
  last=$?
  reset="$(tput sgr0)"
  if [[ $last -eq 0 ]]
  then
    color="$(tput setaf 2)"
  else
    color="$(tput setaf 1)"
  fi

 echo -n "$color[$last]$reset"
}

PS1="${user}\u${reset}@${host}\h${reset} ${dir}\w${reset} \$(exitstatus)> "
