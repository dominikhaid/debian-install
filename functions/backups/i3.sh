#!/bin/bash
#shopt -s nullglob dotglob
##
# i3
##

i3() {
	i3wm() {
		apt install -y i3 i3-wm i3lock i3status
	}

	i3wm >$LOGPATH/out/i3.log 2> \
		$LOGPATH/err/i3.log &

	setIndicator "I3 WM" ${WORKINGICONS[2]} $!
}

if [ -z $DEV_MAIN_RUN ]; then
	DEV_SINGLE_RUN=1
	source ../../installer/globals/initMain.sh
	runSingle i3
fi
