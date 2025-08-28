#!/bin/bash
set -e

# Load configuration from config.env
if [ ! -f ./config.env ]; then
  echo "config.env not found! Please create it and fill in your settings."
  exit 1
fi
source ./config.env

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
    -subj "/CN=$DOMAIN"
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
docker-compose up -d

echo "GitLab is running at https://$DOMAIN"
echo "Use register-runner.sh to register the runner."