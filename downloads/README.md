# Introduction

This folder is used to store all the downloads required for the provisioning of
development environment. These are all extremely large files and therefore,
are done manually so they can be done at your own leisure.

# Instructions

## Tools

### Petalinux Tools

These tools are required for building the Xilinx boot image. It installs petalinux-build and bootgen that are required 
for the provision scripts.

For more information about the tools, see the reference guide...
https://www.xilinx.com/support/documentation/sw_manuals/xilinx2017_4/ug1144-petalinux-tools-reference-guide.pdf

### Vivado SDK

This is an SDK for modifying the hardware on the board. If you plan to do any hardware modifications, download and install
this SDK.

For more information about the tools, see the user guide...
https://www.xilinx.com/support/documentation/sw_manuals/xilinx2017_4/ug973-vivado-release-notes-install-license.pdf

### Xilinx SDK

This is an SDK for modifying the software. If you plan to write custom applications for petalinux, download and install this
SDK.

For more information about the tools, see the user guide...
https://www.xilinx.com/support/documentation/sw_manuals/xilinx2018_3/ug1283-bootgen-user-guide.pdf

## Getting the downloads 

Download each file below and place it in this folder. Note, these files must be
named exactly as they are specified below and of the version specified.

| Required |   File   |      File Name      |  Version | Link |
|----------|----------|-------------|------|--------|
| X        | Petalinux Tools |  petalinux-v2017.4-final-installer.run | v2017.4 | https://www.xilinx.com/member/forms/download/xef.html?filename=petalinux-v2017.4-final-installer.run |
|          | Vivado SDK | Xilinx_Vivado_SDK_Web_2017.4_1216_1_Lin64.bin | v2017.4 | https://www.xilinx.com/member/forms/download/xef-vivado.html?filename=Xilinx_Vivado_SDK_Web_2017.4_1216_1_Lin64.bin |
|          | Xilinx SDK | Xilinx_SDK_2017.4_1216_1_Lin64.bin | v2017.4 | https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_SDK_2017.4_1216_1_Lin64.bin |

Note about Xilinx Downloads. Due to governmental regulations we are unable to
distribute the Xilinx Petalinux Tools. When you follow the above link, you must
create a free account with Xilinx and then state a US shipping address when
downloading the files. 

## Installation

The Petalinux Tools software is installed by during the provision process. Ensure that this file is downloaded and in the downloads directory. To install the
additional tools, follow the steps below.

1. Follow **Getting the downloads** above for tools you wish to install
2. In the VM, run `cd /vagrant/downloads/`
3. To install the tool run `sudo ./tools file name.bin`
4. Follow the web installer. When it prompts for a login, login with the account you created in order to get the downloads.
5. Reboot the system
