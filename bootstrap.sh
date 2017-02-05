#! /bin/bash

ln -sf "$(realpath ./vim/)"                   "$HOME/.vim/"
ln -sf "$(realpath ./shells/zshrc)"           "$HOME/.zshrc"
ln -sf "$(realpath ./shells/git-prompt.sh)"   "$HOME/.git-prompt.sh"
ln -sf "$(realpath ./shells/bashrc)"          "$HOME/.bashrc"
ln -sf "$(realpath ./tex/texmf)"              "$HOME/texmf"
ln -sf "$(realpath ./tex/latexmkrc)"          "$HOME/.latexmkrc"
ln -sf "$(realpath ./config/tmux)"            "$HOME/.config/tmux"
ln -sf "$(realpath ./config/powerline)"       "$HOME/.config/powerline"
ln -sf "$(realpath ./xmonad)"                 "$HOME/.xmonad"
ln -sf "$(realpath ./xmonad/Xresources)"      "$HOME/.Xresources"
