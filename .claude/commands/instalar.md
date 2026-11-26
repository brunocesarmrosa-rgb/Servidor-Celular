Instale o Taikazet no celular.
1. Gere API_KEY forte (`openssl rand -hex 24`) se ainda for o valor padrão.
2. `scp -P $SSH_PORT -r termux gateway config.env localhost:~/taikazet/` (crie a pasta antes com ssh).
3. `ssh -p 8022 localhost 'bash ~/taikazet/termux/install.sh'` — acompanhe; o download do modelo (~1 GB) pode demorar.
4. Verifique RAM livre e escolha o modelo segundo docs/MODELOS.md. Registre em docs/LOG.md.
