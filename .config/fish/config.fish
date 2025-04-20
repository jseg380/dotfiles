# vim:fileencoding=utf-8:foldmethod=marker

#: Aliases {{{

#: Default parameters for programs
#: https://github.com/kovidgoyal/kitty/issues/268#issuecomment-419342337
alias clear="printf '\033[2J\033[3J\033[1;1H'"
alias grep="grep --color=auto"
alias ls="ls --color=auto" 

#: Custom aliases
alias a="clear"

#: Check which SSH command is best
test "$TERM" = "xterm-kitty" && alias ssh="kitty +kitten ssh"
# alias ssh="TERM=xterm-256color command ssh"
# alias vagrant-ssh="TERM=xterm-256color vagrant ssh"

#: Substitute coreutils programs by enhanced programs
command -q bat && alias cat="bat --paging=never"
command -q eza && alias ls="eza"

#: }}}



#: Bindings {{{

#: Fuzzy grep (inspired by fzf)
bind -M insert ctrl-alt-g _fzg

#: }}}



#: Environment variables {{{

set -gx EDITOR "lvim"
set -gx VISUAL "$EDITOR"
set -gx TERMINAL "kitty"

#: XDG Base directory
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

#: Avoid $HOME pollution
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
set -gx MYSQL_HISTFILE "$XDG_DATA_HOME/mysql_history"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"

#: IME (Input Method Editor)
set -gx GLFW_IM_MODULE "ibus" 
set -gx GTK_IM_MODULE "fcitx"
set -gx QT_IM_MODULE "fcitx"
set -gx SDL_IM_MODULE "fcitx"
set -gx XMODIFIERS "@im=fcitx"

#: }}}



#: Prompt {{{

#: Oh my posh
if test "$OMP_THEME" != "none"; and command -q oh-my-posh
    #: List of preinstalled themes avaialble at /usr/share/oh-my-posh/themes/
    set fallback_theme "/usr/share/oh-my-posh/themes/pure.omp.json"
    set current_theme "$XDG_DATA_HOME/oh-my-posh/themes/takuya.omp.json"

    switch "$OMP_THEME"
        case "uni"
            set current_theme "/usr/share/oh-my-posh/themes/json.omp.json"
    end

    #: Use fallback theme if the chosen theme does not exist
    if not test -e "$current_theme"
        set current_theme "$fallback_theme"
    end

    oh-my-posh init fish --config "$current_theme" | source
end

#: }}}



#: Pyenv {{{

if command -q pyenv
    #: Add pyenv executable to PATH
    set -gx PYENV_ROOT $HOME/.pyenv
    set -gx fish_user_paths $PYENV_ROOT/bin $fish_user_paths

    #: Load pyenv automatically
    pyenv init - fish | source
end

#: }}}
