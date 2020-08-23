#!/usr/env/bin bash

# Some functions I use in my other scripts

# Colors for Messages
GREEN=`tput setaf 2`
RED=`tput setaf 1`
MAGENTA=`tput setaf 5`
RST=`tput sgr0`

# Print some info to stdout
function info {
    echo "[i] $@"
}

function ok {
    echo "[${GREEN}✓${RST}] $@"
}

function error {
    echo "[${RED}✗${RST}] $@"
}

# AutomationX Stuff
function hide_guake(){
	xte "keydown Shift_L" "key Return" "key Return" "keyup Shift_L"
	sleep 0.5
}

function command(){

	xte "str $1"
	sleep 0.5
	xte "key Return"
}

function command2(){
	xte "str $1"
	sleep 0.5
	xte "key Return"
	sleep 0.5
	xte "key Return"
}

function ctrl(){
	xte "keydown Control_L" "key $1" "keyup Control_L"
	sleep 0.5
}

function alt_tab(){
	xte "keydown Alt_L" "keydown Tab" "keyup Alt_L" "keyup Tab"
	sleep 0.5
}
