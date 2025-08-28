#!/bin/bash
set -e

# Fill in these variables:
GITLAB_URL="https://gitlab.example.com/"
REGISTRATION_TOKEN="glrt-ynF3FCBHoPQG1xyz3o-F0W86MQp0OjEKdToxCw.01.121ycc0rz" # Get this from GitLab UI (Admin > Runners)

# Use the Docker network for container communication
docker run --rm -it \
  --network gitlab-network \
  -v $(pwd)/data/gitlab-runner:/etc/gitlab-runner \
  -v $(pwd)/ssl:/etc/gitlab/ssl \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --add-host=gitlab.example.com:$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' gitlab-docker-gitlab-1) \
  gitlab/gitlab-runner:latest register \
    --non-interactive \
    --url "$GITLAB_URL" \
    --token "$REGISTRATION_TOKEN" \
    --name "docker-ansible-runner" \
    --executor "docker" \
    --tls-ca-file "/etc/gitlab/ssl/gitlab.example.com.crt" \
    --docker-volumes "/etc/gitlab/ssl:/etc/gitlab/ssl:ro" \
    --docker-image "quay.io/ansible/ansible-runner:latest" \
    --tls-ca-file "/etc/gitlab/ssl/gitlab.example.com.crt"
