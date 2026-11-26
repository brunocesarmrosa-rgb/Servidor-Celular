#!/data/data/com.termux/files/usr/bin/bash
# Executado pelo app Termux:Boot ao ligar o celular
sleep 20
sshd
nohup bash ~/taikazet/termux/vigia.sh > /dev/null 2>&1 &
