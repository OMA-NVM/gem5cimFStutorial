#!/bin/bash

BOLD_GREEN="\t\e[1;32m==> "
TEXT_RST=" <==\e[0m"

main_dir="$(pwd)"

##############################################################################

echo -e "$BOLD_GREEN step2: \t from $main_dir $TEXT_RST"

echo -e "$BOLD_GREEN please wait a few seconds for boot.  $TEXT_RST"
echo -e "$BOLD_GREEN you can also connect from your devcontainer shell with: $TEXT_RST"
echo -e "$BOLD_GREEN \t\t ssh -p 5555 ali@localhost $TEXT_RST"
echo -e "$BOLD_GREEN \t instead of qemu window. Default password is 1234  $TEXT_RST"

qemu-system-x86_64 -enable-kvm -cpu host -m 2G -smp 4 \
	-net nic -net user,hostfwd=tcp::5555-:22 \
	-drive file=$main_dir/images/disk.raw,format=raw \
	-virtfs local,path=$main_dir/images/,mount_tag=hostshare,security_model=passthrough,id=hostshare

echo -e "$BOLD_GREEN step1 finished! $TEXT_RST"
