#! /bin/bash

ln -sfn "$(realpath ./vim/)"                   "$HOME/.vim"
ln -sfn "$(realpath ./shells/zshrc)"           "$HOME/.zshrc"
ln -sfn "$(realpath ./shells/git-prompt.sh)"   "$HOME/.git-prompt.sh"
ln -sfn "$(realpath ./shells/bashrc)"          "$HOME/.bashrc"
ln -sfn "$(realpath ./tex/texmf)"              "$HOME/texmf"
ln -sfn "$(realpath ./tex/latexmkrc)"          "$HOME/.latexmkrc"
ln -sfn "$(realpath ./config/tmux)"            "$HOME/.config/tmux"
ln -sfn "$(realpath ./config/powerline)"       "$HOME/.config/powerline"
ln -sfn "$(realpath ./xmonad)"                 "$HOME/.xmonad"
ln -sfn "$(realpath ./xmonad/Xresources)"      "$HOME/.Xresources"

ln -sfn "$HOME/.config/tmux/tmux.conf"            "$HOME/.tmux.conf"
