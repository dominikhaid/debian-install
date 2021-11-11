#!/bin/bash
#shopt -s nullglob dotglob
##
# i3
##
source $SCRIPTPATH/scripts/setIndicator.sh

i3() {
	i3wm() {
		apt install -y i3 i3-wm i3lock i3status
	}

	i3wm >$LOGPATH/out/i3.log 2> \
		$LOGPATH/err/i3.log &

	setIndicator "I3 WM" ${WORKINGICONS[2]} $!
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	python
fi
