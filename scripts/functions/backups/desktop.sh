#!/bin/bash
#shopt -s nullglob dotglob
##
# Desktop
##
desktop() {
	if ! command -v lxsession &>/dev/null; then
		echo $USER_PASS | sudo -S apt install -yq lxde
	fi
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	desktop
fi
