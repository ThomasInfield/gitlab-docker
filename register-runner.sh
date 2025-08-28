#!/bin/bash
set -e


# Fill in these variables:
GITLAB_URL="https://gitlab.example.com/"
REGISTRATION_TOKEN="FILL_IN_YOUR_TOKEN" # Get this from GitLab UI (Admin > Runners)

docker run --rm -it \
  -v $(pwd)/data/gitlab-runner:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest register \
    --non-interactive \
    --url "$GITLAB_URL" \
    --registration-token "$REGISTRATION_TOKEN" \
    --executor "docker" \
    --docker-image "quay.io/ansible/ansible-runner:latest" \
    --description "docker-ansible-runner" \
    --tag-list "ansible,docker" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"
