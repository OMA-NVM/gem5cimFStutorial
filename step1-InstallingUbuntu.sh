#!/bin/bash

BOLD_GREEN="\t\e[1;32m==> "
TEXT_RST=" <==\e[0m"

main_dir="$(pwd)/cdnc"

##############################################################################

echo -e "$BOLD_GREEN step1: \t from $main_dir $TEXT_RST"

cd "$main_dir/images"

wget -nc https://releases.ubuntu.com/22.04/ubuntu-22.04.4-live-server-amd64.iso

cd "$main_dir"

qemu-img create -f raw $main_dir/images/disk.raw 10G

echo -e "$BOLD_GREEN start installing your custom ubuntu... $TEXT_RST"

qemu-system-x86_64 -enable-kvm -cpu host \
	-net nic -net user \
	-drive file=$main_dir/images/disk.raw,format=raw \
	-m 2G \
	-smp 4 \
	-boot d \
	-cdrom $main_dir/images/ubuntu-22.04.4-live-server-amd64.iso

echo -e "$BOLD_GREEN step1 finished! $TEXT_RST"
