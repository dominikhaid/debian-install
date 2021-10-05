#!/bin/bash
#shopt -s nullglob dotglob
##
#Nvim
##

if ! [[ ${1} == "--debug" ]]; then
	source $SCRIPTPATH/scripts/setIndicator.sh
else
	mkdir -p ../../../logs/err
	mkdir -p ../../../logs/out
	source ../../setIndicator.sh
	LOGPATH="../../../logs"
fi

nvim() {
	nvimmain() {
		if [ -d "$USER_HOME/.local/share/nvim" ]; then rm -R $USER_HOME/.local/share/nvim; fi
		if [ -f "$USER_HOME/.local/bin/nvim" ]; then rm -R $USER_HOME/.local/bin/nvim; fi

		sudo -i -u $USER_NAME <<EOF

    if ! [ -d "$USER_HOME/.local/share/nvim" ]; then
    git clone https://github.com/neovim/neovim.git $USER_HOME/.local/share/nvim
    cd $USER_HOME/.local/share/nvim
    git checkout release-0.5
    git pull
    make CMAKE_BUILD_TYPE="RelWithDebInfo" CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$USER_HOME/.local/share/nvim"
    make install
    fi

    cd $USER_HOME && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    python3 -m pip install --user --upgrade pynvim
    cd $SCRIPTPATH
    mkdir -p $USER_HOME/.vim/pack/themes/start

    if ! [ -d "$USER_HOME/dev/ffmpegthumbnailer" ]; then
    git clone https://github.com/dirkvdb/ffmpegthumbnailer.git $USER_HOME/dev/ffmpegthumbnailer
    cd $USER_HOME/dev/ffmpegthumbnailer
    cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_GIO=ON -DENABLE_THUMBNAILER=ON .
    make
    echo $USER_PASS | sudo -S make install
    fi

    if ! [ -d "$USER_HOME/dev/fontpreview" ]; then
    git clone https://github.com/sdushantha/fontpreview  $USER_HOME/dev/fontpreview && cd $USER_HOME/dev/fontpreview && sudo make install
    ln -s $USER_HOME/dev/fontpreview/fontpreview $USER_HOME/.local/bin/fontpreview
    fi

    cd $USER_HOME
    git clone https://github.com/wbthomason/packer.nvim $USER_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

    git clone https://github.com/kabouzeid/nvim-lspinstall $USER_HOME/.local/share/nvim/site/pack/packer/start/nvim-lspinstall

    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'  

    echo $USER_PASS | sudo -S chown -R dominik:dominik $HOME/.local/share/nvim/ 
    $USER_HOME/.local/share/nvim/site/pack/packer/start/compe-tabnine/install.sh 
    
   sed -i 's/--require/require/g' $USER_HOME/.config/nvim/init.lua
   sed -i 's/--vim\./vim./g' $USER_HOME/.config/nvim/init.lua 
EOF
	}

	nvimmain >$LOGPATH/out/nvim.log 2> \
		$LOGPATH/err/nvim.log &

	setIndicator "NVIM (building from source)" ${WORKINGICONS[0]} $!

	if ! [ -L "/usr/bin/nvim" ]; then ln -s $USER_HOME/.local/share/nvim/build/bin/nvim /usr/bin/nvim; fi
	if ! [ -d "$USER_HOME/dev/backups" ]; then mkdir -p $USER_HOME/dev/backups; fi
	echo "0 5 * * 1 tar -zcf $(echo $USER_HOME)/dev/backups/nvim.tgz $(echo $USER_HOME)/.local/share/nvim" >>/var/spool/cron/crontabs/root

}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	nvim
fi
