#!/bin/bash

ebloc_path="$PWD"
var=$(echo $ebloc_path | sed 's/\//\\\//g')

sed -i.bak "s/^\(DATADIR=\).*/\1\"$var\"/" config.sh && rm -f config.sh.sh.bak
sed -i.bak "s/^\(DATADIR=\).*/\1\"$var\"/" config.sh && rm -f config.sh.sh.bak
sed -i.bak "s/^\(DATADIR=\).*/\1\"$var\"/" config.sh && rm -f config.sh.sh.bak

echo -e "\nPlease enter name for eBloc Network Status:"
read var

if [[ $var == *\$* ]]; then
    echo 'Please enter string without a dollar sign'
fi

if [[ $var == *\"* ]]; then
    echo 'Please enter string without a double quote sign'
    exit
fi

if [[ $var == *\'* ]]; then
    echo 'Please enter string without a single quote sign'
    exit
fi

sed -i.bak "s/^\(NAME=\).*/\1\"$var\"/" config.sh && rm -f config.sh.bak
