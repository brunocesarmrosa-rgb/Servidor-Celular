# Aprendizados (erros já resolvidos — leia antes de repetir)
- 26/11/2026: o espelho de pacotes do Termux no M13 era chinês e desatualizado → `llama-cpp` não encontrado. Solução: install.sh fixa packages-cf.termux.dev.
- 26/11/2026: colar comandos no Termux pela área de transferência via scrcpy é instável (chegou a colar o clipboard do PC). Use `adb shell input text` ou SSH.
- 26/11/2026: um PC tinha um proxy desconhecido ("9Router", porta 20128) em ~/.claude/settings.json interceptando o Claude Code. Sempre conferir `/status`: não deve haver "Anthropic base URL".
- O celular já roda um "SERVIDOR CELULAR" com bot Telegram próprio: não alterar.
