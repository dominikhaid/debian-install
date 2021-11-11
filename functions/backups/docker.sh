#!/bin/bash
#shopt -s nullglob dotglob
##
# Docker
##

docker() {
	dockermain() {
		if ! [ -f "/etc/apt/sources.list.d/docker.list" ]; then
			curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
			echo \
				"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null

		fi

		#if ! command -v docker &>/dev/null; then
		apt update
		apt install -y docker-ce docker-ce-cli containerd.io
		chmod 666 /var/run/docker.sock
		#fi

		sudo -i -u $USER_NAME <<EOF
    if ! command -v docker-compose &>/dev/null; then
    pip3 install docker-compose
    fi
EOF
	}

	dockermain >$LOGPATH/out/docker.log 2> \
		$LOGPATH/err/docker.log &

	setIndicator "DOCKER & COMPOSE" ${WORKINGICONS[0]} $!
}

if [ -z $DEV_MAIN_RUN ]; then
	DEV_SINGLE_RUN=1
	source ../../installer/globals/initMain.sh
	runSingle docker
fi
