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
repos=(
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
)

mkdir -p ./pack/plugins/start ./pack/plugins/opt ./colors

GIT_DIR=./.git
if [[ -d "$GIT_DIR" ]];
then
  echo "Repo git exists."
  exit
else
	echo "Repo git does not exist.Init repository..."
  git init -b master
fi

cd ./pack/plugins/start

echo "Start add submodule repositories"

for repos_name in ${repos[@]}; do
  if [[ $repos_name =~ https\:\/\/github.com(\/.*\/)(.*)\.git ]]; then
    git submodule add $repos_name ./${BASH_REMATCH[2]}
  fi
done

echo "Clone repositories successfully!"

FILE_THEME=./gruvbox/colors/gruvbox.vim
DIR_THEME=../../../colors/
if [ -f "$FILE_THEME" ] && [ -d "$DIR_THEME" ];
then
  cp $FILE_THEME $DIR_THEME
fi

