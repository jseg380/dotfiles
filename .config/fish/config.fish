# Unset greeting every time an instance of fish is opened
set -g fish_greeting

# Aliases
# alias a="clear"  # Does not clear scrollback buffer in kitty
alias a="printf '\033[2J\033[3J\033[1;1H'"
alias grep="grep --color=auto"
alias ls="ls --color=auto" 
alias wget="wget --hsts-file='$XDG_DATA_HOME/wget-hsts'"
alias bat="bat --plain --no-paging"

# Prompt: Starship
starship init fish | source

# Environment variables
set -gx VISUAL "lvim"
set -gx EDITOR "nvim"
set -gx TERMINAL "kitty"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
set -gx MYSQL_HISTFILE "$XDG_DATA_HOME/mysql_history"
set -gx ERRFILE "$XDG_CACHE_HOME/X11/xsession-errors"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
