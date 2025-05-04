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
if command -q bat 
    alias cat="bat --paging=never"
    alias catp="cat --plain"
end
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

#: PATH
fish_add_path --path --append --global "$HOME/.local/bin"
#: Add current working directory to $PATH
#: NOTE: Replacing '.' by its ASCII value '\x2e' is required!
if not contains -- . $PATH
    set -gx PATH \x2e $PATH
end

#: XDG Base directory
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

#: IME (Input Method Editor)
set -gx GLFW_IM_MODULE "ibus" 
set -gx GTK_IM_MODULE "fcitx"
set -gx QT_IM_MODULE "fcitx"
set -gx SDL_IM_MODULE "fcitx"
set -gx XMODIFIERS "@im=fcitx"

#: Avoid $HOME pollution
set -gx AWS_CONFIG_FILE "$XDG_CONFIG_HOME/aws/config"
set -gx AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME/aws/credentials"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx CUDA_CACHE_PATH "$XDG_CACHE_HOME/nv"
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
set -gx MYSQL_HISTFILE "$XDG_DATA_HOME/mysql_history"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx VAGRANT_HOME "$XDG_DATA_HOME/vagrant"
set -gx WINEPREFIX "$XDG_DATA_HOME/wine"
set -gx XCURSOR_PATH "/usr/share/icons:$XDG_DATA_HOME/icons"
set -gx npm_config_cache "$XDG_CACHE_HOME/npm"

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
    set -gx PYENV_ROOT "$XDG_DATA_HOME/pyenv"
    # fish_add_path --path --append --global $PYENV_ROOT/shims

    #: Pyenv loading is usually done eith `pyenv init - fish | source` 
    #: but it sets the path for shims before the rest •`_´•
    #: Overriding pyenv init commands to adapt to my needs
    pyenv init - fish | source

    #: Append shims to the end of $PATH
    fish_add_path --path --move --append "$PYENV_ROOT/shims"
end

#: }}}
