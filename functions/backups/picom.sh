#!/bin/bash
#shopt -s nullglob dotglob
##
# Picom
##

picom() {
	pimain() {
		if ! [ -d $USER_HOME/picom ]; then
			git clone https://github.com/yshui/picom.git $USER_HOME/picom
			chown -R $USER_NAME:$USER_NAME $USER_HOME/picom
		fi

		if ! command -v picom >/dev/null; then
			apt install -y \
				libxcb1-dev \
				libxcb-damage0-dev \
				libxcb-xfixes0-dev \
				libxcb-shape0-dev \
				libxcb-render-util0-dev \
				libxcb-render0-dev \
				libxcb-randr0-dev \
				libxcb-composite0-dev \
				libxcb-image0-dev \
				libxcb-present-dev \
				libxcb-xinerama0-dev \
				libxcb-glx0-dev \
				libpixman-1-dev \
				libdbus-1-dev \
				libconfig-dev \
				libgl1-mesa-dev \
				libpcre2-dev \
				libpcre3-dev \
				libevdev-dev \
				uthash-dev \
				libev-dev \
				libx11-xcb-dev

			python3 -m pip install meson

			if ! [ -f "$USER_HOME/.local/bin/meson" ]; then
				ln -s /usr/local/bin/meson $USER_HOME/.local/bin/meson
			fi

			echo $USER_PASS | sudo -S $USER_NAME -c "echo $USER_PASS \
               && cd $USER_HOME/picom
               && git submodule update --init --recursive \
               && meson --buildtype=release . build \
               && ninja -C build"

			cd $USER_HOME/picom
			ninja -C build install
		fi
	}

	pimain >$LOGPATH/out/picom.log 2> \
		$LOGPATH/err/picom.log &

	setIndicator "PICOM (might take a while)" ${WORKINGICONS[0]} $!

}

if [ -z $DEV_MAIN_RUN ]; then
	DEV_SINGLE_RUN=1
	source ../../installer/globals/initMain.sh
	runSingle picom
fi
