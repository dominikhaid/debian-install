#!/bin/bash
#shopt -s nullglob dotglob
##
#QEMU KVM
#
source $SCRIPTPATH/scripts/setIndicator.sh

qemu() {
	qemumain() {
		if ! command -v virt-qemu-run &>/dev/null; then
			apt install -y qemu-kvm libvirt-clients libvirt-daemon-system \
				bridge-utils libguestfs-tools genisoimage virtinst libosinfo-bin virt-manager
			/sbin/adduser $USER_NAME libvirt
			/sbin/adduser $USER_NAME libvirt-qemu
			/sbin/addgroup libvirt
			/sbin/addgroup libvirt-qemu
		fi
	}

	if ! [ -z $(dmesg | grep "Hypervisor detected") ]; then
		qemumain >$LOGPATH/out/qemu.log 2> \
			$LOGPATH/err/qemu.log &

		setIndicator "QEMU & KVM" ${WORKINGICONS[0]} $!
	fi
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	qemu
fi
