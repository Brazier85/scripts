#!/usr/bin/env bash

# Moves the current folder to done
# Original by [JohnHammond](https://github.com/JohnHammond/poor-mans-pentest)

source "$HOME/.local/bin/functions"

ORG_FOLDER=$PWD

if [ ! -d ../done ]; then
	info "No 'done' folder found"
	mkdir ../done
fi

ok "Moving $ORG_FOLDER to done"
mv "$ORG_FOLDER" ../done/

ok "Trying to cd up"
command "cd ../.."
