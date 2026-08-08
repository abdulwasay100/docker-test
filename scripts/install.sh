#!/bin/bash

set -e

echo "Starting server setup..."

sudo apt update

echo "Installing Docker..."

sudo apt install -y docker.io docker-compose-plugin

echo "Installing Nginx..."

sudo apt install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx

echo "Nginx installation completed."

echo "Enabling Docker..."

sudo systemctl enable docker
sudo systemctl start docker

echo "Adding ubuntu user to Docker group..."

sudo usermod -aG docker ubuntu

echo "Docker installation completed."

docker --version
docker compose version

echo "Server setup completed successfully."

echo "Configuring Nginx..."

sudo tee /etc/nginx/sites-available/app > /dev/null <<'EOF'
server {
    listen 80;

    server_name _;

    location / {
        proxy_pass http://localhost:3001;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app

sudo rm -f /etc/nginx/sites-enabled/default

sudo nginx -t

sudo systemctl restart nginx

echo "Nginx configuration completed."

echo "Starting application..."

cd /home/ubuntu/docker-test

sudo docker compose up -d --build

sudo docker compose ps

echo "Application deployment completed successfully."
