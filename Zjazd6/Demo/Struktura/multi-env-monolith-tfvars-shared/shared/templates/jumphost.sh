#!/usr/bin/env bash
# Update the list of packages
sudo apt-get update
# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common ca-certificates curl lsb-release gnupg

# Add AzureCLI Repo
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

# Add Helm3 Repo
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# Add Kubectl Repo
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update Packages
sudo apt-get update

# Install Helm3, Unzip, Kubectl, Azure CLI
sudo apt-get install -y helm unzip kubectl azure-cli

# Install kubelogin
wget -P /tmp/kubelogin https://github.com/Azure/kubelogin/releases/download/v0.0.20/kubelogin-linux-amd64.zip
unzip /tmp/kubelogin/kubelogin-linux-amd64.zip -d /tmp/kubelogin/
sudo mv /tmp/kubelogin/bin/linux_amd64/kubelogin /usr/bin
sudo rm -r /tmp/kubelogin
