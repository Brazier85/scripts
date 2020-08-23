#!/usr/bin/env bash

# Start pawncat

source "$HOME/.local/bin/functions"

ok "Loading pwncat environment"
command "source $HOME/src/pwncat/env/bin/activate"
info "Use it via python -m pwncat ... "
info "Type deactivate to close env"
