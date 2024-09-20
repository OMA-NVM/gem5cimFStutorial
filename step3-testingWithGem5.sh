#!/bin/bash

BOLD_GREEN="\t\e[1;32m==> "
TEXT_RST=" <==\e[0m"

main_dir="$(pwd)"		# run script inside NVM_SIMULATION/

##############################################################################

echo -e "$BOLD_GREEN step3: \t from $main_dir $TEXT_RST"

if [ "$1" == "-c" ]; then	

	echo -e "$BOLD_GREEN Compiling ./build/X86/gem5.opt, ./util/m5, ./util/m5term $TEXT_RST"
	echo -e "$BOLD_GREEN Conform if needed by pressing enter or y and enter. $TEXT_RST"

	cd "$main_dir/simulator/gem5"
	# git checkout CDNCcimFS				#comment this after merge @todo
	yes | python3 `which scons` -j$(nproc) CDNCcimFS=1 ./build/X86/gem5.opt

	cd "$main_dir/simulator/gem5/util/m5"
	python3 `which scons` build/x86/out/m5

	cd "$main_dir/simulator/gem5/util/term"
	gcc -o m5term term.c

	cd "$main_dir"
fi

if [ "$1" != "-c" ]; then	
	echo -e "$BOLD_GREEN Running OurConfig.py $TEXT_RST"

	cd "$main_dir/simulator/gem5"
	./build/X86/gem5.opt --debug-flags=CIMDBG ./configs/CDNCcimFS/OurConfig.py
	cd "$main_dir"
	### in another vscode terminal instance, move to NVM_SIMULATION/ and run:
	##> 		./simulator/gem5/util/term/m5term 127.0.0.1 3456

	echo -e "$BOLD_GREEN *** DONE *** $TEXT_RST"

fi