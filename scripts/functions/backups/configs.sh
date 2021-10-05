#!/bin/bash
#shopt -s nullglob dotglob
##
# Clone Configs
##
source $SCRIPTPATH/scripts/setIndicator.sh

configs() {

	if [ -d "$SCRIPTPATH/debian-config" ]; then
		rm -R $SCRIPTPATH/debian-config
	fi

	cloneDot() {
		git clone https://github.com/dominikhaid/debian-config.git $SCRIPTPATH/debian-config
		chown -R $USER_NAME:$USER_NAME $SCRIPTPATH/debian-config
	}

	confmain() {
		if ! [ -d "$USER_HOME/dev/backups" ]; then mkdir -p $USER_HOME/dev/backups; fi
		echo "0 5 * * 1 tar -zcf $(echo $USER_HOME)/dev/backups/dotfiles.tgz $(echo $USER_HOME)/.config" >>/var/spool/cron/crontabs/root
		cd $SCRIPTPATH

		if [ -z $DISPLAY ]; then
			#cp -f $SCRIPTPATH/debian-config/lightdm/lightdm.conf /etc/lightdm/lightdm.conf
			#cp -f $SCRIPTPATH/debian-config/vnc/xserverrc /etc/X11/xinit/xserverrc
		fi

		#if [ -d "/root/.vnc" ]; then rm /root/.vnc/*; fi
		#if ! [ -d "/root/.vnc" ]; then mkdir /root/.vnc; fi
		if ! [ -d "/etc/resolvconf/resolv.conf.d" ]; then mkdir -p /etc/resolvconf/resolv.conf.d; fi

		#cp -f $SCRIPTPATH/debian-config/vnc/x11vnc.service /etc/systemd/system/x11vnc.service
		#cp -f $SCRIPTPATH/debian-config/vnc/xstartup /root/.vnc/xstartup
		cp -f $SCRIPTPATH/debian-config/vnc/tail /etc/resolvconf/resolv.conf.d/tail
		cp -f $SCRIPTPATH/debian-config/qtile/qtile.desktop /usr/share/xsessions/qtile.desktop

		if [ -d $USER_HOME/.config/nvim ]; then rm -R $USER_HOME/.config/nvim; fi
		if [ -d $USER_HOME/.vim ]; then rm -R $USER_HOME/.vim; fi

		if [ -d "$USER_HOME/dev" ]; then chown -R $USER_NAME:$USER_NAME $USER_HOME/dev; fi
		sudo -i -u $USER_NAME <<EOF

    if ! [ -d $USER_HOME/Bilder/wallpaper ];then mkdir -p $USER_HOME/Bilder/wallpaper;fi
    cp -r $SCRIPTPATH/debian-config/user-config/wallpaper  $USER_HOME/Bilder

    if ! [ -d $USER_HOME/.icons ];then mkdir -p $USER_HOME/Bilder/.icons;fi
    cp -r $SCRIPTPATH/debian-config/user-config/.icons $USER_HOME/

    if ! [ -d $USER_HOME/.themes ];then mkdir -p $USER_HOME/Bilder/.themes;fi
    cp -r $SCRIPTPATH/debian-config/user-config/.themes $USER_HOME/


    if ! [ -d $USER_HOME/.config ];then mkdir -p $USER_HOME/.config;fi
    cp -R -u $SCRIPTPATH/debian-config/user-config/.config/* $USER_HOME/.config/

    if ! [ -d $USER_HOME/.vim ];then mkdir -p $USER_HOME/.vim;fi
    cp -u -R $SCRIPTPATH/debian-config/user-config/.vim/* $USER_HOME/.vim

    if ! [ -d $USER_HOME/.vnc ];then mkdir -p $USER_HOME/.vnc;fi
    cp -f $SCRIPTPATH/debian-config/user-config/.pathrc $USER_HOME/.pathrc
    cp -f $SCRIPTPATH/debian-config/user-config/.vimrc $USER_HOME/.vimrc
EOF
	}

	cloneDot >$LOGPATH/out/dotfiles.log 2> \
		$LOGPATH/err/dotfiles.log &

	setIndicator "CLONE DOTFILES & CONFIGS" ${WORKINGICONS[1]} $!

	confmain >$LOGPATH/out/config.log 2> \
		$LOGPATH/err/config.log &

	setIndicator "SETTING UP DOTFILES & CONFIGS" ${WORKINGICONS[0]} $!
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	configs
fi
