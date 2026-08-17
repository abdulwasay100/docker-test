#!/bin/bash

set -e

echo "================================="
echo "Starting Staging Server Setup"
echo "================================="

echo "Updating packages..."
sudo apt update

echo "Installing AWS CLI..."
sudo apt install -y awscli

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
