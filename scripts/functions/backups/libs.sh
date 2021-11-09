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
                        Libtool-bin \
			liblua5.3-dev \
			python3-dev \
			libedit-dev \
			libncurses5-dev \
			liblua5.2-dev \
			libedit-dev \
			liblzma-dev \
			libnotify-dev \
			python3-xcffib \
			python3-cairocffi \
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

	llvm() {
		if ! command -v clang &>/dev/null; then
			bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
			if ! [ -f "/usr/bin/clang++" ]; then ln -s /usr/bin/clang++-13 /usr/bin/clang++; fi
			if ! [ -f "/usr/bin/clang" ]; then ln -s /usr/bin/clang-13 /usr/bin/clang; fi
			if ! [ -f "/usr/bin/lldb-vscode" ]; then ln -s /usr/bin/lldb-vscode-13 /usr/bin/lldb-vscode; fi
			if ! [ -f "/usr/bin/lldb-server" ]; then ln -s /usr/bin/lldb-server-13 /usr/bin/lldb-server; fi
			if ! [ -f "/usr/bin/lldb" ]; then ln -s /usr/bin/lldb-13 /usr/bin/lldb; fi
		fi
	}

	libsmain >$LOGPATH/out/libs.log 2> \
		$LOGPATH/err/libs.log &

	setIndicator "INSTALL LIBS" ${WORKINGICONS[0]} $!

	llvm >$LOGPATH/out/clang.log 2> \
		$LOGPATH/err/clang.log &

	setIndicator "LLVM / CLANG" ${WORKINGICONS[2]} $!
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	libs
fi
