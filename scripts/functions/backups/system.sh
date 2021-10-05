#!/bin/bash
#shopt -s nullglob dotglob
##
# System
##
source $SCRIPTPATH/scripts/setIndicator.sh

system() {
	sysmain() {
		apt install -y \
			htop \
			curl \
			xserver-xorg \
			xinit \
			x11-xserver-utils \
			cups-pdf \
			pasystray \
			systray-mdstat \
			wget \
			xclip \
			lxpolkit \
			zip \
			file-roller \
			atril \
			software-properties-common \
			autojump \
			build-essential \
			cmake \
			iputils-ping \
			python \
			ripgrep \
			ca-certificates \
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
			pcmanfm \
			notification-daemon \
			lxinput \
			lxappearance \
			connman-gtk \
			lightdm \
			python3-pip \
			python-pip \
			net-tools \
			autojump \
			exa \
			fonts-noto-color-emoji \
			vim-nox \
			poppler-utils \
			ninja-build \
			gettext \
			autoconf \
			alien \
			automake \
			cmake \
			g++ \
			pkg-config \
			unzip

		git clone https://github.com/dracula/vim.git $USER_HOME/.vim/pack/themes/start/dracula
		chown -R $USER_NAME:$USER_NAME $USER_HOME/.vim
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
