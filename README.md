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

Please watch [](./misc/Step1-tutorial.webm) for this step.



### Run `step2.PostInstallation.sh`

Wait a few seconds,
Then connect with `ssh -p 5555 ali@localhost` from your local PC.
The default pass is `1234`. Confirm adding the ssh-key with `yes` and press enter.

if you saw:
```sh
ssh -p 5555 ali@localhost
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
...
```
then run the printed command in the message, staring with:
`ssh-keygen ... `
and after that run `ssh ...`

---

Run the following commands after connection:
```sh
sudo mkdir /mnt/shared_folder
sudo mount -t 9p -o trans=virtio,version=9p2000.L hostshare /mnt/shared_folder
cd /mnt/shared_folder
ls
sudo chmod +x OurInit.sh
sudo ./OurInit.sh
```

Please watch [](./misc/Step2-tutorial.webm) for this step.