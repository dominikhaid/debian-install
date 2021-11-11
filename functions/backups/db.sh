#!/bin/bash
#shopt -s nullglob dotglob
##
# Databases / Tools
#
source $SCRIPTPATH/scripts/setIndicator.sh

db() {

	pga() {

		if ! [ -d "/usr/pgadmin4" ]; then
			apt --fix-broken install -y
			curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | apt-key add -y
			sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update -y'
			sed -i 's/deb https/deb [trusted=yes] https/g' /etc/apt/sources.list.d/pgadmin4.list
			apt update
			apt install -y pgadmin4
		fi
	}

	dbeaver() {
		if ! [ -d "/usr/share/dbeaver-ce" ]; then
			wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -P $USER_HOME/Applications
			apt install -y $USER_HOME/Applications/dbeaver-ce_latest_amd64.deb
			rm $USER_HOME/Applications/dbeaver-ce_latest_amd64.deb
		fi
	}

	mongo() {
		if ! command -v mongodb-compass &>/dev/null; then
			cd $USER_HOME/Applications/
			wget https://downloads.mongodb.com/compass/mongodb-compass_1.26.1_amd64.deb \
				-P $USER_HOME/Applications
			dpkg -i $USER_HOME/Applications/mongodb-compass_1.26.1_amd64.deb
			rm $USER_HOME/Applications/mongodb-compass_1.26.1_amd64.deb
			apt --fix-broken install -y
		fi
	}

	pga >$LOGPATH/out/pgdadmin.log 2> \
		$LOGPATH/err/pgadmin.log &

	setIndicator "PGADMIN 4" ${WORKINGICONS[2]} $!

	dbeaver >$LOGPATH/out/dbeaver.log 2> \
		$LOGPATH/err/dbeaver.log &

	setIndicator "DBEAVER" ${WORKINGICONS[2]} $!

	mongo >$LOGPATH/out/mongocompass.log 2> \
		$LOGPATH/err/mongocompass.log &

	setIndicator "MONGO-COMPASS" ${WORKINGICONS[2]} $!
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	db
fi
