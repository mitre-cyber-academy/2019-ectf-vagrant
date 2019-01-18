# 2019 Collegiate eCTF Vagrant Setup

This repository contains the necessary code to create a virtual machine with all required dependencies for the 2019 Collegiate MITRE Embedded Capture the Flag event.
This repository contains a [Vagrant](https://www.vagrantup.com/) configuration script that can be used to construct a development VM for the ECTF.
Vagrant is a provisioning tool used to automatically build and configure consistent virtual machine-based development environments through a set of simple, revision controllable configuration scripts.
The file `Vagrantfile` contained in this repository includes all necessary steps for constructing and provisioning the VM.

## Tools

To host the VM using Vagrant you must have the following tools installed on your host machine:

- [VirtualBox](https://www.virtualbox.org/)
- [VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/)

Install VirtualBox and the VirtualBox Extension Pack first.
On Linux, you will also need to add your user to the `vboxusers` group.
Next, install the latest version of Vagrant.

## System Requirements

- At least **50GB** of disk space once all the above tools are installed. You will need more if you decide to install Vivado.
- At least **4 CPU** threads. You can operate with less but you will need to change the number of CPUs in `provision/config.rb`
- At least **8 GB** of ram. You can operate with less but you will need to modify the amount of provisioned ram in `provision/config.rb`. We recommend using no more than half of the total amount of RAM on your system.

## Provisioning the VM

### How it Works

Vagrant installs the system by setting up a base VM and then running scripts on the guest machine to configure it for the ECTF.
In this case, Vagrant will load a set of configuration variables form the `provision/config.rb` file and then install a base Ubuntu 16.04 box as the VM.
It will then run through each of the scripts in `provision/scripts` to customize the environment.

**git_clone.sh**

This script is a wrapper around the `git clone` command to clone a git repository into a given folder.
This script will check to make sure that the folder does not already have a git repository and will print out an error message as appropriate.

**petalinux_install**

This script installs the required packages for Petalinux Tools and then installs the tools to `/opt/pkg/petalinux`.
These tools are required to build and provision the Arty-Z7 board.

**ssh_agent.sh**

This script configures the ssh agent to automatically start and add the `~/.ssh/id_rsa` key.
Note that this key does not exist by default, but can be added to be the private key for your github repositories.

**system_setup.sh**

This script does all general system setup.
It installs the XFCE desktop environment, as well as minicom and the C man pages.
It also adds environment variables to the system for the uboot and petalinux directories.

### Provision Instructions

Follow the below instructions to provision the development environment.
Note, this will take a **LONG** time so be patient!
When the petalinux tools are being installed, you may want to get up and do something else while it works.
It could take over an hour depending on your system specs.

To use the VM:

0. Clone this repository onto your machine.
1. Navigate to the directory where this `README` is located; this should be where the `Vagrantfile` is.
2. Modify configuration options contained in `provision/config.rb` as desired (see **Configuring The VM Installation** below).
3. Download the Petalinux Tools from https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2017.4-final-installer.run and put it in the `downloads` folder.
More information about the downloads can be found in `downloads/README.md`.
Since this is a very large file we recommend having one person on your team download the file and distribute it within your team using a thumb drive.
4. Create, boot, and provision the VM via the `vagrant up` command.
Note that the GUI will appear before the vagrant provisioning process has completed.
Wait for the vagrant process to finish before interacting with the VM.
5. Restart the VM for all changes to take place.
6. Follow the instruction in the **Building the Reference Design Instructions** section of [2019-ectf-insecure-example](https://github.com/mitre-cyber-academy/2019-ectf-insecure-example) to build the petalinux reference design.


### Customizing the Provisioning System

As part of the provisioning process, a script located at `team/customizations.sh` will be run on the guest vm automatically at the end of the provsioning process.
If you want to install custom python packages or modify the environment in any way, add the commands to that bash script. Remember, if you install anything new in your environment that is required to build your submission, these need to be installed by that script.

### Vagrant Commands

To shutdown the VM, execute the following command from your host machine:

~~~
vagrant halt
~~~

To boot and log back into the VM again, execute the following commands:

~~~
vagrant up
~~~

If you wish to use the virtual machine without a GUI, the following command can be used to SSH into a running machine.
The username and password are the standard Vagrant credentials

```
username: vagrant
password: vagrant
```

~~~
vagrant ssh
~~~

**Warning, doing the following will remove EVERYTHING. Only use in dire circumstances.**

To completely **destroy** the VM (i.e. erase the VM virtual hard drive and all of
its contents), execute the following command: (you may need to also open virtual box
virtual media manager and remove the vmdk downloaded for the OS)

~~~
vagrant destroy
~~~

### Configuring The VM Installation

The Vagrant configuration file has a number of user-configurable parameters.
The default values for these parameters are usually good for most users, but some may not be appropriate for all users depending on system specs.
Any changes should typically be made to `Vagrantfile` prior to executing `vagrant up` or `vagrant provision`.
Note that you can re-provision the system using the `vagrant up --provision` command.

## Working In The VM Environment

### Shared Folders from the Host

As part of the provisioning process, vagrant will share a system folder with the VM.
This is done through the virtualbox guest additions installed on the guest.
NOTE: Vagrant shares these folders when it brings up the machine. Therefore, you must start and stop the machine using the commands listed above in **Using Vagrant**

Sharing the vagrant folder with the guest, needed for installing petalinux during the installation.
**./ -> /vagrant**

### Setting Up USB Passthrough

In order to program the SD card and view serial output from the Arty Z7 board, you will need to setup USB
passthrough in Virtualbox.
From Windows and Mac hosts you should only need to add the device in the device filters in the USB Settings. Then, 
once the guest is booted, ensure the SD card reader and Arty-Z7 devices are check in the `Settings -> USB` menu. If
they are not, select the appropriate devices.

**For Linux hosts**, you must first add the host machine user to the group, `vboxusers`.

#### Accessing UART From Inside the VM

The VM comes preinstalled with `minicom`, a program that will allow you to access the UART for the device.
First, ensure that you've added the board to the USB devices in the virtualbox VM settings.
Next, run the following command
```
sudo minicom -D /dev/ttyUSB1
```
You will need to disable the `hardware flow control` setting to have UART work appropriately.
To do so, press `control A` and then `z` while running `minicom`, then hit `O`, go to `Serial port setup`, and then press `F`.
You may want to save this configuration so you don't need to set this up every time you run `minicom`.
Once you reset the board, you should see output on the screen indicating that the board is working properly.

#### Creating Your Own Fork
Once you boot the vm for the first time, we suggest you create a fork of this repo so that you can begin to develop your solution to the ECTF.
To do this, you must fork the repo, change your fork to the origin, and then add the MITRE repo as another remote.
Follow these steps below.

1. Change the current origin remote to another name - `git remote rename origin mitre`
2. Fork the mitre repo on github (Note that you probably want to make the repo private for now so that other teams cannot borrow your development ideas)
3. Add the fork as the new origin - `git remote add origin git@github...my-fork.git`
    git@github...my-fork.git is the forked repo you made in step 2.

You can now fetch and push as you normally would using `git fetch origin` and `git push origin`

If we push out updated code, you can fetch this new code using `git fetch mitre`

## Things To Keep In Mind

After the development phase of the challenge, we will provision the attack boards with your modified versions of uboot and petalinux.
To do this, we will clone your repo and run the `Vagrantfile` provided.
After that, running the provision scripts MUST successfully build the images and games and the SD card MUST successfully boot on the Xilinx board.
Only then will it be considered a valid design.
