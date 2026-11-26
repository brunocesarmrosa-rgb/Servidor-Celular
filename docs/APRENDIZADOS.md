# Aprendizados (erros já resolvidos — leia antes de repetir)
- 26/11/2026: o espelho de pacotes do Termux no M13 era chinês e desatualizado → `llama-cpp` não encontrado. Solução: install.sh fixa packages-cf.termux.dev.
- 26/11/2026: colar comandos no Termux pela área de transferência via scrcpy é instável (chegou a colar o clipboard do PC). Use `adb shell input text` ou SSH.
- 26/11/2026: um PC tinha um proxy desconhecido ("9Router", porta 20128) em ~/.claude/settings.json interceptando o Claude Code. Sempre conferir `/status`: não deve haver "Anthropic base URL".
- O celular já roda um "SERVIDOR CELULAR" com bot Telegram próprio: não alterar.
- 26/11/2026 (tarde): Remote Control do Claude no Windows não conseguiu servir pasta `C:\Servidor-Celular` — problema de versão ou permissão. Workaround: usar PowerShell + adb direto.
- 26/11/2026 (tarde): SSH Server não inicia automaticamente após reboot no Termux. Solução: adicionar `sshd` em Termux:Boot (ou rodar manualmente `sshd` ao iniciar).
- 26/11/2026 (tarde): llama.cpp compilação falha no ARM (Galaxy M13) — erro em traits.cpp, amx.cpp. Precisa investigar flags ARM64 ou usar binário pré-compilado.
- 26/11/2026 (tarde): Gateway respondeu bem com mock. Prioridade: preparar bridge Supabase primeiro; llama.cpp pode esperar (versão pré-compilada depois).
