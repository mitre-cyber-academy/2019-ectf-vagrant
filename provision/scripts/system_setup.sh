sudo apt-get update

echo "Installing XFCE Desktop Environment"
sudo apt-get install xfce4 -y

# auto start gui on boot
echo "exec startxfce4" >> $HOME/.xinitrc
echo "[[ -z \$DISPLAY && \$XDG_VTNR -eq 1 ]] && exec startx" >> $HOME/.bashrc

echo "Installing system tools..."
sudo apt-get install gnome-terminal gnome-disk-utility -y

echo "Setting default shell to bash."
sudo rm /bin/sh
sudo ln -s /bin/bash /bin/sh

# add ectf paths to environment
sudo echo """
export ECTF_PETALINUX=/home/vagrant/MES
export ECTF_UBOOT=/home/vagrant/MES/Arty-Z7-10/components/ext_sources/u-boot-ectf
""" | sudo tee /etc/profile.d/ectf.sh
sudo apt-get install minicom manpages-dev manpages-posix-dev -y
