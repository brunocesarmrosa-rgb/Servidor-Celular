# Projeto: Taikazet — Agente Offline de Sugestão de Produtos

Você (Claude Code) é o operador deste projeto. Rode no PC do dono, que está na mesma rede Wi-Fi do celular Android.
Responda sempre em português do Brasil.

## Este repositório é o acervo do projeto (Servidor-Celular)
Repositório: github.com/brunocesarmrosa-rgb/Servidor-Celular. É a fonte única de verdade entre todos os PCs.
- **Ao iniciar qualquer sessão:** `git pull`. Leia docs/LOG.md (últimas entradas) e docs/ROADMAP.md antes de agir.
- **Ao terminar cada etapa:** registre em docs/LOG.md (data, PC, o que fez, resultado, problemas), atualize docs/ROADMAP.md (marque [x], adicione o que descobriu) e faça `git add -A && git commit -m "<resumo em português>" && git push`.
- **Melhoria contínua:** quando um script falhar e você corrigir, corrija NO REPOSITÓRIO (não só no celular) e documente o porquê em docs/APRENDIZADOS.md, para a próxima sessão não repetir o erro.
- **Nunca commite segredos:** config.env, chaves do Supabase, tokens do Telegram. Use config.env.example só com placeholders.

## Situação do aparelho (verificado em 26/11/2026)
- Samsung Galaxy M13 (SM-M135M), Android 14, ~4 GB RAM, só ~1,4 GB livre. Use o modelo 0.5B; só suba para 1.5B se `free -m` mostrar > 2 GB livres.
- O Termux JÁ TEM um "SERVIDOR CELULAR" com Bot Telegram ativo (aparece no login). NÃO apague nem altere ~/.bashrc, ~/.termux nem processos existentes; descubra o que é antes (`cat ~/.bashrc`, `ls ~`, `pgrep -fl .`) e conviva com ele. Use portas livres.
- O espelho de pacotes do aparelho estava desatualizado (llama-cpp não encontrado); install.sh troca para packages-cf.termux.dev.
- Celular ligado por USB; o adb.exe está na pasta do scrcpy-win64-v5.0.1. Use `adb shell`, `adb push` e `adb forward`. Para colar comandos no Termux use `adb shell input text` (espaço = %s) + `adb shell input keyevent 66` — nunca a área de transferência.
- Modo de trabalho: o dono pediu AUTONOMIA TOTAL. Tome as decisões, não pergunte; só peça ação física quando for impossível sem ela (ex.: aceitar aviso na tela). Ao final, entregue em docs/RELATORIO.md: o que foi feito, como testar, URLs e chave.
- Comunicação site↔celular: preferir o modelo "caixa de correio" (Supabase gratuito, celular só faz conexões de saída). Se não houver conta/credencial disponível, deixe o gateway rodando, testado via `adb forward tcp:8787 tcp:8787`, e descreva no relatório o único passo pendente.

## Arquitetura (agente local, online para serviços externos)
```
Site / API externa / Telegram
        │  (HTTPS, 24h online, grátis)
   Supabase "caixa de correio"  ←── perguntar() / resposta()   [chave anon pública, só 2 funções]
        ▲
        │  só conexões de SAÍDA (polling 1–5 s), chave service SOMENTE no celular
Celular Android (Termux): ponte_supabase.py + bot_telegram.py → agente.py → llama-server 127.0.0.1:8080
```
- Nenhuma porta aberta no celular, sem túnel, sem domínio. Se o celular cair, os pedidos ficam na fila e o site mostra "offline/demorou".
- gateway/server.py fica só em 127.0.0.1:8787 para testes via `adb forward`.
- termux/vigia.sh reinicia serviços que caírem; boot.sh o inicia no boot (Termux:Boot).

## Como você acessa o celular
- PREFERÊNCIA: USB. O PC é Windows (PowerShell). `adb devices` deve listar o aparelho como `device`. Se aparecer `unauthorized`, peça ao usuário para aceitar o aviso no celular.
- Com USB, redirecione o SSH do Termux: `adb forward tcp:8022 tcp:8022` e use `ssh -p 8022 localhost` (não precisa de IP nem Wi-Fi). Para testar o gateway: `adb forward tcp:8787 tcp:8787` e `curl http://localhost:8787/health`.
- ADB por depuração Wi-Fi. Pareamento: `adb pair IP:PORTA_PAREAMENTO` (código de 6 dígitos na tela) e depois `adb connect IP:PORTA`.
- Comandos dentro do Termux via ADB: use `scripts/tx.sh "comando"` (envia via `run-command` do Termux).
  Requer no Termux: `echo "allow-external-apps=true" >> ~/.termux/termux.properties && termux-reload-settings`.
- Alternativa mais robusta: SSH no Termux (`pkg install openssh; passwd; sshd`, porta 8022). Prefira SSH depois do primeiro setup:
  `ssh -p 8022 IP_DO_CELULAR`. Arquivos: `scp -P 8022 arquivo IP:~/taikazet/`.

## Arquivos
- `config.env` — configuração (copie de `config.env.example`). Nunca commitar.
- `termux/install.sh` — instala llama.cpp, Python, cloudflared, baixa o modelo.
- `termux/start.sh` / `termux/stop.sh` — sobe/derruba os serviços. `termux/boot.sh` → `~/.termux/boot/` (Termux:Boot).
- `gateway/server.py` — gateway HTTP (só biblioteca padrão do Python).
- `gateway/catalog.json` — catálogo de produtos (o dono substitui pelo real).
- `site/taikazet-widget.js` — widget para colar no site.

## Comandos disponíveis (slash commands)
`/conectar` `/instalar` `/iniciar` `/supabase` `/telegram` `/testar` `/catalogo` `/integrar-site` `/status` `/parar`

## Regras
- Nunca exponha a porta 8080. Nunca coloque a chave da API no código do site em texto aberto além do necessário (é uma chave pública de baixa permissão + rate limit + allowlist de origem).
- Antes de trocar de modelo, cheque RAM livre (`free -m`) e temperatura (`termux-battery-status` se Termux:API instalado; ou `adb shell dumpsys battery`). Se temperatura > 42 °C, pare e avise.
- Mantenha `-t` (threads) ≤ núcleos de performance; padrão 4.
- Toda mudança no celular: registre em `docs/LOG.md` (data, o que fez, resultado).
