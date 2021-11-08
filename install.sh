#!/bin/bash
#shopt -s nullglob dotglob
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
SCRIPTID=$BASHPID
LOGPATH=$SCRIPTPATH/logs
SKIPTIME=3
SKIPDIALOG=1
C_RED=$(tput setaf 1)
C_PURPLE=$(tput setaf 5)
C_BLUE=$(tput setaf 4)
C_ORANGE=$(tput setaf 3)
C_GREEN=$(tput setaf 2)
C_RESET=$(tput sgr0)

source $SCRIPTPATH/scripts/instDep.sh
#make sure the script runs
scriptDependend

                                                                          
OS=$(cat logs/out/hardware_before.log | gawk -F: '{ print $2 }' | gawk -e 'match($0, /'Debian'/)')                                                  
                                                                          
if ! [[ $OS == " " ]]; then                                               
OS=$(cat logs/out/hardware_before.log | gawk -F: '{ print $2 }' | gawk -e 'match($0, /'Raspbian'/)')                                                
fi

KERNEL=$(cat $SCRIPTPATH/logs/out/hardware_before.log | gawk -F: '{ print $1 $2}' | gawk -e 'match($0, /'Kernel'/)' | sed 's/Kernel//g')
GPU=$(cat $SCRIPTPATH/logs/out/hardware_before.log | gawk -F: '{ print $1 $2}' | gawk -e 'match($0, /'GPU'/)' | sed 's/GPU//g')


if ! [[ $OS =~ "Debian" ]] && ! [[ $OS =~ "Raspbian" ]]; then
	echo "
	echo "
        This script is written for Debian OS, the detect OS is: $OS.
        Aborting !!
        "
	exit
fi

if ! [[ $KERNEL =~ "amd64" ]]; then
	echo "
        Detected AMD64 architecture pulling....
        "
	git checkout main && git pull
fi

if [[ $KERNEL =~ "armhf" ]] || [[ $KERNEL =~ "arm64" ]] || [[ $KERNEL =~ "arm7l" ]] || [[ $KERNEL =~ "v7l" ]]; then
	echo "
        Detected ARM architecture pulling....
        "
	git checkout rasberry4 && git pull
fi

# Read Password
printf "User Name: "
read USER_NAME
stty -echo
printf "User Password: "
read USER_PASS
stty echo
printf "\n"
USER_HOME="/home/$USER_NAME"
TEST_USER=$(cat /etc/passwd | gawk -F: '{ print $1 }' | gawk -e 'match($0, /'$USER_NAME'/) {print substr( $1, RSTART, RLENGTH )}')

if [[ "$TEST_USER" == "" ]]; then
	echo "
        No user: $USER_NAME 
        please add the user with /sbin/useradd USERNAME
        and run the script again!"
	exit
fi

#source $SCRIPTPATH/scripts/setIndicator.sh
source $SCRIPTPATH/scripts/createStatusline.sh
source $SCRIPTPATH/scripts/colorText.sh
source $SCRIPTPATH/scripts/pre.sh
source $SCRIPTPATH/scripts/main.sh
source $SCRIPTPATH/scripts/post.sh
source $SCRIPTPATH/scripts/serv.sh
source $SCRIPTPATH/scripts/installer.sh

echo "

$C_BLUE
╭─────────────────────────────────────────────────────────────────────────────────────────────╮
│$C_ORANGE                                                                                             $C_BLUE│
│$C_ORANGE We already installed some dependencies if u can't see the simlie $C_GREEN $C_ORANGE, you can abort the      $C_BLUE│
│$C_ORANGE installation now and resource your terminal. The glyphs should be visible after that.       $C_BLUE│
│$C_ORANGE Anyway you can continue the installation without glyphs.                                    $C_BLUE│
│$C_ORANGE                                                                                             $C_BLUE│
│$C_ORANGE In normal mode you are able skip certain installation steps, if you choose automatic        $C_BLUE│
│$C_ORANGE the installation will be slightly faster. In both modes the installation will be fully      $C_BLUE│
│$C_ORANGE automatic if you do not interact with the script.                                           $C_BLUE│
│$C_ORANGE                                                                                             $C_BLUE│
│$C_ORANGE The installer will run the installation for the following user:                             $C_BLUE│
│$C_GREEN $USER_NAME                                                                                     $C_BLUE│
│                                                                                             │
╰─────────────────────────────────────────────────────────────────────────────────────────────╯

"

printf "$C_ORANGE($C_GREEN Q $C_ORANGE)uit ($C_GREEN N $C_ORANGE)ormal ($C_GREEN A $C_ORANGE)utomatic ($C_GREEN S $C_ORANGE)ever ?"
echo "$C_RESET"

read answer
case $answer in
[Aa]*) SKIPDIALOG=1 && echo "$C_ORANGE automatic install for $USER_NAME, lean back $C_RESET" ;;
[Nn]*) SKIPDIALOG=0 && echo "$C_ORANGE normal install for $USER_NAME, feel free to skip certain install blocks.$C_RESET" ;;
[Ss]*) SKIPDIALOG=1 && echo "$C_ORANGE server install for $USER_NAME, lean back $C_RESET" ;;
[Qq]*) exit ;;
*) SKIPDIALOG=0 && echo "$C_ORANGE normal install for $USER_NAME, feel free to skip certain install blocks.$C_RESET" ;;
esac

if [[ $answer == "S" ]] || [[ $answer == "s" ]]; then
	install PRE MAIN POST SERV
else
	SERV=()
	install PRE MAIN POST SERV
fi
