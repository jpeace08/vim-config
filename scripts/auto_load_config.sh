#!/bin/bash

# dotfile partten : "vimrc-<postfix>"
# meta_data partten: "[meta_data]:[<lang>]"

config_langs=( "js" "py" "php" )
language="${config_langs[0]}" #default
tmux_session_name="$(tmux display-message -p '#S' 2>/dev/null)"
vim_dir_path="${HOME}/.vim"
symbol_link_dotfile="${vim_dir_path}/vimrc"

function get_postfix_dotfile() {
    for lang_support in ${config_langs[@]};
    do
        if echo "${tmux_session_name}" | grep -qw "${lang_support}"
        then
            language="${lang_support}"
        fi
    done
}

function check_symbol_link_dotfile_exist () {
    echo "Check sb link dot file"	
}

function create_sbl_dotfile() {
    ln -s "${vim_dir_path}/dotfiles/vimrc-${language}" "${symbol_link_dotfile}"
}

function open_project () {
    if [ $# -eq 0 ] || [ -z "$1" ];
    then
        echo "No argument supplied"
    fi

    local path_project="$(pwd)"

    if [ ! -z "$1" ] || [ "$1" != "." ];
    then
        path_project="$(pwd)/$1"
    fi

    vim "${path_project}"
}


function create_symbol_link_dotfile() {
    if [ ! -f "${vim_dir_path}/dotfiles/vimrc-${language}" ];
    then
        echo "please add config for ${language}"
    else
        if [ ! -L "${symbol_link_dotfile}" ] || [ ! -e "${symbol_link_dotfile}" ];
        then
            echo "Symbol link dotfile doesn't exist. Create new symbol link"
            create_sbl_dotfile
        else
            meta_data="$(awk '/meta_data/' ${symbol_link_dotfile} | grep ${language})"     
            if [ -z "${meta_data}" ];
            then
                unlink "${vim_dir_path}/vimrc" 2>/dev/null
                create_sbl_dotfile
            fi
        fi
    fi
}


get_postfix_dotfile
create_symbol_link_dotfile
open_project $1
