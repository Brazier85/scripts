#!/usr/bin/env bash

# Modified version of this here: https://github.com/calebstewart/init-machine
# Basic enumeration for a IP adress

source "$HOME/.local/bin/functions"

CMD="$0"
INTERFACE="tun0"
HOSTNAME=""


# Print usage information
function print_usage {
	cat <<EOF
Usage: $CMD [OPTION]... (ip)

Initialize a new machine directory structure and perform initial
scans.

Options:
	-h               display this help message
	-t               perform TCP scans (default)
	-u               perform UDP scans
	-n               machine name (used for /etc/hosts and directory)
	-i               interface for masscan (default: $INTERFACE)

Parameters:
	ip               IP address of target machine 
EOF
}

RUN_TCP=1
RUN_UDP=0
ALL_PORTS=0

while getopts ":htubk:n:i:" opt; do
	case ${opt} in
		t )
			RUN_TCP=1
			;;
		u )
			RUN_UDP=1
			;;
		h )
			print_usage
			exit 0
			;;
		n )
			HOSTNAME="$OPTARG"
			;;
		i )
			INTERFACE=$OPTARG
			;;
		\? )
			print_usage
			exit 1
			;;
	esac
done

# Shift out short options
shift $((OPTIND-1))

# Ensure a machine was specified
if [ "$#" -ne 1 ]; then
	error "error: no machine specified" >&2
	print_usage
	exit 1
fi

# Ensure we know enough about the machine
OCTET_REGEX='(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])'
IPV4_REGEX="^$OCTET_REGEX\.$OCTET_REGEX\.$OCTET_REGEX\.$OCTET_REGEX$"

if ! [[ $1 =~ $IPV4_REGEX ]]; then
	error "$1: expected an ipv4 address"
fi

if [ -z "$HOSTNAME" ]; then
	info "no hostname provided; using ipv4 address"
	HOSTNAME=$1
fi

# Save the address for later use
ADDRESS="$1"

ok "setting up environment for: $HOSTNAME"
info "you may be prompted for sudo password (for /etc/hosts and raw network device access)"

# Install hostname in /etc/hosts
if ! [ "$ADDRESS" = "$HOSTNAME" ]; then
	if ! grep -E "$ADDRESS\s+$HOSTNAME" /etc/hosts 2>&1 >/dev/null; then
		ok "installing $HOSTNAME in /etc/hosts"
		hosts_line=`echo -e "# init-machine.sh - $NAME\n$ADDRESS\t$HOSTNAME"`
		sudo sh -c "cat - >>/etc/hosts"<<END
# ENUM script - $NAME
$ADDRESS	$HOSTNAME
END
	else
		ok "machine already added to /etc/hosts"
	fi
else
	info "no hostname provided; not adding to /etc/hosts"
fi

# Creating common directory tree
ok "setting up directory tree"
mkdir -p "./$HOSTNAME/scans"
mkdir -p "./$HOSTNAME/artifacts"
mkdir -p "./$HOSTNAME/exploits"

if ! [ -f "./$HOSTNAME/README.md" ]; then
	cat <<END >"./$HOSTNAME/README.md"
# $HOSTNAME - $ADDRESS

This machine has been added to /etc/hosts as $HOSTNAME.

All machine related files can be found here:
 * [./artifacts](./artifacts)
 * [./exploits](./exploits)
 * [./scans](./scans)

Basic nmap scans are stored in [./scans](./scans).
END
fi

# Enter the directory tree
pushd "./$HOSTNAME" >/dev/null

# Run TCP scans if requested
if [ "$RUN_TCP" -eq "1" ] && ! [ -f "scans/initial-tcp" ]; then
	ok "enumerating all ports with nmap"
	sudo nmap -sC -sV -oA ./scans/initial-tcp.nmap $HOSTNAME
fi

# Run UDP scans if requested
if [ "$RUN_UDP" -eq "1" ] && ! [ -f "scans/initial-udp" ]; then
	ok "enumerating all ports with nmap"
	sudo namp -sC -sV -sU -oA scans/initial-tcp.namp $HOSTNAME
fi

#Run sublime
ok "starting sublime"
subl .

# Go back
popd >/dev/null
