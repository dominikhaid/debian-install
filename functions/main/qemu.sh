#!/bin/bash
#shopt -s nullglob dotglob
##
#QEMU KVM
#


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



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle qemu
fi

