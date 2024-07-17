#!/bin/bash

BOLD_GREEN="\t\e[1;32m==> "
TEXT_RST=" <==\e[0m"

main_dir=$(pwd)

# remove existing instance and start new one with tty followed by your command ...
DOCKER_RUN_CMD="docker run --rm -it --name qemu-gem5-running-container\
				--device=/dev/kvm \
				--volume="$main_dir/images:/ISO" \
				--volume="$main_dir/gem5:/GEM5" \
				"

##############################################################################

echo -e "$BOLD_GREEN step3: \t from $main_dir $TEXT_RST"

if [ "$1" != "-s" ]; then		# if `-s` is passed then skip these commands
	echo -e "$BOLD_GREEN Cloning our gem5 $TEXT_RST"

	git clone --branch=cimFS https://github.com/ali10129/gem5FScim.git gem5

	echo -e "$BOLD_GREEN Compiling ./build/X86/gem5.opt, ./util/m5, ./util/m5term $TEXT_RST"
	echo -e "$BOLD_GREEN Conform if needed by pressing enter or y and enter. $TEXT_RST"

	eval "$DOCKER_RUN_CMD --workdir /GEM5 qemu-gem5-image \
		scons -j$(nproc) ./build/X86/gem5.opt"

	eval "$DOCKER_RUN_CMD --workdir /GEM5/util/m5 qemu-gem5-image \
		scons build/x86/out/m5"

	eval "$DOCKER_RUN_CMD --workdir /GEM5/util/term qemu-gem5-image \
		gcc -o m5term term.c"
fi

echo -e "$BOLD_GREEN Running OurConfig.py $TEXT_RST"
eval "$DOCKER_RUN_CMD --workdir /GEM5 qemu-gem5-image \
		./build/X86/gem5.opt --debug-flags=CIMDBG configs/example/gem5_library/OurConfig.py"

### in another local terminal instance, run:
##> 		docker exec -it qemu-gem5-running-container /GEM5/util/term/m5term 127.0.0.1 3456

echo -e "$BOLD_GREEN *** DONE *** $TEXT_RST"
