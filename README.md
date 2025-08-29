# GitLab CE Docker Compose - Quickstart

## Cleanup and Reset

If you need to start fresh or reset your GitLab installation:

```bash
./cleanup.sh
```

This script will:
- Stop all GitLab containers
- Remove all GitLab data
- Remove all logs
- Remove SSL certificates
- Give you a clean slate to start over

## Initial Setup

1. Copy the example configuration file:
   ```sh
   cp config.env.example .env
   ```
2. Edit your settings in `.env`
3. Start everything with:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
4. **Important**: The initial root password will be displayed after setup. You can also retrieve it manually within the first 24 hours using:
   ```bash
   docker exec gitlab-docker-gitlab-1 cat /etc/gitlab/initial_root_password
   ```
   Make sure to change this password immediately after your first login!

5. **(Belangrijk)**  
    Maak een self-signed SSL-certificaat aan voor je GitLab-domein. Gebruik voor zowel GitLab als de Container Registry hetzelfde certificaat met een Subject Alternative Name (SAN):

    **Voorbeeld: SAN-certificaat genereren voor gitlab.example.com**
    ```sh
    openssl req -newkey rsa:2048 -nodes \
       -keyout ./ssl/gitlab.example.com.key \
       -x509 -days 365 \
       -out ./ssl/gitlab.example.com.crt \
       -subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=MyOrg/CN=gitlab.example.com" \
       -addext "subjectAltName = DNS:gitlab.example.com, DNS:registry.example.com"
    ```
    Dit certificaat is geldig voor zowel `gitlab.example.com` als `registry.example.com`. Pas de domeinnamen aan als je andere namen gebruikt.
6. Register the runner:
   1. Log in to GitLab as root user
   2. Go to **Admin Area** > **Overview** > **Runners** (or navigate to `https://gitlab.example.com/admin/runners`)
   3. Note down the registration token shown at the top of the page
   4. Edit `register-runner.sh` and update:
      - `GITLAB_URL`: Your GitLab URL (e.g., "https://gitlab.example.com/")
      - `REGISTRATION_TOKEN`: The token you copied in step 3
   5. Make the script executable and run it:
   ```bash
   chmod +x register-runner.sh
   ./register-runner.sh
   ```
   6. The runner should now appear in your GitLab Runners overview page
   7. Optional: Configure additional runner settings in the GitLab UI:
      - Tags
      - Run untagged jobs
      - Lock to project
      - Maximum timeout

   **Note**: The runner registration uses the same SSL certificate as GitLab. Make sure your SSL certificate is properly set up in the `./ssl` directory before registering the runner.

7. Add your Ansible code to a GitLab project and include `.gitlab-ci.yml`
8. Add the following GitLab CI/CD variables:
   - `SSH_PRIVATE_KEY` (your private key)
   - `KNOWN_HOSTS` (optional)

Done! Your GitLab environment is ready to use.

## Additional Information

- The folders `data/`, `logs/`, `ssl/`, and `config/` are used for persistent storage and configuration.
- Only `.gitkeep` files and explicitly listed files are tracked in version control.
- See `.gitignore` for details.
- **Note:** Docker Compose automatically loads variables from a file named `.env` in the project root.

For detailed instructions on configuring CI/CD variables for SSH keys and other necessary settings, refer to the documentation provided in the project.

## Starting

Start the environment with Docker Compose (example):
```sh
docker compose up
```

## Test Your Runner

1. Create a new project in GitLab
2. Create a new file `.gitlab-ci.yml` with this content:
   ```yaml
   test-job:
     script:
       - echo "My first job"
       - echo "Runner is working!"
       - echo "Current date is $(date)"
   ```
3. Commit and push the file
4. Go to your project's **CI/CD > Pipelines** to see the job running

You should see your job execute successfully with the output messages. If this works, your runner is correctly configured!

For a more complete test that uses Docker:
```yaml
test-docker:
  image: alpine:latest
  script:
    - echo "Testing from Alpine container"
    - uname -a
    - cat /etc/os-release
```