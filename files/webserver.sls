httpd:
  pkg:
    - installed
  file:
    - managed
    - name: /etc/httpd/conf/httpd.conf
    - user: root
    - group: root
    - mode: 644
  service:
    - running
    - watch:
      - file: httpd

httpd_pool_update:
  event:
    - wait
    - name: frontend/loadbalancer/pool/update
    - data:
        new_web_server_ip: {{ salt['grains.get']('ip4_interfaces')['eno16777728'][0] }}
    - watch:
      - service: httpd
