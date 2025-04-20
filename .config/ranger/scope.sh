#!/usr/bin/env bash
## Reference: /usr/share/doc/ranger/config/scope.sh

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

## Script arguments
FILE_PATH="${1}"         # Full path of the highlighted file
PV_WIDTH="${2}"          # Width of the preview pane (number of fitting characters)
PV_HEIGHT="${3}"         # Height of the preview pane (number of fitting characters)
IMAGE_CACHE_PATH="${4}"  # Full path that should be used to cache image preview
PV_IMAGE_ENABLED="${5}"  # 'True' if image previews are enabled, 'False' otherwise.

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
        ## Compressed file
        a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
        rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
            bsdtar --list --file "${FILE_PATH}" && exit 5
            exit 1;;
        rar)
            ## Avoid password prompt by providing empty password
            unrar lt -p- -- "${FILE_PATH}" && exit 5
            exit 1;;
        7z)
            ## Avoid password prompt by providing empty password
            7z l -p -- "${FILE_PATH}" && exit 5
            exit 1;;

        ## PDF as text
        # pdf)
        #     ## Preview as text conversion
        #     pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - | \
        #       fmt -w "${PV_WIDTH}" && exit 5
        #     exit 1;;
    esac
}

handle_image() {
    local DEFAULT_SIZE="1600x900"

    local mimetype="${1}"
    case "${mimetype}" in
        ## Image
        image/*)
            exit 7;;

        ## PDF
        application/pdf)
            pdftoppm -f 1 -l 1 \
                     -scale-to-x "${DEFAULT_SIZE%x*}" \
                     -scale-to-y -1 \
                     -singlefile \
                     -jpeg -tiffcompression jpeg \
                     -- "${FILE_PATH}" "${IMAGE_CACHE_PATH%.*}" \
                && exit 6 || exit 1;;
    esac
}

handle_mime() {
    local mimetype="${1}"
    case "${mimetype}" in
        text/* | */xml | application/*)
            ## Syntax highlight
            # dbgbat --color=always -- "${FILE_PATH}" && exit 5
            bat --color=always --theme=base16 -- "${FILE_PATH}" && exit 5
            exit 2;;
    esac
}

handle_fallback() {
    echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}" && exit 5
    exit 1
}


MIMETYPE="$(xdg-mime query filetype "${FILE_PATH}")"
if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
    handle_image "${MIMETYPE}"
fi
handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

exit 1
