{% from 'up1/map.jinja' import up1 with context %}

{% set service_function = 'running' if up1.service_enabled else 'dead' %}

{% if grains.os_family == 'FreeBSD' %}
up1_init_script:
  file.managed:
    - name: /usr/local/etc/rc.d/{{ up1.service }}
    - source: salt://up1/files/freebsd-rc.sh
    - template: jinja
    - mode: 755
    - defaults:
        service_name: {{ up1.service }}
        directory: {{ up1.directory | yaml_encode }}
        user: {{ up1.user | yaml_encode }}
{% endif %}

up1_service:
  service.{{ service_function }}:
    - name: {{ up1.service }}
    - enable: {{ up1.service_enabled }}
