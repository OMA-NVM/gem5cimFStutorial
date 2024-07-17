# gem5FScimTutorial
This is part of a tutorial: gem5 + x86 ubuntu Full System + basic CiM module + basic Application layer and kernel module

**gem5** + **qemu** tutorial on building a full-system compute-in-memory framework from scratch in gem5.


## Part0: Perquisites on your computer

1- **KVM** supported cpu

2- Install **KVM** packages:
- follow instructions on https://help.ubuntu.com/community/KVM/Installation

3- Install **docker** and add it to `sudo` group:
- follow instructions on https://docs.docker.com/engine/install/ubuntu/
- follow instructions on https://docs.docker.com/engine/install/linux-postinstall/

## Part1: Preparation

### Run `step1.InstallingUbuntu.sh`

Install **Ubuntu Server Minimal** on a disk.

Please try:
- **No updating...**
- Choose **Ubuntu Server Minimal**
- Deselect ****LVM disk** in the partition page
- Select **openSSH...**

> Please watch `misc/Step1-tutorial.webm` for installation steps:
<video src="./misc/Step1-tutorial.webm" width="1080" controls></video>


