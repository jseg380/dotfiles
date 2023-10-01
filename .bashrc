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
custom_prompt() {
  # Colors
  host="$(tput setaf 10)"
  dir="$(tput setaf 4)"
  reset="$(tput sgr0)"
  PS1="\\[$host\\]\\h:\\[$dir\\]\\w\\[$reset\\]\\\$ "
}
custom_prompt
