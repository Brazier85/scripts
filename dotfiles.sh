#!/usr/bin/env bash

# This script is used to update my .dotfiles dir and its includes.
# If there are any changes ist will commit them

# Shared functions
source "$HOME/.local/bin/functions"

ok "Updating dotfiles"
info "Pull last version"
cd $HOME/.dotfiles
git pull --recurse-submodules
git submodule foreach --recursive git stash && git checkout master && git pull
ok "Submit changes"
git add .
if [ $# -eq 0 ]; then
	info "No arguments found - trying Autocommit"
	git commit -m "Autocommit changes"
else
	git commit -m "$1"
fi
git push
ok "done"
