# Unset greeting every time an instance of fish is opened
set -g fish_greeting

# Aliases
alias clear="printf '\033[2J\033[3J\033[1;1H'"  # Kitty
alias a="clear"
alias grep="grep --color=auto"
alias ls="ls --color=auto" 
alias new-project="npm init -y && printf \"**/node_modules\ndist/*\n\" > .gitignore"
# [ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
alias ssh="TERM=xterm-256color command ssh"
alias vagrant-ssh="TERM=xterm-256color vagrant ssh"

if test "$DISPLAY" != ""
  # Running with Graphical Interface

  # Prompt: Starship
  starship init fish | source

  # Env vars
  set -gx TERMINAL "kitty"
  set -gx VISUAL "lvim"
  set -gx EDITOR "nvim"
else
  # Running in a TTY

  # Env vars
  set -gx TERM "xterm-256color"
  set -gx VISUAL "nvim"
  set -gx EDITOR "vim"
end

# Environment variables independent
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
set -gx MYSQL_HISTFILE "$XDG_DATA_HOME/mysql_history"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
