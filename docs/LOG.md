# Log de execução
- 26/11/2026 — Projeto criado (claude.ai). Gateway e SQL testados com mocks/Postgres local. Ainda não instalado no celular.
- 26/11/2026 — Adicionado catálogo de ferramentas (docs/FERRAMENTAS.md) e scripts de setup/verificação.
- 26/11/2026 — Palavra-chave "Servidor Celular" definida (retoma o projeto automaticamente).
- 26/11/2026 — Cadastro de aparelhos da rede (rede/) com controle por Wi-Fi (ADB/SSH).
- 26/11/2026 — notebook-promac confirmado como Windows.
- 26/11/2026 — Regra: todo processamento só no celular-servidor 192.168.15.18; PCs apenas administram.
- 26/11/2026 — Papéis definidos: PCs/celular pessoal enviam comandos; celular-servidor executa e (futuramente) a IA responde. SSH Server mantido nos PCs.
- 26/11/2026 — notebook-promac (nbcombruno, 192.168.15.10): OpenSSH Server instalado e ativo. `sshd` em Running com StartType Automatic (sobe sozinho ao ligar o notebook). Na 1ª tentativa, Add-WindowsCapability falhou com "não foi possível encontrar os arquivos de origem"; na 2ª tentativa, com o Windows Update (wuauserv) iniciado, funcionou. Causa exata não confirmada. Gateway do celular testado via `adb forward tcp:8787 tcp:8787`: /health retornou ok=true, produtos=2.
