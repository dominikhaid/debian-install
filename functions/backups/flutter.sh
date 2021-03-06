#!/bin/bash
#shopt -s nullglob dotglob
##
#Nvim
##


flutter() {
	fluttermain() {

		apt install -y clang cmake ninja-build pkg-config libgtk-3-dev

		if ! [ -d "$USER_HOME/dev/flutter" ]; then
			git clone https://github.com/flutter/flutter.git -b stable $USER_HOME/dev/flutter
		fi

		if ! [ -d "$USER_HOME/dev/android-studio" ]; then
			wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2020.3.1.24/android-studio-2020.3.1.24-linux.tar.gz -P $USER_HOME/dev
			cd $USER_HOME/dev
			tar -xvf android-studio-2020.3.1.24-linux.tar.gz
			rm android-studio-2020.3.1.24-linux.tar.gz
			chown -R $USER_NAME:$USER_NAME $USER_HOME/dev/android-studio
			chown -R $USER_NAME:$USER_NAME $USER_HOME/dev/flutter
		fi

		sudo -i -u $USER_NAME <<EOF
        $HOME/dev/flutter/bin/flutter precache
EOF
	}

	fluttermain >$LOGPATH/out/flutter.log 2> \
		$LOGPATH/err/flutter.log &

	setIndicator "Flutter / Dart" ${WORKINGICONS[2]} $!

}



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle flutter
fi

