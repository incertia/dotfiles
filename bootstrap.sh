#! /bin/bash

ln -sfn "$(readlink -e ./vim/)"                   "$HOME/.vim"
ln -sfn "$(readlink -e ./shells/zshrc)"           "$HOME/.zshrc"
ln -sfn "$(readlink -e ./shells/git-prompt.sh)"   "$HOME/.git-prompt.sh"
ln -sfn "$(readlink -e ./shells/bashrc)"          "$HOME/.bashrc"
ln -sfn "$(readlink -e ./tex/texmf)"              "$HOME/texmf"
ln -sfn "$(readlink -e ./tex/latexmkrc)"          "$HOME/.latexmkrc"
ln -sfn "$(readlink -e ./config/tmux)"            "$HOME/.config/tmux"
ln -sfn "$(readlink -e ./config/powerline)"       "$HOME/.config/powerline"
ln -sfn "$(readlink -e ./xmonad)"                 "$HOME/.xmonad"
ln -sfn "$(readlink -e ./xmonad/Xresources)"      "$HOME/.Xresources"

ln -sfn "$HOME/.config/tmux/tmux.conf"            "$HOME/.tmux.conf"
