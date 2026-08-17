#!/bin/bash

set -e

echo "================================="
echo "Starting Staging Server Setup"
echo "================================="

echo "Updating packages..."
sudo apt update

# ---------------------------------
# AWS CLI
# ---------------------------------

echo "Checking AWS CLI..."

sudo apt install -y curl unzip

if command -v aws >/dev/null 2>&1; then
    echo "AWS CLI already installed:"
    aws --version
else
    echo "Installing AWS CLI..."

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
      -o "/tmp/awscliv2.zip"

    unzip -q /tmp/awscliv2.zip -d /tmp

    sudo /tmp/aws/install

    rm -rf /tmp/aws /tmp/awscliv2.zip

    echo "AWS CLI installation completed."
fi

# ---------------------------------
# Docker
# ---------------------------------

echo "Installing Docker..."

sudo apt install -y docker.io

# ---------------------------------
# Docker Compose
# ---------------------------------

echo "Installing Docker Compose plugin..."

sudo mkdir -p /usr/local/lib/docker/cli-plugins

sudo curl -SL \
  https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose

sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# ---------------------------------
# Nginx
# ---------------------------------

echo "Installing Nginx..."

sudo apt install -y nginx

# ---------------------------------
# Enable Services
# ---------------------------------

echo "Enabling Docker..."

sudo systemctl enable docker
sudo systemctl start docker

echo "Enabling Nginx..."

sudo systemctl enable nginx
sudo systemctl start nginx

# ---------------------------------
# Docker Permissions
# ---------------------------------

echo "Adding ubuntu user to Docker group..."

sudo usermod -aG docker ubuntu

# ---------------------------------
# Verify Installations
# ---------------------------------

echo "Checking installations..."

aws --version
docker --version
docker compose version
nginx -v

# ---------------------------------
# Application Directory
# ---------------------------------

echo "Creating application directory..."

sudo mkdir -p /home/ubuntu/docker-test
sudo chown -R ubuntu:ubuntu /home/ubuntu/docker-test

# ---------------------------------
# Finish
# ---------------------------------

echo "================================="
echo "Staging Server Setup Completed"
echo "================================="

echo "IMPORTANT:"
echo "Log out and log back in before"
echo "using Docker without sudo."

echo "================================="
