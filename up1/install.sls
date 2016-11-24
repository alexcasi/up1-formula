{% from 'up1/map.jinja' import up1 with context %}

{% for pkg in up1.packages %}
up1_pkg_{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}
{% endfor %}

up1_user:
  user.present:
    - name: {{ up1.user }}
    - home: {{ up1.directory }}

up1_group:
  group.present:
    - name: {{ up1.group }}

up1_directory:
  file.directory:
    - name: {{ up1.directory }}
    - user: {{ up1.user }}
    - group: {{ up1.group }}
    - makedirs: true

up1_repo:
  git.latest:
    - name: {{ up1.git_url }}
    - target: {{ up1.directory }}
    - user: {{ up1.user }}
    - rev: {{ up1.git_rev }}
    - force_reset: True

up1_server_config:
  file.serialize:
    - name: {{ up1.directory }}/server/server.conf
    - dataset: {{ up1.server | yaml }}
    - formatter: json
    - user: {{ up1.user }}
    - group: {{ up1.group }}

up1_client_config:
  file.managed:
    - name: {{ up1.directory }}/client/config.js
    - source: salt://up1/files/client_config.js

up1_npm_install:
  cmd.run:
    - name: npm install
    - cwd: {{ up1.directory }}/server
    - runas: {{ up1.user }}
    - onchanges:
      - git: up1_repo
