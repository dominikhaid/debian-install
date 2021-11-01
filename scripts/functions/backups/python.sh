#!/bin/bash
#shopt -s nullglob dotglob
##
# Python
##
source $SCRIPTPATH/scripts/setIndicator.sh

python() {
	build() {
		apt install -y python-pip
		apt install -y python3-pip

		sudo -i -u $USER_NAME <<EOF
    pip3 install 'xcffib>=0.5.0'
    pip3 install --no-deps --ignore-installed cairocffi
    pip3 install dbus-next
    pip3 install --upgrade psutil
    pip3 install qtile
    pip3 install rofimoji

    if ! [ -d $USER_HOME/dev/qtile ]; then
        cd $USER_HOME && git clone git://github.com/qtile/qtile.git $USER_HOME/dev/qtile
    fi

    if ! [ -d $USER_HOME/dev/virtualenvs/debugpy ]; then
          python3 -m venv $USER_HOME/dev/virtualenvs/debugpy 
          $USER_HOME/dev/virtualenvs/debugpy/bin/python3 -m pip install debugpy 
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

	if [ -f "$USER_HOME/bin/wal" ]; then
		ln -s $USER_HOME/.local/bin/wal /usr/bin/wal
	fi
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	python
fi
