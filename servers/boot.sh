echo "[***] update system..."
sudo apt-get update
sudo apt-get -y upgrade
echo "[***] disable x's..."
sudo systemctl set-default multi-user.target
echo "[***] install prerequisitues..."
sudo apt-get -y install python3-pip python3-setuptools
sudo pip3 install ansible docker docker-compose wheel
echo "[***] disable swap..."
swapoff -a
sed -i '/.*swap.*/d' /etc/fstab
echo "[***] run basic setup..."
ansible-galaxy install geerlingguy.docker
ansible-galaxy install geerlingguy.kubernetes
