#!/bin/bash
#shopt -s nullglob dotglob
##
# System
##
source $SCRIPTPATH/scripts/setIndicator.sh

system() {
	sysmain() {
		apt install -y \
			sudo \
			htop \
			xinit \
			git \
			xserver-xephyr \
			curl \
			wget \
			fuse \
			samba \
			cifs-utils \
			xclip \
			lsb-release \
			software-properties-common \
			squashfuse \
			openssh-server \
			aptitude \
			autojump \
			build-essential \
			cmake \
			x11vnc \
			apt-transport-https \
			gnupg \
			dbus \
			iputils-ping \
			python \
			figlet \
			bluetooth \
			nginx \
			apache2 \
			ca-certificates \
			tightvncserver \
			cmst \
			ufw \
			gnome-keyring \
			python3-pip \
			rfkill \
			blueman \
			bluez \
			bluez-tools \
			pulseaudio-module-bluetooth \
			ssh \
			dbus-user-session \
			systemd \
			x11-apps \
			net-tools \
			autojump \
			exa \
			fonts-noto-color-emoji \
			vim-nox \
			xvfb \
			poppler-utils \
			ninja-build \
			gettext \
			autoconf \
			alien \
			automake \
			cmake \
			g++ \
			pkg-config \
			unzip \
			accountsservice

		sed -i 's/bullseye main/bullseye non-free main/g' /etc/apt/sources.list

	}

	sysmain >$LOGPATH/out/system.log 2> \
		$LOGPATH/err/system.log &

	setIndicator "SYSTEM PACKAGES" ${WORKINGICONS[0]} $!
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	system
fi
