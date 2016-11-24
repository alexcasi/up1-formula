include:
  - up1.install
  - up1.service

extend:
  up1_service:
    service:
      - watch:
        - git: up1_repo
        - file: up1_server_config
        - file: up1_client_config
      - require:
        - git: up1_repo
        - file: up1_server_config
