#!/bin/bash
#shopt -s nullglob dotglob
##
# Python
##

python() {

	apt install -y python3-pip

	build() {
		sudo -i -u $USER_NAME <<EOF
    pip3 install 'xcffib>=0.5.0'
    pip3 install --no-deps --ignore-installed cairocffi
    pip3 install dbus-next
    pip3 install --upgrade psutil
    pip3 install qtile
    pip3 install rofimoji

    if ! [ -d $USER_HOME/qtile ]; then
        cd $USER_HOME && git clone git://github.com/qtile/qtile.git $USER_HOME/dev/qtile
    fi
EOF

		sudo -i -u $USER_NAME <<EOF
    pip3 install ueberzug
    pip3 install --user pywal
 
if [ -d "$USER_HOME/Bilder/wallpaper" ]; then
    wal -n -i "$USER_HOME/Bilder/wallpaper"
 fi
EOF
	}

	build >$LOGPATH/out/python.log 2> \
		$LOGPATH/err/python.log &

	setIndicator "Python" ${WORKINGICONS[2]} $!

	if [ -f "$USER_HOME/.local/bin/wal" ] && ! [ -f /usr/bin/wal ]; then
		ln -s $USER_HOME/.local/bin/wal /usr/bin/wal
	fi
}

if [ -z $DEV_MAIN_RUN ]; then
	DEV_SINGLE_RUN=1
	source ../../installer/globals/initMain.sh
	runSingle python
fi
