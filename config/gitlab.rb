# gitlab-docker/config/gitlab.rb

external_url 'https://gitlab.example.com'

gitlab_rails['gitlab_email_enabled'] = true
gitlab_rails['gitlab_email_from'] = 'noreply@gitlab.example.com'
gitlab_rails['gitlab_email_display_name'] = 'GitLab'
gitlab_rails['gitlab_email_reply_to'] = 'noreply@gitlab.example.com'

gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = 'smtp.example.com'
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = 'smtp_user'
gitlab_rails['smtp_password'] = 'smtp_password'
gitlab_rails['smtp_domain'] = 'example.com'
gitlab_rails['smtp_authentication'] = 'login'
gitlab_rails['smtp_enable_starttls_auto'] = true

gitlab_rails['gitlab_shell_ssh_port'] = 22

nginx['listen_port'] = 443
nginx['listen_https'] = true

letsencrypt['enable'] = false

gitlab_rails['time_zone'] = 'UTC'

gitlab_rails['gitlab_default_can_create_group'] = true

registry['enable'] = true
registry['host'] = 'registry.example.com'
registry['port'] = 5050
registry['listen_address'] = '0.0.0.0:5050'
registry['path'] = '/registry'
registry['api_url'] = 'https://registry.example.com:5050'
registry['secret_key'] = 'your_secret_key'
registry_external_url 'https://registry.example.com:5050'

gitlab_rails['gitlab_ci_cd'] = true
gitlab_rails['gitlab_ci_cd_url'] = 'https://gitlab.example.com'