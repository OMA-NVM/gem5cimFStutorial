#!/bin/bash

BOLD_GREEN="\t\e[1;32m==> "
TEXT_RST=" <==\e[0m"

main_dir=$(pwd)

# remove existing instance and start new one with tty followed by your command ...
DOCKER_RUN_CMD="docker run --rm -it --name qemu-gem5-running-container\
				--device=/dev/kvm \
				--memory=3g \
				--net=host \
				--env="DISPLAY" \
				--env="NO_AT_BRIDGE=1" \
				--volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
				--volume="$main_dir/images:/ISO" \
				qemu-gem5-image"

##############################################################################

echo -e "$BOLD_GREEN step2: \t from $main_dir $TEXT_RST"

xhost + # allowing X11 access to our docker container

echo -e "$BOLD_GREEN please wait a few seconds for boot.  $TEXT_RST"
echo -e "$BOLD_GREEN you can also connect from your local host shell with: $TEXT_RST"
echo -e "$BOLD_GREEN \t\t ssh -p 5555 ali@localhost $TEXT_RST"
echo -e "$BOLD_GREEN \t instead of qemu window. Default password is 1234  $TEXT_RST"

eval "$DOCKER_RUN_CMD \
		qemu-system-x86_64 -enable-kvm -cpu host -m 2G -smp 4\
		-net nic -net user,hostfwd=tcp::5555-:22\
		-drive file=/ISO/disk.raw,format=raw \
		-virtfs local,path=/ISO/,mount_tag=hostshare,security_model=passthrough,id=hostshare"

echo -e "$BOLD_GREEN step1 finished! $TEXT_RST"
