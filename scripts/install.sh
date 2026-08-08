#!/bin/bash

set -e

echo "Starting server setup..."

sudo apt update

echo "Installing Docker, Docker Compose and Git..."

sudo apt install -y docker.io docker-compose-plugin git

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
git --version

echo "Configuring GitHub SSH..."

mkdir -p /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh

cat > /home/ubuntu/.ssh/config <<'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile /home/ubuntu/.ssh/github_deploy
    IdentitiesOnly yes
EOF

chmod 600 /home/ubuntu/.ssh/config

echo "GitHub SSH configuration completed."

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

echo "Getting latest application code..."

if [ -d "/home/ubuntu/docker-test/.git" ]; then
    cd /home/ubuntu/docker-test
    git pull origin main
else
    git clone git@github.com:abdulwasay100/docker-test.git /home/ubuntu/docker-test
    cd /home/ubuntu/docker-test
fi

echo "Starting application..."

sudo docker compose up -d --build

sudo docker compose ps

echo "Application deployment completed successfully."
