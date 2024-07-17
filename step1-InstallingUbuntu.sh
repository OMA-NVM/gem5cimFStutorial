#!/bin/bash
set -e # to stop execution if there is an error

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

echo -e "$BOLD_GREEN step1: \t from $main_dir $TEXT_RST"

docker build -t qemu-gem5-image .

cd ./images
wget -nc https://releases.ubuntu.com/22.04/ubuntu-22.04.4-live-server-amd64.iso

cd "$main_dir"

eval "$DOCKER_RUN_CMD qemu-img create -f raw /ISO/disk.raw 10G"

xhost + # allowing X11 access to our docker container

echo -e "$BOLD_GREEN start installing your custom ubuntu... $main_dir $TEXT_RST"

eval "$DOCKER_RUN_CMD \
		qemu-system-x86_64 -enable-kvm -cpu host \
		-net nic -net user \
		-drive file=/ISO/disk.raw,format=raw \
		-m 2G \
		-smp 4 \
		-boot d \
		-cdrom /ISO/ubuntu-22.04.4-live-server-amd64.iso"

echo -e "$BOLD_GREEN step1 finished! $TEXT_RST"
