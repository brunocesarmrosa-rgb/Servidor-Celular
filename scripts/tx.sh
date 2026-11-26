#!/usr/bin/env bash
# Executa um comando dentro do Termux via ADB (sem SSH). Uso: scripts/tx.sh "ls ~"
# Saída vai para ~/taikazet/logs/tx.out no celular (lida em seguida).
source "$(dirname "$0")/../config.env"
DEV="$PHONE_IP:$ADB_PORT"
adb -s "$DEV" shell am startservice --user 0 -n com.termux/com.termux.app.RunCommandService \
  -a com.termux.RUN_COMMAND \
  --es com.termux.RUN_COMMAND_PATH /data/data/com.termux/files/usr/bin/bash \
  --esa com.termux.RUN_COMMAND_ARGUMENTS "-c,mkdir -p ~/taikazet/logs; ($1) > ~/taikazet/logs/tx.out 2>&1" \
  --ez com.termux.RUN_COMMAND_BACKGROUND true >/dev/null
echo "Enviado. Para ver a saída use SSH, ou: adb -s $DEV shell run-as com.termux cat files/home/taikazet/logs/tx.out (só em builds debug)"
