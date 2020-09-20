#!/usr/bin/env bash

# Stabelize your rev shell
# Original by [JohnHammond](https://github.com/JohnHammond/poor-mans-pentest)

source "$HOME/.local/bin/functions"

hide_guake
command "python -c 'import pty; pty.spawn(\"/bin/bash\")'"
ctrl Z
command "stty raw -echo; fg"
command "export TERM=xterm"
