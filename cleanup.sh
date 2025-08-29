#!/bin/bash

echo "Stopping GitLab containers..."
docker compose down

echo "Removing GitLab data..."
sudo rm -rf ./data/gitlab/*
sudo rm -rf ./data/gitlab-runner/*

echo "Removing GitLab logs..."
sudo rm -rf ./logs/gitlab/*

echo "Removing SSL certificates..."
sudo rm -rf ./ssl/*

echo "Cleanup complete! You can now start fresh with:"
echo "1. Configure your config.env file"
echo "2. Run: docker compose up -d"
