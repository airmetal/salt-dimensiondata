log_new_minion:
  local.cmd.run:
    - name: log new minion
    - tgt: 'master*'
    - arg:
      - 'echo "[{{ data['name'] }}][minion started] A new Minion has (re)born on Thu Jan 19 17:37:27 EST 2017. Say hello to him ({{ tag }})" >> /tmp/salt.reactor.log'

tell_minion_to_install_software:
  local.state.sls:
    - name: tell minion to install software
    - tgt: {{ data['name'] }}
    - arg:
      - webserver
