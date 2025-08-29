#!/bin/bash
set -e

# Load configuration from .env
if [ ! -f .env ]; then
  echo ".env not found! Please create it (e.g. by copying config.env.example) and fill in your settings."
  exit 1
fi
source .env

SSL_DIR="./ssl"
DATA_DIR="./data/gitlab"
LOGS_DIR="./logs/gitlab"
CONFIG_DIR="./config"
RUNNER_DIR="./data/gitlab-runner"
NETWORK="gitlab-network"

# Create required directories
mkdir -p "$SSL_DIR" "$DATA_DIR" "$LOGS_DIR" "$CONFIG_DIR" "$RUNNER_DIR"

# Generate self-signed SSL certificate if not present
if [ ! -f "$SSL_DIR/$DOMAIN.crt" ] || [ ! -f "$SSL_DIR/$DOMAIN.key" ]; then
  echo "Generating self-signed SSL certificate for $DOMAIN"
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$SSL_DIR/$DOMAIN.key" \
    -out "$SSL_DIR/$DOMAIN.crt" \
    -subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=MyOrg/CN=$DOMAIN" \
    -addext "subjectAltName = DNS:$DOMAIN, DNS:registry.$DOMAIN"
fi

# Create network if it does not exist
if ! docker network ls | grep -q "$NETWORK"; then
  docker network create "$NETWORK"
fi

# Create empty config if not present
if [ ! -f "$CONFIG_DIR/gitlab.rb" ]; then
  touch "$CONFIG_DIR/gitlab.rb"
fi

echo "Starting GitLab stack..."
docker compose up -d

echo "GitLab is running at https://$DOMAIN"
echo "Waiting 30 seconds for GitLab to initialize..."
sleep 30

# Display initial root password
echo "Initial root password:"
docker exec gitlab-docker-gitlab-1 cat /etc/gitlab/initial_root_password
echo "NOTE: This password will be deleted in 24 hours. Please change it immediately!"
echo "Use register-runner.sh to register the runner."