#!/bin/bash
#shopt -s nullglob dotglob
##
#GO
#

if ! [[ ${1} == "--debug" ]]; then
	source $SCRIPTPATH/scripts/setIndicator.sh
else
	source ../../setIndicator.sh
fi

go() {
	gomain() {
		sudo -i -u $USER_NAME <<EOF
         if ! [ -d /usr/local/go ]; then
            cd $USER_HOME/dev
            wget https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz
            tar -xvf go1.16.4.linux-amd64.tar.gz
            echo $USER_PASS | sudo -S mv go /usr/local
        	rm -rf $USER_HOME/dev/go1.16.4.linux-amd64.tar.gz
            rm -rf $USER_HOME/dev/go
            echo $USER_PASS | sudo -S ln -s /usr/local/go/bin/go /usr/bin/go
            echo $USER_PASS | sudo -S ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt
         fi

        /usr/local/go/bin/go get -u github.com/go-delve/delve/cmd/dlv
        /usr/local/go/bin/go get github.com/jesseduffield/lazygit
EOF

	}

	glowInst() {
		sudo -i -u $USER_NAME <<EOF
    if ! command -v glow &>/dev/null; then
        cd $USER_HOME
        git clone https://github.com/charmbracelet/glow.git
        cd glow
        /usr/local/go/bin/go build
	    if ! [ -f /usr/bin/glow ]; then echo $USER_PASS | sudo -S rm -rf /usr/bin/glow;fi
       echo $USER_PASS | sudo -S ln -s $USER_HOME/glow/glow /usr/bin/glow
    fi
EOF
	}

	lz4() {
		sudo -i -u $USER_NAME <<EOF
        if ! command -v lz4 &>/dev/null; then
            git clone https://github.com/lz4/lz4 $USER_HOME/dev/lz4
            cd $USER_HOME/dev/lz4
            make
            echo $USER_PASS | sudo -S make install
        fi
EOF
	}

	gomain >$LOGPATH/out/go.log 2> \
		$LOGPATH/err/go.log &

	setIndicator "GO" ${WORKINGICONS[2]} $!

	glowInst >$LOGPATH/out/glow.log 2> \
		$LOGPATH/err/glow.log &

	setIndicator "GLOW" ${WORKINGICONS[6]} $!

	lz4 >$LOGPATH/out/lz4.log 2> \
		$LOGPATH/err/lz4.log &

	setIndicator "LZ4" ${WORKINGICONS[1]} $!

}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	go
fi
