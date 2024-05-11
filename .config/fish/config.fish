# 
# ~/.config/fish/config.fish
# 


# If not running interactively, don't do anything
# if not status is-interactive; return; end


# Aliases
alias clear="printf '\033[2J\033[3J\033[1;1H'"  # Kitty
alias a="clear"
alias grep="grep --color=auto"
alias ls="ls --color=auto" 
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"


# Use custom prompt if not running in a TTY
if [ "$DISPLAY" != "" ]
  # Running with Graphical Interface
  set -gx VISUAL "lvim"

  # Prompt: Starship
  which starship > /dev/null 2>&1 && begin; starship init fish | source; end
else
  # Running in a TTY
  set -gx TERM "xterm-256color"
  set -gx VISUAL "nvim"
end


# Environment variables
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"

set -g fish_greeting          # Unset default fish greeting
set -gx EDITOR "$VISUAL"

set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx MYSQL_HISTFILE "$XDG_DATA_HOME/mysql_history"
