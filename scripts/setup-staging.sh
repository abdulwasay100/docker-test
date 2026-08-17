#!/bin/bash

set -e

echo "================================="
echo "Starting Staging Server Setup"
echo "================================="

echo "Updating packages..."
sudo apt update

echo "Installing AWS CLI..."

sudo apt install -y curl unzip

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o "/tmp/awscliv2.zip"

unzip -q /tmp/awscliv2.zip -d /tmp

sudo /tmp/aws/install

rm -rf /tmp/aws /tmp/awscliv2.zip

echo "Installing Docker, Docker Compose and required packages..."
sudo apt install -y docker.io docker-compose-plugin

echo "Installing Nginx..."
sudo apt install -y nginx

echo "Enabling Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Enabling Nginx..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo "Adding ubuntu user to Docker group..."
sudo usermod -aG docker ubuntu

echo "Checking installations..."
aws --version
docker --version
docker compose version
nginx -v

echo "Creating application directory..."
sudo mkdir -p /home/ubuntu/docker-test
sudo chown -R ubuntu:ubuntu /home/ubuntu/docker-test

echo "================================="
echo "Staging Server Setup Completed"
echo "================================="
echo "IMPORTANT: Log out and log back in"
echo "before using Docker without sudo."
