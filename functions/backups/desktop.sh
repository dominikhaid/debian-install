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

if [ -z $DEV_MAIN_RUN ]; then
	DEV_SINGLE_RUN=1
	source ../../installer/globals/initMain.sh
	runSingle desktop
fi
