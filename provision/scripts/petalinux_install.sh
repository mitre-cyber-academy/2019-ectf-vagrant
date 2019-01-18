# add petalinux tools folder
sudo rm -rf /opt/pkg/petalinux
sudo mkdir -p /opt/pkg/petalinux
sudo chown vagrant /opt/pkg/petalinux
sudo chmod +x /vagrant/downloads/petalinux-v2017.4-final-installer.run

# install petalinux tools
sudo apt-get install python3 tofrodos iproute gawk xvfb git make net-tools libncurses5-dev tftpd libssl-dev flex bison libselinux1 gnupg wget diffstat chrpath socat xterm autoconf libtool tar unzip texinfo zlib1g-dev zlib1g-dev:i386 zlib1g:i386 gcc-multilib build-essential libsdl1.2-dev libglib2.0-dev screen pax gzip -y

echo "Installing petalinux to /opt/pkg/petalinux, this may take a while..."
echo "There will be no output while this process completes and could take over an hour so sit tight."
yes | /vagrant/downloads/petalinux-v2017.4-final-installer.run /opt/pkg/petalinux > /dev/null

# load env on reboot
echo 'alias petalinuxenv="source /opt/pkg/petalinux/settings.sh"' >> $HOME/.bashrc
