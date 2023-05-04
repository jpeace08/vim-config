#!/bin/bash

# dotfile partten : "vimrc-<postfix>"
# meta_data partten: "[meta_data]:[<lang>]"

config_langs=( "js" "py" "php" )
language="${config_langs[0]}" #default
tmux_session_name="$(tmux display-message -p '#S' 2>/dev/null)"
vim_dir_path="${HOME}/.vim"

function get_postfix_dot_file() {
    for lang_support in ${config_langs[@]};
    do
        if echo "${tmux_session_name}" | grep -qw "${lang_support}"
        then
            language="${lang_support}"
        fi
    done
}

function check_symbol_link_dot_file_exist () {
    echo "Check sb link dot file"	
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


function create_symbol_link() {

    if [ ! -f "${vim_dir_path}/dotfiles/vimrc-${language}" ];
    then
        echo "please add config for ${language}"
    else
        meta_data="$(awk '/meta_data/' ${vim_dir_path}/vimrc | grep ${language})" 
        if [ ! -L "${vim_dir_path}/vimrc" ] || [ -z "${meta_data}" ];
        then
            echo "create new symbol link dot file"
            unlink "${vim_dir_path}/vimrc" 2>/dev/null
            ln -s "${vim_dir_path}/dotfiles/vimrc-${language}" "${vim_dir_path}/vimrc"
        fi
    fi
}


get_postfix_dot_file
create_symbol_link
open_project $1
