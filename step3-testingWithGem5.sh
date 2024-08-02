#!/bin/bash

BOLD_GREEN="\t\e[1;32m==> "
TEXT_RST=" <==\e[0m"

main_dir="$(pwd)/simulator"

##############################################################################

echo -e "$BOLD_GREEN step3: \t from $main_dir $TEXT_RST"

if [ "$1" != "-s" ]; then		# if `-s` is passed then skip these commands
	echo -e "$BOLD_GREEN Cloning our gem5 $TEXT_RST"

	# git clone --branch=cimFS https://github.com/ali10129/gem5FScim.git gem5

	echo -e "$BOLD_GREEN Compiling ./build/X86/gem5.opt, ./util/m5, ./util/m5term $TEXT_RST"
	echo -e "$BOLD_GREEN Conform if needed by pressing enter or y and enter. $TEXT_RST"

	cd "$main_dir/gem5"
	python3 `which scons` -j$(nproc) ./build/X86/gem5.opt

	cd "$main_dir/gem5/util/m5"
	python3 `which scons` build/x86/out/m5

	cd "$main_dir/gem5/util/term"
	gcc -o m5term term.c

	cd "$main_dir"
fi

echo -e "$BOLD_GREEN Running OurConfig.py $TEXT_RST"

$main_dir/gem5/build/X86/gem5.opt --debug-flags=CIMDBG $main_dir/gem5/configs/example/gem5_library/OurConfig.py

### in another vscode terminal instance, run:
##> 		./gem5/util/term/m5term 127.0.0.1 3456

echo -e "$BOLD_GREEN *** DONE *** $TEXT_RST"
