#!/bin/bash

set -e

echo "Starting server setup..."

sudo apt update

echo "Installing Docker..."

sudo apt install -y docker.io docker-compose-plugin

echo "Enabling Docker..."

sudo systemctl enable docker
sudo systemctl start docker

echo "Adding ubuntu user to Docker group..."

sudo usermod -aG docker ubuntu

echo "Docker installation completed."

docker --version
docker compose version

echo "Server setup completed successfully."
