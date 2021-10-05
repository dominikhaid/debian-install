#!/bin/bash
#shopt -s nullglob dotglob
##
# Tools
##
source $SCRIPTPATH/scripts/setIndicator.sh

tools() {

	toolsmain() {
		sudo -i -u $USER_NAME <<EOF
    echo $USER_PASS | sudo -S apt install -yq \
    synaptic \
    libreoffice \
    remmina \
    rofi \
    evolution \
    qbittorrent \
    vlc \
    gimp \
    inkscape \
    cowsay \
    krita \
    darktable \
    kdenlive \
    fortune 
EOF
	}

	toolsmain >$LOGPATH/out/tools.log 2> \
		$LOGPATH/err/tools.log &

	setIndicator "TOOLS" ${WORKINGICONS[0]} $!

	if [ -f "usr/bin/bat" ]; then
		ln -s batcat /usr/bin/bat
	fi
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	tools
fi
