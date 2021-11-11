#!/bin/bash
#shopt -s nullglob dotglob
##
# Libs
##

libs() {

	libsmain() {
		apt install -y \
			libavfilter-dev \
			libavutil-dev \
			libxext-dev \
			libavformat-dev \
			libavcodec-dev \
			swig \
			doxygen \
			libtool-bin \
			liblua5.3-dev \
			python3-dev \
			libedit-dev \
			libncurses5-dev \
			liblua5.2-dev \
			libedit-dev \
			liblzma-dev \
			libnotify-dev \
			libffi-dev \
			libxcb-render0-dev \
			libx11-dev \
			x11proto-xext-dev \
			libxres-dev \
			libtool \
			libtool-bin \
			libpulse-dev \
			lsb-release \
			libsystemd-dev
	}

	libsmain >$LOGPATH/out/libs.log 2> \
		$LOGPATH/err/libs.log &

	setIndicator "INSTALL LIBS" ${WORKINGICONS[0]} $!

}

if [ -z $DEV_MAIN_RUN ]; then
	DEV_SINGLE_RUN=1
	source ../../installer/globals/initMain.sh
	runSingle libs
fi
