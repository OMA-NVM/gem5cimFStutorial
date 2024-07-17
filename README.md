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

> Please watch [misc/Step1-tutorial.webm](./misc/Step1-tutorial.webm) for this step.



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

> Please watch [misc/Step1-tutorial.webm](./misc/Step2-tutorial.webm) for this step.



## Part2: gem5 Example No.1
> Compiling and running a simple **hello world** application inside gem5 Full-System mode

### Run `step3-testingWithGem5.sh`

Press the **enter key** and `y` + **enter key** to compile gem5's `scons` file if asked (this might take ~20 minutes for the first time to compile).

After you see something like `src/dev/x86/pc.cc:117: warn: Don't know what interrupt to clear for console.`
in your terminal, open another terminal instance and run:

```sh
docker exec -it qemu-gem5-running-container /GEM5/util/term/m5term 127.0.0.1 3456
```
Now you are simulating your Ubuntu with gem5.

You should see `test1.cpp` in your `~/test1/` directory after running the `ls` command.
Let's compile it with:

```sh
sudo g++ test1.cpp  /usr/local/lib/libm5.a  -o test1.exe
```

then switch to **timing cpu** with `m5 exit` command, then
run the compiled code with `./test1.exe`:
```sh
m5 exit && ./test1.exe
```

It will print:
```sh
./test.exe 

	***	Hello World!	***

sum result (should be 21): 21
m5 which shutdowns gem5...
```
and exits the simulation because of `m5_exit(0ul);` line in our code.

