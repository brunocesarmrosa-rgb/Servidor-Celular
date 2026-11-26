#!/data/data/com.termux/files/usr/bin/bash
# Reinicia o que cair. Rodar em loop: nohup bash termux/vigia.sh &
while true; do bash "$(dirname "$0")/start.sh" >/dev/null 2>&1; sleep 60; done
