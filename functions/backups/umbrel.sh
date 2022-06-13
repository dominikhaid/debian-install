#!/bin/bash
#shopt -s nullglob dotglob
##
# i3
##

umbrel() {
	umbrel_inst() {
		curl -L https://umbrel.sh | bash
	}

	umbrel_inst >$LOGPATH/out/umbrel.log 2> \
		$LOGPATH/err/umbrel.log &

	setIndicator "Umbrel" ${WORKINGICONS[2]} $!
}

if [ -z $DEV_MAIN_RUN ]; then
	DEV_SINGLE_RUN=1
	source ../../installer/globals/initMain.sh
	runSingle umbrel
fi
