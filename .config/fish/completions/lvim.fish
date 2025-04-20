#: vim.fish {{{

function __fish_vim_find_tags_path
    set -l max_depth 10
    set -l tags_path tags

    for depth in (seq $max_depth)
        if test -f $tags_path
            echo $tags_path
            return 0
        end

        set tags_path ../$tags_path
    end

    return 1
end

#: NB: This function is also used by the nvim completions
function __fish_vim_tags
    set -l token (commandline -ct)
    set -l tags_path (__fish_vim_find_tags_path)
    or return

    #: To prevent freezes on a huge tags file (e.g., on one from the Linux
    #: kernel source tree), limit matching tag lines to some reasonable amount
    set -l limit 10000

    #: tags file is alphabetically sorted, so it's reasonable to use "look" to
    #: speedup the lookup of strings with known prefix
    command look $token $tags_path | head -n $limit | cut -f1,2 -d \t
end

#: }}}


#: Disabled since lunarvim needs to source a specific vimrc file for it to be
#: lunarvim, otherwise it would just be nvim with a weird alias
#: complete -c lvim -s u -r -d 'Use alternative vimrc'

complete -c lvim -s c -r -d 'Execute Ex command after the first file has been read'
complete -c lvim -s S -r -d 'Source file after the first file has been read'
complete -c lvim -l cmd -r -d 'Execute Ex command before loading any vimrc'
complete -c lvim -s i -r -d 'Set the shada file location'
complete -c lvim -s o -d 'Open horizontally split windows for each file'
complete -c lvim -o o2 -d 'Open two horizontally split windows' # actually -o[N]
complete -c lvim -s O -d 'Open vertically split windows for each file'
complete -c lvim -o O2 -d 'Open two vertically split windows' # actually -O[N]
complete -c lvim -s p -d 'Open tab pages for each file'
complete -c lvim -o p2 -d 'Open two tab pages' # actually -p[N]
complete -c lvim -s q -r -d 'Start in quickFix mode'
complete -c lvim -s r -r -d 'Use swap files for recovery'
complete -c lvim -s t -xa '(__fish_vim_tags)' -d 'Set the cursor to tag'
complete -c lvim -s w -r -d 'Record all typed characters'
complete -c lvim -s W -r -d 'Record all typed characters (overwrite file)'
complete -c lvim -s A -d 'Start in Arabic mode'
complete -c lvim -s b -d 'Start in binary mode'
complete -c lvim -s d -d 'Start in diff mode'
complete -c lvim -s D -d 'Debugging mode'
complete -c lvim -s e -d 'Start in Ex mode, execute stdin as Ex commands'
complete -c lvim -s E -d 'Start in Ex mode, read stdin as text into buffer 1'
complete -c lvim -s h -d 'Print help message and exit'
complete -c lvim -s H -d 'Start in Hebrew mode'
complete -c lvim -s L -d 'List swap files'
complete -c lvim -s m -d 'Disable file modification'
complete -c lvim -s M -d 'Disable buffer modification'
complete -c lvim -s n -d 'Don\'t use swap files'
complete -c lvim -s R -d 'Read-only mode'
complete -c lvim -s r -d 'List swap files'
complete -c lvim -s V -d 'Start in verbose mode'
complete -c lvim -s h -l help -d 'Print help message and exit'
complete -c lvim -l noplugin -d 'Skip loading plugins'
complete -c lvim -s v -l version -d 'Print version information and exit'
complete -c lvim -l clean -d 'Factory defaults: skip vimrc, plugins, shada'
complete -c lvim -l startuptime -r -d 'Write startup timing messages to <file>'

#: Options exclusive to nvim, see https://neovim.io/doc/user/starting.html
complete -c lvim -s l -r -d 'Execute Lua script'
complete -c lvim -s ll -r -d 'Execute Lua script in uninitialized editor'
complete -c lvim -s es -d 'Start in Ex script mode, execute stdin as Ex commands'
complete -c lvim -s Es -d 'Start in Ex script mode, read stdin as text into buffer 1'
complete -c lvim -s s -r -d 'Execute script file as normal-mode input'

#: Server and API options
complete -c lvim -l api-info -d 'Write msgpack-encoded API metadata to stdout'
complete -c lvim -l embed -d 'Use stdin/stdout as a msgpack-rpc channel'
complete -c lvim -l headless -d 'Don\'t start a user interface'
complete -c lvim -l listen -r -d 'Serve RPC API from this address (e.g. 127.0.0.1:6000)'
complete -c lvim -l server -r -d 'Specify RPC server to send commands to'

#: Client options
complete -c lvim -l remote -d 'Edit files on nvim server specified with --server'
complete -c lvim -l remote-expr -d 'Evaluate expr on nvim server specified with --server'
complete -c lvim -l remote-send -d 'Send keys to nvim server specified with --server'
complete -c lvim -l remote-silent -d 'Edit files on nvim server specified with --server'

