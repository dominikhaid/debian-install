#!/bin/bash
#shopt -s nullglob dotglob
##
# After Install Scripts
##

source $SCRIPTPATH/scripts/setIndicator.sh

postInstall() {
	cleanup() {
		systemctl disable apache2
		systemctl disable nginx
		systemctl enable x11vnc.service
		systemctl start x11vnc.service

		if ! [ -f "/usr/bin/qtile" ]; then ln -s $USER_HOME/.local/bin/qtile /usr/bin/qtile; fi
		if ! [ -f "/usr/bin/fd" ]; then ln -s /user/bin/fdfind /usr/bin/fd; fi
		apt autoremove -y
		if command -v locale-gen &>/dev/null; then apt locale-gen; fi
		echo 2 | update-alternatives --config x-terminal-emulator
		echo $USER_PASS | sudo -S su $USER_NAME -c "echo $USER_PASS | chsh -s '$(which zsh)'"
		neofetch --off --underline --color_blocks --stdout >$SCRIPTPATH/logs/out/hardware_before.log

		if [ -d "$USER_HOME/Applications" ]; then
			chown -R $USER_NAME:$USER_NAME $USER_HOME/Applications/*
		fi
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
