#!/bin/bash
#shopt -s nullglob dotglob
##
# Dotnet
##


dotnet() {
	dotmain() {
		wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
		dpkg -i packages-microsoft-prod.deb
		rm -rf packages-microsoft-prod.deb

		apt update
		apt install -y apt-transport-https
		apt install -y dotnet-sdk-5.0
		apt install -y aspnetcore-runtime-5.0
	}

	netcore() {
		sudo -i -u $USER_NAME <<EOF
   if ! command -v netcoredbg &>/dev/null; then
    git clone https://github.com/Samsung/netcoredbg.git $USER_HOME/dev/netcoredbg 
    cd $USER_HOME/dev/netcoredbg
    mkdir build 
    cd build 
    CC=clang-13 CXX=clang++-13 cmake .. 
    make 
    echo $USER_PASS | sudo -S make install
   fi
EOF
	}

	dotmain >$LOGPATH/out/dotnet.log 2> \
		$LOGPATH/err/dotnet.log &

	setIndicator "DOTNET" ${WORKINGICONS[0]} $!

	netcore >$LOGPATH/out/netcoredbg.log 2> \
		$LOGPATH/err/netcoredbg.log &

	setIndicator "NETCOREDBG (building from source)" ${WORKINGICONS[0]} $!

	if ! [ -f "/usr/bin/netcoredbg" ]; then
		ln -s /usr/local/netcoredbg /usr/bin/netcoredbg
	fi
}



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle dotnet
fi

