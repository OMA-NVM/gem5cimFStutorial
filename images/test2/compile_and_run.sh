#!/bin/bash
set -e # to stop execution if there is an error
BOLD_GREEN="\t\e[1;32m==> "
TEXT_RST=" <==\e[0m"

echo -e "$BOLD_GREEN Running make $TEXT_RST"
sudo make

echo -e "$BOLD_GREEN Inserting kernel module $TEXT_RST"
sudo insmod mymem.ko

echo -e "$BOLD_GREEN Printing /proc/iomem $TEXT_RST"
sudo cat /proc/iomem

echo -e "$BOLD_GREEN Printing Debug message from kernel $TEXT_RST"
sudo dmesg | tail -n 5

echo -e "$BOLD_GREEN building and inserting module is finished. $TEXT_RST"
echo -e "$BOLD_GREEN Switching to O3 CPU and running test3.exe $TEXT_RST"
echo -e "$BOLD_GREEN Check the gem5 terminal as well $TEXT_RST"

m5 exit

sudo ./test2.exe

sleep 0.1
m5 exit
