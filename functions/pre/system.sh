#!/bin/bash
#shopt -s nullglob dotglob
##
# System
##


system() {
	sysmain() {
		apt install -y \
			sudo \
			htop \
			rsync \
			xinit \
			git \
			i3lock \
			mpc \
			xpad \
			xserver-xephyr \
            x11-xserver-utils \
            xserver-xorg \
			curl \
			cups-pdf \
			guvcview \
			pasystray \
			systray-mdstat \
			wget \
			fuse \
			samba \
			cifs-utils \
			xclip \
			xfce4-power-manager \
			lxpolkit \
			zip \
			file-roller \
			atril \
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
			ripgrep \
			ca-certificates \
			tightvncserver \
			cmst \
			zsh \
			vim \
			tree \
			fd-find \
			fonts-firacode \
			kitty \
			fzf \
			cups \
			imagemagick \
			nitrogen \
			bat \
			pcmanfm \
			xterm \
			notification-daemon \
			lxinput \
			lxappearance \
			connman-gtk \
			gnome-system-tools \
			gnome-system-tools \
			gnome-disk-utility \
			gparted \
			gucharmap \
			lightdm \
			xscreensaver \
			ufw \
			gnome-keyring \
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
			arandr \
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
			locales \
			accountsservice

		git clone https://github.com/dracula/vim.git $USER_HOME/.vim/pack/themes/start/dracula
		sed -i 's/bullseye main/bullseye non-free main/g' /etc/apt/sources.list

	}

	sysmain >$LOGPATH/out/system.log 2> \
		$LOGPATH/err/system.log &

	setIndicator "SYSTEM PACKAGES" ${WORKINGICONS[0]} $!
}

if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle system
fi

