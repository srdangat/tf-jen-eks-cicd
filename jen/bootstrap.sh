#!/bin/bash

# Update the package list
sudo apt update -y

# Install necessary packages: fontconfig, OpenJDK 17 runtime, and unzip
sudo apt install fontconfig openjdk-17-jre unzip -y

# Download and install the Jenkins GPG key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add the Jenkins repository to the sources list with the GPG key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package list again to include Jenkins repository
sudo apt-get update -y

# Install Jenkins
sudo apt-get install jenkins -y

# Start the Jenkins service
sudo systemctl start jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Download the AWS CLI version 2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip the AWS CLI package
unzip awscliv2.zip

# Install the AWS CLI
sudo ./aws/install

# Install Terraform
# Download and add the HashiCorp GPG key
wget -q -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add the HashiCorp repository to the sources list with the GPG key
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update the package list again to include the HashiCorp repository
sudo apt update -y

# Install Terraform
sudo apt install -y terraform

# Install kubectl
# Get the latest stable version of kubectl
KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

# Download the latest kubectl binary
sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

# Make the kubectl binary executable
sudo chmod +x ./kubectl

# Move kubectl to /usr/local/bin for global access
sudo mv ./kubectl /usr/local/bin/kubectl
