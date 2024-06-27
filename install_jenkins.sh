#!/bin/bash

LOG_FILE=/tmp/jenkins_install.log

echo "Starting Jenkins installation" > $LOG_FILE

# Update package list and install dependencies
echo "Updating package list..." >> $LOG_FILE
sudo apt update >> $LOG_FILE 2>&1

echo "Installing OpenJDK 11..." >> $LOG_FILE
sudo apt install openjdk-11-jdk -y >> $LOG_FILE 2>&1

# Add Jenkins key and repository
echo "Adding Jenkins key..." >> $LOG_FILE
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5BA31D57EF5975CA >> $LOG_FILE 2>&1

echo "Adding Jenkins repository..." >> $LOG_FILE
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - >> $LOG_FILE 2>&1
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' >> $LOG_FILE 2>&1

# Install required packages
echo "Installing CA certificates..." >> $LOG_FILE
sudo apt install ca-certificates -y >> $LOG_FILE 2>&1

echo "Updating package list..." >> $LOG_FILE
sudo apt update >> $LOG_FILE 2>&1

echo "Installing Git..." >> $LOG_FILE
sudo apt install git -y >> $LOG_FILE 2>&1

echo "Installing Maven..." >> $LOG_FILE
sudo apt install maven -y >> $LOG_FILE 2>&1

# Add Jenkins repository again (seems to be repeated)
echo "Adding Jenkins repository again..." >> $LOG_FILE
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' >> $LOG_FILE 2>&1

echo "Updating package list..." >> $LOG_FILE
sudo apt update >> $LOG_FILE 2>&1

echo "Installing Jenkins..." >> $LOG_FILE
sudo apt install jenkins -y >> $LOG_FILE 2>&1

# Install Terraform
echo "Installing Terraform..." >> $LOG_FILE
sudo apt-get update -y >> $LOG_FILE 2>&1
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >> $LOG_FILE 2>&1
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint >> $LOG_FILE 2>&1
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >> $LOG_FILE 2>&1
sudo apt update >> $LOG_FILE 2>&1
sudo apt install terraform -y >> $LOG_FILE 2>&1

# Install Docker
echo "Installing Docker..." >> $LOG_FILE
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y >> $LOG_FILE 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - >> $LOG_FILE 2>&1
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> $LOG_FILE 2>&1
sudo apt-key fingerprint 0EBFCD88 >> $LOG_FILE 2>&1
sudo apt-get update -y >> $LOG_FILE 2>&1
sudo apt-get install docker-ce docker-ce-cli containerd.io -y >> $LOG_FILE 2>&1

# Add users to Docker group
echo "Adding Jenkins and Ubuntu users to Docker group..." >> $LOG_FILE
sudo usermod -aG docker jenkins >> $LOG_FILE 2>&1
sudo usermod -aG docker ubuntu >> $LOG_FILE 2>&1
sudo usermod -aG docker $USER >> $LOG_FILE 2>&1

# Install kubectl
echo "Installing kubectl..." >> $LOG_FILE
curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl >> $LOG_FILE 2>&1
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" >> $LOG_FILE 2>&1
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl >> $LOG_FILE 2>&1
chmod +x kubectl >> $LOG_FILE 2>&1
mkdir -p ~/.local/bin >> $LOG_FILE 2>&1
mv ./kubectl ~/.local/bin/kubectl >> $LOG_FILE 2>&1

# Install Kubernetes
echo "Installing Kubernetes..." >> $LOG_FILE
sudo apt-get update >> $LOG_FILE 2>&1
sudo apt-get install -y ca-certificates curl >> $LOG_FILE 2>&1
sudo apt-get install -y apt-transport-https >> $LOG_FILE 2>&1
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg >> $LOG_FILE 2>&1
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list >> $LOG_FILE 2>&1
sudo apt-get update -y >> $LOG_FILE 2>&1
sudo apt-get install -y kubectl=1.21.0-00 >> $LOG_FILE 2>&1

# Install AWS CLI
echo "Installing AWS CLI..." >> $LOG_FILE
sudo apt install awscli -y >> $LOG_FILE 2>&1

# Install Helm
echo "Installing Helm..." >> $LOG_FILE
wget https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz >> $LOG_FILE 2>&1
tar -zxvf helm-v3.2.4-linux-amd64.tar.gz >> $LOG_FILE 2>&1
sudo mv linux-amd64/helm /usr/local/bin/helm >> $LOG_FILE 2>&1

# Clearing screen and finishing installation
echo "Clearing screen..." >> $LOG_FILE
sleep 5
clear

echo "Jenkins installation completed" >> $LOG_FILE
echo "This is the default password: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)" >> $LOG_FILE

# Print the completion message
echo 'Jenkins is installed'
echo 'This is the default password: ' $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
