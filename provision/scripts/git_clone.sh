if [ -d $2 ]; then
	echo "The git repo already exists in the guest machine. If you are reprovisioning, do a git pull from within the VM or remove the directory and try again."
	exit
fi

rm -rf ~/MES/ && mkdir ~/MES && git clone $1 $2
