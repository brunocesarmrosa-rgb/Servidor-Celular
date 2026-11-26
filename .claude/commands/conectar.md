Conecte ao celular (USB primeiro; Wi-Fi como alternativa).
1. Se não existir `config.env`, copie de `config.env.example`.
2. Rode `adb devices`. Se `unauthorized`, peça para aceitar "Permitir depuração USB" no celular. Se `adb` não existir: `winget install Google.PlatformTools` e reabra o terminal.
3. Abra o Termux no celular: `adb shell monkey -p com.termux -c android.intent.category.LAUNCHER 1`.
4. Peça ao usuário para colar UMA VEZ no Termux (você não consegue digitar lá antes do SSH):
   `pkg install -y openssh && passwd && sshd && echo allow-external-apps=true >> ~/.termux/termux.properties && termux-reload-settings`
   Dica: envie o texto com `adb shell input text` (troque espaços por %s) para ele só apertar Enter.
5. `adb forward tcp:8022 tcp:8022` e teste `ssh -p 8022 localhost "uname -a; free -m; nproc"`. Gere chave (`ssh-keygen`) e copie para ~/.ssh/authorized_keys do Termux para não pedir senha.
6. Em todos os outros comandos, use `ssh -p 8022 localhost` e `scp -P 8022 ... localhost:`. Registre em docs/LOG.md.
