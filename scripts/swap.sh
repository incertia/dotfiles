#! /bin/zsh

if [ $# -ne 2 ]; then
    echo "Usage: `basename $0` <fileA> <fileB>"
    exit 1
fi

if [ ! -e $1 ]; then
    echo "Error: $1 does not exist"
    exit 2
fi

if [ ! -e $2 ]; then
    echo "Error: $2 does not exist"
    exit 2
fi

if [ -e "$1.HERPADERP" ]; then
    echo "Error: $1.HERPADERP (the temp filename) already exists"
    exit 2
fi

mv "$1" "$1.HERPADERP"
mv "$2" "$1"
mv "$1.HERPADERP" "$2"
