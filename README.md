# GitLab CE Docker Compose - Quickstart

1. Copy the example configuration file:
   ```sh
   cp config.env.example config.env
   ```
2. Edit your settings in `config.env`
3. Start everything with:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
4. Register the runner:
   ```bash
   chmod +x register-runner.sh
   ./register-runner.sh
   ```
5. Add your Ansible code to a GitLab project and include `.gitlab-ci.yml`
6. Add the following GitLab CI/CD variables:
   - `SSH_PRIVATE_KEY` (your private key)
   - `KNOWN_HOSTS` (optional)

Done! Your GitLab environment is ready to use.

## Additional Information

- The folders `data/`, `logs/`, `ssl/`, and `config/` are used for persistent storage and configuration.
- Only `.gitkeep` files and explicitly listed files are tracked in version control.
- See `.gitignore` for details.

For detailed instructions on configuring CI/CD variables for SSH keys and other necessary settings, refer to the documentation provided in the project.

## Starting

Start the environment with Docker Compose (example):
```sh
docker compose up -d
```