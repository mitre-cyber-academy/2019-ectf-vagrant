# -*- mode: ruby -*-
# vi: set ft=ruby :

required_plugins = %w( vagrant-disksize vagrant-vbguest)
$new_plugin = false
required_plugins.each do |plugin|
  # if not installed, attempt to install
  unless Vagrant.has_plugin? plugin
      system "vagrant plugin install #{plugin}"
      $new_plugin = true
    end
end

# restart vagrant if new plugin
if $new_plugin
  exec "vagrant #{ARGV.join''}"
end

if !File.file?("./downloads/petalinux-v2017.4-final-installer.run")
  raise "Error: Petalinux Tools v2017.4 is required for provisioning."
end

# load provision config
require './provision/config.rb'

# Use the current Git SHA1 as the VM version number.
$vm_version = `git rev-parse HEAD`

################################################################################
# VM Configuration
################################################################################

# Note: There is currently an issue in the xenial64 image where disk access
# times out during the boot process, extending the boot time up to a minute.
# The solution is to switch the virtual machine from using a SCSI disk
# controller to a SATA disk controller.
#
# To do so:
# 1. In VirtualBox, open Settings for your VM and go to Storage.
# 2. Remove all disk images under the SCSI controller.
# 3. Click "Add a new storage controller" and choose SATA.
# 4. For each disk image, click "Add a new storage attachment", select "Add Hard
#    Disk", and navigate to the image file.
#
# Reference:
# https://bugs.launchpad.net/cloud-images/+bug/1616794

# Note: The default disk for xenial64 has a size of 10 GB. To resize the disk:
# 1. Navigate to the VM's storage directory (e.g., ~/VirtualBox VMs/gnssta).
# 2. Convert the VMDK image to VDI format (VMDK images cannot be resized):
#    VBoxManage clonehd ubuntu-...vmdk ubuntu-...vdi --format vdi
# 3. Resize the disk (where N is the desired size in MB):
#    VBoxManage modifyhd ubuntu-...vdi --resize N
# 4. In VirtualBox, open Settings for your VM and go to Storage.
#    1. Remove the VMDK image from the list of disks.
#    2. Click "Add a new storage attachment", select "Add Hard Disk", and
#       navigate to the image file.
#
# Note that VBoxManage.exe is in C:/Program Files/Oracle/VirtualBox/ by default.

def provisionFile(path, config)
  if File.exist?(path)
    if File.directory?(path)
      config.vm.provision "shell", privileged: false, inline: "mkdir #{path}"
      for file in Dir[File.expand_path(path) + "/*"]
        privisionFile(file, config)
      end
    else
      config.vm.provision "file", source: path, destination: path
    end
  end
end

Vagrant.configure(2) do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.hostname = $hostname

  config.ssh.shell = "bash"

  # Enable X11 forwarding.
  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true

  # Configure the VM network settings.
  if $network_bridged
    if $network_ip == ""
      config.vm.network "public_network"
    else
      config.vm.network "public_network", ip: "#{$network_ip}"
    end
  else
    # Configure port forwarding.
    config.vm.network "forwarded_port", guest: 9999, host: 9999, protocol: 'tcp'
    config.vm.network "forwarded_port", guest: 8080, host: 8080, protocol: 'udp'
    config.vm.network "forwarded_port", guest: 8080, host: 8080, protocol: 'tcp'
  end

  # VirtualBox-specific configuration.
  config.vm.provider "virtualbox" do |v|
    v.name = $vm_name
    v.gui = $enable_gui_mode
    v.cpus = $num_cpus
    v.memory = $memory_size
    config.disksize.size = '100GB'

    # set video ram to something useful
    v.customize ["modifyvm", :id, "--vram", "64"]

    # enable usb
    v.customize ["modifyvm", :id, "--usbxhci", "on"]
  end

  # sync folder
  config.vm.synced_folder "./", "/vagrant"

  # configure setup ssh agent
  config.vm.provision "shell", privileged: false, path: "./provision/scripts/ssh_agent.sh"

  # provision scripts
  config.vm.provision "shell", privileged: false, path: "./provision/scripts/system_setup.sh"
  config.vm.provision "shell", privileged: false,
              path: "./provision/scripts/petalinux_install.sh"
  config.vm.provision "shell", path: "./team/customizations.sh"

  # Store the version of the Vagrant configuration used to provision the VM.
  config.vm.provision "shell",
                      inline: "echo -n \"#{$vm_version}\" > /home/vagrant/.vm_version"

  # pull git repo
  config.vm.provision "shell", privileged: false, path: "./provision/scripts/git_clone.sh", args: "#{$petalinux_git} ~/MES"

  config.vm.provision "shell", inline: "echo 'Provisioning complete, please reboot the machine now.'"


end
