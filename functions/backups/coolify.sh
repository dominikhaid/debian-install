#!/bin/bash
#shopt -s nullglob dotglob
##
# i3
##

coolify() {
	coolify_inst() {
		wget -q https://get.coollabs.io/coolify/install.sh -O install.sh
		sudo bash ./install.sh -f
	}

	coolify_inst >$LOGPATH/out/coolify.log 2> \
		$LOGPATH/err/coolify.log &

	setIndicator "Coolify" ${WORKINGICONS[2]} $!
}

if [ -z $DEV_MAIN_RUN ]; then
	DEV_SINGLE_RUN=1
	source ../../installer/globals/initMain.sh
	runSingle coolify
fi
