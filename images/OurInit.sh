#!/bin/bash

BOLD_GREEN="\t\e[1;32m==> "
TEXT_RST=" <==\e[0m"

echo -e "$BOLD_GREEN Post Installation Started $TEXT_RST"
echo -e "$BOLD_GREEN visit https://github.com/gem5/gem5-resources/blob/6734bb4940dd90f3b7c0349eedeefcf3ee405938/src/x86-ubuntu/scripts/post-installation.sh for more info! $TEXT_RST"

if [ "$1" != "-s" ]; then # if `-s` is passed then skip these commands
	echo -e "$BOLD_GREEN installing packages $TEXT_RST"
	sudo apt update
	sudo apt install -y scons git build-essential nano

	echo -e "$BOLD_GREEN Installing serial service for autologin after systemd $TEXT_RST"
	sudo cp /mnt/shared_folder/serial-getty\@.service /lib/systemd/system/

	echo -e "$BOLD_GREEN Building and installing gem5-bridge (m5) and libm5 $TEXT_RST"
	# Just get the files we need
	git clone https://github.com/gem5/gem5.git --depth=1 --filter=blob:none --no-checkout --sparse --single-branch --branch=stable
	pushd gem5
	# Checkout just the files we need
	git sparse-checkout add util/m5
	git sparse-checkout add include
	git checkout
	# Install the headers globally so that other benchmarks can use them
	cp -r include/gem5 /usr/local/include/
	# Build the library and binary
	pushd util/m5
	scons build/x86/out/m5
	cp build/x86/out/m5 /usr/local/bin/
	cp build/x86/out/libm5.a /usr/local/lib/
	popd
	popd

	# rename the m5 binary to gem5-bridge
	mv /usr/local/bin/m5 /usr/local/bin/gem5-bridge
	# Set the setuid bit on the m5 binary
	chmod 4755 /usr/local/bin/gem5-bridge
	chmod u+s /usr/local/bin/gem5-bridge

	#create a symbolic link to the gem5 binary for backward compatibility
	ln -s /usr/local/bin/gem5-bridge /usr/local/bin/m5

	# delete the git repo for gem5
	rm -rf gem5
	echo -e "$BOLD_GREEN Done building and installing gem5-bridge (m5) and libm5 $TEXT_RST"

	echo -e "$BOLD_GREEN Installing pakceges reguired for Kernel Module building $TEXT_RST"

	add_repo_line() {
		repo_line="$1"
		sources_list="/etc/apt/sources.list"

		# Check if the repository line already exists in sources.list
		if ! grep -q "^$repo_line" "$sources_list"; then
			echo "$repo_line" | sudo tee -a "$sources_list" >/dev/null
		fi
	}

	# Add Ubuntu focal repositories to apt sources list if they don't already exist
	add_repo_line "deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse"
	add_repo_line "deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse"
	add_repo_line "deb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse"
	add_repo_line "deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse"

	sudo apt update

	sudo apt install -y \
		linux-modules-5.4.0-105-generic \
		linux-image-5.4.0-105-generic \
		linux-headers-5.4.0-105-generic \
		flex \
		bison

fi

cp -r ./test1 /home/ali
cp -r ./test2 /home/ali
sudo chmod +x /home/ali/test2/compile_and_run.sh

echo -e "\n\t$BOLD_GREEN *** DONE *** $TEXT_RST\n\n"

sudo shutdown -P now
