#!/bin/bash
#shopt -s nullglob dotglob
##
# Php
##
source $SCRIPTPATH/scripts/setIndicator.sh

php() {
	phpmain() {
		# TODO test if xdebug is already installed
		apt install -y php-dev php-xdebug
		apt install -y wget php-cli php-zip unzip

		if ! command -v php &>/dev/null; then
			echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list
			wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
			apt update -y
			apt upgrade -y
			apt install -y php8.0-{mysql,cli,common,imap,ldap,xml,fpm,curl,mbstring,zip}
			sed -i 's/\[PHP]/[PHP]\n\n[xdebug]\nxdebug.mode=debug\nxdebug.start_with_request=yes\nxdebug.discover_client_host=1\nxdebug.client_port=9003\n/g' /etc/php/8.0/cli/php.ini
		fi
	}

	composer() {
		if ! command -v composer &>/dev/null; then
			wget -O composer-setup.php https://getcomposer.org/installer
			php composer-setup.php --install-dir=/usr/local/bin --filename=composer
		fi
	}

	phpdebug() {
		NPM=$(echo $(find "$USER_HOME/.nvm/versions/node" -maxdepth 1) | sed -En "s/.*\s(.*)/\1/p")
		NPM=$NPM"/bin/npm"

		if ! [ -d "$USER_HOME/dev/vscode-php-debug" ]; then
			sudo -i -u $USER_NAME <<EOF
         	    source $USER_HOME/.nvm/nvm.sh
                git clone https://github.com/xdebug/vscode-php-debug.git $USER_HOME/dev/vscode-php-debug 
                cd $USER_HOME/dev/vscode-php-debug 
                $NPM install && $NPM run build
EOF
		fi
	}

	phpmain >$LOGPATH/out/php.log 2> \
		$LOGPATH/err/php.log &

	setIndicator "PHP" ${WORKINGICONS[2]} $!

	composer >$LOGPATH/out/composer.log 2> \
		$LOGPATH/err/composer.log &

	setIndicator "COMPOSER" ${WORKINGICONS[5]} $!

	phpdebug >$LOGPATH/out/phpdebug.log 2> \
		$LOGPATH/err/phpdebug.log &

	setIndicator "VSCODE PHP DEBUG" ${WORKINGICONS[4]} $!
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	php
fi
