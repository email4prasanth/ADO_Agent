#!/bin/bash

set -e

ADMIN_USER="adminuser"
TERRAFORM_VERSION="1.15.6"
PACKER_VERSION="1.15.0"

echo "======================================="
echo "Starting Server Bootstrap"
echo "======================================="

echo "Updating package repository..."

sudo apt update

echo "Installing OpenJDK 17..."

sudo apt install -y openjdk-17-jdk

java -version

echo "Installing common utilities..."

sudo apt install -y unzip jq curl wget net-tools software-properties-common

echo "Verifying unzip installation..."

which unzip

echo "Installing Azure CLI..."

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

az --version

echo "Installing Docker..."

curl -fsSL https://get.docker.com | sudo bash

sudo usermod -aG docker ${ADMIN_USER}

sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl restart docker

docker --version

echo "Installing Terraform ${TERRAFORM_VERSION}..."

cd /usr/local/bin

sudo wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

sudo unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip

sudo rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

terraform --version

echo "Installing Packer ${PACKER_VERSION}..."

sudo wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip

sudo unzip -o packer_${PACKER_VERSION}_linux_amd64.zip

sudo rm -f packer_${PACKER_VERSION}_linux_amd64.zip

packer --version

echo "Installing Ansible..."

sudo apt update

sudo add-apt-repository --yes --update ppa:ansible/ansible

sudo apt install -y ansible

ansible --version

echo "Configuring Ansible..."

sudo mkdir -p /etc/ansible

sudo bash -c 'ansible-config init --disabled > /etc/ansible/ansible.cfg'

sudo sed -i 's/^;host_key_checking=True/host_key_checking=False/' /etc/ansible/ansible.cfg

if sudo grep -q "^;remote_user=" /etc/ansible/ansible.cfg; then
sudo sed -i "s/^;remote_user=.*/remote_user='${ADMIN_USER}'/" /etc/ansible/ansible.cfg
else
echo "remote_user=${ADMIN_USER}" | sudo tee -a /etc/ansible/ansible.cfg
fi

echo ""
echo "Ansible Configuration:"
sudo grep -i host_key_checking /etc/ansible/ansible.cfg || true
sudo grep -i remote_user /etc/ansible/ansible.cfg || true

echo ""
echo "======================================="
echo "Installation Completed Successfully"
echo "======================================="

echo ""
echo "Installed Versions"
echo "------------------"

java -version
terraform --version
packer --version
docker --version
az --version | head -3
ansible --version | head -1

echo ""
echo "IMPORTANT:"
echo "Logout/Login or reboot for Docker group membership to take effect."
echo ""
echo "Run:"
echo "sudo reboot"
