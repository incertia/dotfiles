#! /bin/zsh

if [ $# -ne 3 ]
then
    echo "Usage: `basename $0` <start_byte> <end_byte> <filename>"
    exit -1
fi

if [ ! -e $3 ]
then
    echo "Error: $3 does not exist"
    exit 1
fi

if [ $1 -gt $2 ]
then
    echo "Error: $1 is greater than $2"
    exit 1
fi

derp=$(head -c $[$2 + 1] $3 | tail -c +$[$1 + 1])
printf "%s" "$derp"
