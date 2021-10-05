#!/bin/bash
#shopt -s nullglob dotglob
##
# Libs
##
source $SCRIPTPATH/scripts/setIndicator.sh

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

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	libs
fi
