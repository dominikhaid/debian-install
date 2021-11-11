#!/bin/bash
#shopt -s nullglob dotglob
##
#Ruby
##
ruby() {
	if ! command -v ruby &>/dev/null; then
		apt-get install -y ruby ruby-dev
	fi
}



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle ruby
fi

