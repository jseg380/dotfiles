#
# ~/.bashrc
#


# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Aliases
alias clear="printf '\033[2J\033[3J\033[1;1H'"  # Kitty
alias a="clear"
alias grep="grep --color=auto"
alias ls="ls --color=auto" 
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"


# Environment variables
XDG_DATA_HOME="$HOME/.local/share"
XDG_CONFIG_HOME="$HOME/.config"
XDG_STATE_HOME="$HOME/.local/state"
XDG_CACHE_HOME="$HOME/.cache"

PATH=".:$HOME/.local/bin:$PATH"

GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
GNUPGHOME="$XDG_DATA_HOME/gnupg"
CARGO_HOME="$XDG_DATA_HOME/cargo"
MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"


# Custom prompt
custom_prompt() {
  # Colors
  host="$(tput setaf 10)"
  dir="$(tput setaf 4)"
  reset="$(tput sgr0)"
  PS1="\\[$host\\]\\h:\\[$dir\\]\\w\\[$reset\\]\\\$ "
}


# Use custom prompt if not running in a TTY
if [ "$DISPLAY" != "" ]
then
  # Running with Graphical Interface
  VISUAL="lvim"

  # Custom prompt
  custom_prompt
else
  # Running in a TTY
  TERM="xterm-256color"
  VISUAL="nvim"
fi
