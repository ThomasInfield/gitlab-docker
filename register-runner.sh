#!/bin/bash
set -e

# Fill in these variables:
GITLAB_URL="https://gitlab.example.com/"
REGISTRATION_TOKEN="glrt-Z7W1fYp4wVoN2SlwKYWyGG86MQp0OjEKdToxCw.01.121szbhi4" # Get this from GitLab UI (Admin > Runners)

# Get GitLab container IP
GITLAB_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' gitlab-docker-gitlab-1)

# Gebruik Docker network voor container communicatie
docker run --rm -it \
  --network gitlab-network \
  -v $(pwd)/data/gitlab-runner:/etc/gitlab-runner \
  -v $(pwd)/ssl:/etc/gitlab/ssl \
  --add-host=gitlab.example.com:${GITLAB_IP} \
  --add-host=registry.example.com:${GITLAB_IP} \
  gitlab/gitlab-runner:latest register \
    --non-interactive \
    --url "$GITLAB_URL" \
    --token "$REGISTRATION_TOKEN" \
    --name "docker-ansible-runner" \
    --executor "docker" \
    --tls-ca-file "/etc/gitlab/ssl/gitlab.example.com.crt" \
    --docker-volumes "/etc/gitlab/ssl:/etc/gitlab/ssl:ro" \
    --docker-volumes "/certs/client" \
    --docker-volumes "/cache" \
    --docker-privileged \
    --docker-image "alpine:latest" \
    --docker-network-mode "gitlab-network" \
    --docker-extra-hosts "gitlab.example.com:${GITLAB_IP}" \
    --docker-extra-hosts "registry.example.com:${GITLAB_IP}" \
    --docker-pull-policy "always" \
    --env "DOCKER_TLS_CERTDIR=" \
    --env "DOCKER_DRIVER=overlay2"

# Verify the registration
echo "Runner registered successfully!"
echo "Testing runner configuration..."
docker compose restart gitlab-runner
