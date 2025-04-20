# fuzzy grep
function _fzg
    function __guess_editor
        if test -n "$VISUAL"
            echo "$VISUAL"
        else
            echo "$EDITOR"
        end
    end

    set --local _editor $(__guess_editor)
    set --local RELOAD "reload:rg --column --color=always --smart-case {q} || :"
    set --local OPENER "if test \$FZF_SELECT_COUNT -eq 0
                            $_editor {1} +{2}     # No selection. Open the current line in text editor.
                        else
                            $_editor +cw -q {+f}  # Build quickfix list for the selected items.
                        end"

    fzf --disabled --ansi --multi \
        --bind "start:$RELOAD" \
        --bind "change:$RELOAD" \
        --bind "enter:become:$OPENER" \
        --bind "ctrl-o:execute:$OPENER" \
        --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(up)' \
        --query "$argv"
end
