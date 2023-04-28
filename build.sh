#!/bin/bash

## Config vim for python, ts, js
## generate vimrc with vimbootstrap
## Require: vim 8.0^
## Theme: gruvbox

## Run after script execute completely for searh fzf and ag

# cp -r ~/.vim/pack/plugins/start/fzf ~/.fzf
# ./.fzf/install
# sudo apt install silversearcher-ag


## Edit dependencies
package_dependencies=(
  "https://github.com/preservim/nerdtree.git"
  "https://github.com/preservim/nerdtree.git"
  "https://github.com/preservim/nerdtree.git"
  "https://github.com/jistr/vim-nerdtree-tabs.git"
  "https://github.com/tpope/vim-commentary.git"
  "https://github.com/tpope/vim-fugitive.git"
  "https://github.com/vim-airline/vim-airline.git"
  "https://github.com/vim-airline/vim-airline-themes.git"
  "https://github.com/vim-scripts/grep.vim.git"
  "https://github.com/vim-scripts/CSApprox.git"
  "https://github.com/Raimondi/delimitMate.git"
  "https://github.com/preservim/tagbar.git"
  "https://github.com/dense-analysis/ale.git"
  "https://github.com/Yggdroot/indentLine.git"
  "https://github.com/tpope/vim-rhubarb.git"
  "https://github.com/morhetz/gruvbox.git"
  "https://github.com/junegunn/fzf.git"
  "https://github.com/junegunn/fzf.vim.git"
  "https://github.com/Shougo/vimproc.vim.git"
  "https://github.com/xolox/vim-misc.git"
  "https://github.com/xolox/vim-session.git"
  "https://github.com/SirVer/ultisnips.git"
  "https://github.com/honza/vim-snippets.git"
  "https://github.com/jelera/vim-javascript-syntax.git"
  "https://github.com/davidhalter/jedi-vim.git"
  "https://github.com/raimon49/requirements.txt.vim.git"
  "https://github.com/leafgarland/typescript-vim.git"
  "https://github.com/HerringtonDarkholme/yats.vim.git"
  "https://github.com/fatih/vim-go"
  "https://github.com/phpactor/phpactor",
  "https://github.com/stephpy/vim-php-cs-fixer",
)

full_path="$(cd "$(dirname -- "$1")" >/dev/null; pwd -P)/$(basename -- "$1")"
start_directory="${full_path}pack/plugins/start"
opt_directory="${full_path}pack/plugins/opt"
git_directory="${full_path}.git"
git_modules="${full_path}.gitmodules"
theme_file="gruvbox.vim"
symbol_link_theme_directory="${full_path}colors"
theme_directory="${start_directory}/gruvbox/colors"

function check_path_exist() {
  path="${1}" # path variable
  mode="${2}" # mode check: file "f" or dir "d"
  local result="false"
  if [ -${mode} ${path} ];
  then
    result="true"
  fi
  echo "${result}"
}

function create_dirs_structure() {
  if [ "$(check_path_exist "${symbol_link_theme_directory}" "d")" = "false" ];
  then
    mkdir -p "${symbol_link_theme_directory}"
  fi

  if [ "$(check_path_exist "${start_directory}" "d")" = "false" ];
  then
    mkdir -p "${start_directory}"
  fi

  if [ "$(check_path_exist "${opt_directory}" "d")" = "false" ];
  then
    mkdir -p "${opt_directory}"
  fi
}

function init_git_repo() {
  if [ "$(check_path_exist "${git_directory}" "d")" = "false" ];
  then
    git init -b master
  fi
}

function add_submodules() {
  for repos_name in ${package_dependencies[@]}; 
  do
    if [[ $repos_name =~ https\:\/\/github.com(\/.*\/)(.*)\.git ]]; 
    then
      local _dir_path="${start_directory}/${BASH_REMATCH[2]}"
      if [ "$(check_path_exist "${_dir_path}" "d")" = "false" ];
      then
        git submodule add -f "${repos_name}" "${_dir_path}"
      fi
    fi
  done
}

function sync_git_submodules() {
  if [ "$(check_path_exist "${git_modules}" "f")" = "true" ];
  then
    echo "Sync submodules..."
    git submodule foreach "(git checkout master; git pull)&"
    echo "Sync submodules successfully"
  fi
}

function config_theme() {
  if [ "$(check_path_exist "${symbol_link_theme_directory}/${theme_file}" "f")" = "true" ];
  then
    exit
  fi
  if [ "$(check_path_exist "${symbol_link_theme_directory}" "d")" = "true" ] && [ "$(check_path_exist "${theme_directory}/${theme_file}" "f")" = "true" ];
  then
    ln -s "${theme_directory}/${theme_file}" "${symbol_link_theme_directory}/${theme_file}"
  fi
}

# Shell script not support assertion regex

function removeUnusedSubmodules() {
  for dir in `find ${start_directory} -maxdepth 1 -mindepth 1 -type d`
  do
    if [[ "${dir}" =~ [\/\w\.]*start\/(.+)$ ]];
    then
      if ! echo "${package_dependencies[@]}" | grep -qw "${BASH_REMATCH[1]}";
      then
        # gitmodules file added in gitignore file => just remove dir of submodule
        rm -rf "${start_directory}/${BASH_REMATCH[1]}"
        sed "/${BASH_REMATCH[1]}/d" .gitmodules >> gitmodules.temp && mv gitmodules.temp .gitmodules
      fi
    fi
  done
}

create_dirs_structure
init_git_repo
sync_git_submodules
add_submodules
config_theme
removeUnusedSubmodules
