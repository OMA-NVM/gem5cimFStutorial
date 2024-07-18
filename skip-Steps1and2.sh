#!/bin/bash
set -e # to stop execution if there is an error

BOLD_GREEN="\t\e[1;32m==> "
BOLD_YELLOW="\e[1;33m"
TEXT_RST=" \e[1;32m <==\e[0m"

main_dir=$(pwd)

echo -e "$BOLD_GREEN downloading our prebuild $BOLD_YELLOW disk.raw  $TEXT_RST"

cd ./images

wget -nc https://bwsyncandshare.kit.edu/s/ZJ4TYR7nZtJWkYP/download/disk.raw.tar.gz

echo -e "$BOLD_GREEN extracting with $BOLD_YELLOW tar... $TEXT_RST"
tar -xzvf disk.raw.tar.gz

cd "$main_dir"

echo -e "$BOLD_GREEN step1 and step2 $BOLD_YELLOW finished! $TEXT_RST"
