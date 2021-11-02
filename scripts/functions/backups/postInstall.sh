#!/bin/bash
#shopt -s nullglob dotglob
##
# After Install Scripts
##

source $SCRIPTPATH/scripts/setIndicator.sh

postInstall() {
	cleanup() {

		if ! [ -f "/usr/bin/qtile" ]; then ln -s $USER_HOME/.local/bin/qtile /usr/bin/qtile; fi
		if ! [ -f "/usr/bin/fd" ]; then ln -s /user/bin/fdfind /usr/bin/fd; fi
		apt autoremove -y
		if command -v locale-gen &>/dev/null; then locale-gen; fi
		neofetch --off --underline --color_blocks --stdout >$SCRIPTPATH/logs/out/hardware_after.log
	}

	cleanup >$LOGPATH/out/postInstall.log 2> \
		$LOGPATH/err/postInstall.log &

	setIndicator "CLEAN UP" ${WORKINGICONS[0]} $!
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	postInstall
fi
