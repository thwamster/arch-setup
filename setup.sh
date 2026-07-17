#!/bin/bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$REPO_DIR/config"

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm - < "$CONFIG_DIR/dependencies.txt"

mkdir -p ~/.local/share/fonts ~/templates ~/templates/git ~/.vim/colors ~/.config/nvim/colors ~/.config/nvim

cp "$CONFIG_DIR/.bash_profile" ~/.bash_profile
cp "$CONFIG_DIR/.bashrc" ~/.bashrc
cp "$CONFIG_DIR/.gitignore_global" ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
cp "$CONFIG_DIR/.vimrc" ~/.vimrc
cp "$CONFIG_DIR/init.lua" ~/.config/nvim/init.lua
cp "$CONFIG_DIR/fairyfloss.vim" ~/.vim/colors/
cp "$CONFIG_DIR/fairyfloss.vim" ~/.config/nvim/colors/
cp "$REPO_DIR/fonts/"*.ttf ~/.local/share/fonts/
fc-cache -fv
cp "$REPO_DIR/lorem/"* ~/templates/
cp "$REPO_DIR/LICENSE" ~/templates/git/LICENSE
cp "$REPO_DIR/README.md" ~/templates/git/README.md
cp "$REPO_DIR/.gitignore" ~/templates/git/.gitignore

if [ -f "$REPO_DIR/.env" ]; then
    export $(grep -v '^#' "$REPO_DIR/.env" | xargs)
	gh auth setup-git
fi

source ~/.bashrc