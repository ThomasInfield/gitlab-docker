# GitLab CE Docker Compose - Quickstart

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
4. **(Belangrijk)**  
   Als je de GitLab Container Registry gebruikt, maak dan ook een self-signed SSL-certificaat aan voor je registry-domein (zoals `registry.example.com`):
   ```sh
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout ./ssl/registry.example.com.key \
     -out ./ssl/registry.example.com.crt \
     -subj "/CN=registry.example.com"
   ```
   Vervang `registry.example.com` door jouw registry-domein als dat anders is.
5. Register the runner:
   ```bash
   chmod +x register-runner.sh
   ./register-runner.sh
   ```
6. Add your Ansible code to a GitLab project and include `.gitlab-ci.yml`
7. Add the following GitLab CI/CD variables:
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