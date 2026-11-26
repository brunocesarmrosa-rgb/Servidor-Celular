# 🏛️ PMSC — Palácio de Memórias do Servidor Celular

**Última atualização:** 26/11/2026 (tarde)  
**Status:** Fase 1 (parcial) → Fase 2 (Supabase bridge)

---

## 🎯 RESUMO EXECUTIVO

**Objetivo:** Rodar IA local no Android (Termux) para responder perguntas do site, sem pagar por API.

**Arquitetura:**
```
Site/App → Supabase (caixa de correio grátis)
              ↓ polling (conexão saída)
        Celular (Termux): llama-server + bridge + bot
              ↑ processa e responde
```

**Regra de ouro:** TODO processamento só no celular (192.168.15.18). PCs apenas administram.

---

## 📍 APARELHOS & REDE

| Nome | IP | OS | Papel | Acesso |
|------|-----|--------|-------|--------|
| **celular-servidor** | 192.168.15.18 | Android 14 (M13) | Roda IA | SSH:8022, adb |
| celular-pessoal | 192.168.15.4 | Android | Admin | adb |
| pc-principal | 192.168.15.11 | Windows | Admin | SSH:22 |
| notebook-promac | 192.168.15.10 | Windows | Admin | SSH:22 |

**Acesso preferido:**
- Celular-servidor: `ssh -p 8022 192.168.15.18` (Wi-Fi) ou `ssh -p 8022 localhost` + `adb forward tcp:8022 tcp:8022` (USB)
- Gateway local: `adb forward tcp:8787 tcp:8787` → `curl http://localhost:8787/health`

---

## 🔧 ESTADO ATUAL (26/11 tarde)

### ✅ Feito
- SSH Server rodando no Termux (porta 8022, senha 123456)
- Repositório clonado em `~/taikazet` no celular
- Gateway Python em 127.0.0.1:8787 testado → responde `{"ok": true, "produtos": 2}`
- PowerShell + adb funcionando (Remote Control não serviu pasta Windows)

### ❌ Bloqueado
- **llama.cpp compilação ARM falhou** (traits.cpp, amx.cpp SIMD errors)
  - Plano B: usar binário pré-compilado ARM64 ou modelo alternativo
- SSH Server não inicia automaticamente após reboot
  - Fix: adicionar `sshd` em Termux:Boot

### ⏳ Próximos (Fase 2)
1. ✅ Gateway mock rodando → move para bridge Supabase
2. Criar projeto Supabase (gratuito)
3. Rodar `supabase/schema.sql` (tabelas: perguntas, respostas)
4. Script `termux/ponte_supabase.py` polling a cada 3–5s
5. Vigia automático (`termux/vigia.sh` + Termux:Boot)
6. Teste: todos PCs desligados, pergunta via API → resposta do celular em 3–5s

---

## 🚀 FASES

### **Fase 0** ✅
- Ferramentas Windows (adb, OpenSSH, scrcpy)
- Rede Wi-Fi 192.168.15.x, IPs fixos
- Cadastro em `rede/dispositivos.json`

### **Fase 1** 🟡 Parcial
- [x] SSH Server Termux
- [x] Repositório clonado
- [x] Gateway HTTP mock
- [ ] llama.cpp compilado (bloqueado → usar pré-compilado)
- [ ] Modelo 0.5B baixado
- [ ] llama-server rodando em 127.0.0.1:8080

### **Fase 2** 🔵 Em fila
- [ ] Supabase projeto criado
- [ ] Schema SQL aplicado
- [ ] Bridge Supabase (polling)
- [ ] Vigia automático + boot
- [ ] Teste ponta a ponta offline

### **Fase 3** ⚪
- Catálogo real (CSV/JSON)
- Widget JavaScript no site
- Bot Telegram dedicado

### **Fase 4** ⚪
- Otimizações (threads, ctx, modelo 1.5B)
- Painel de status
- Fallback offline (busca tags)

---

## 📋 APRENDIZADOS (Erros já resolvidos)

| Problema | Causa | Solução |
|----------|-------|---------|
| SSH não conecta | Server não instalado | `pkg install openssh -y && passwd && sshd` |
| `git not found` | Git não instalado | `pkg install git -y` |
| SSH não auto-inicia | Sem boot script | Adicionar `sshd` em `~/.termux/boot/boot.sh` |
| llama.cpp ARM fail | SIMD não suportado | Usar binário pré-compilado ARM64 |
| Gateway curl falha | Gateway não rodou | Verificar com `python3 gateway/server.py` direto |
| PowerShell SSH hang | Comportamento terminal | Abrir nova janela PowerShell |
| Mirror Termux desatualizado | Chinês + old | `install.sh` troca para `packages-cf.termux.dev` |
| Remote Control pasta Windows | Versão/permissão | Workaround: usar `adb` + PowerShell direto |
| Clipboard Termux instável | scrcpy bug | Usar `adb shell input text` ou SSH |
| Claude proxy bloqueado | Proxy desconhecido | Conferir `/status` → sem "Anthropic base URL" |

---

## 🔐 SEGURANÇA & REGRAS

- ❌ **Nunca commitar:** `config.env`, chaves Supabase, tokens Telegram
- ✅ **Usar:** `config.env.example` (só placeholders)
- ❌ **Nunca expor:** Porta 8080 (llama-server interno)
- ⚠️ **Gateway:** Só 127.0.0.1:8787 (testes via adb forward)
- 🔒 **Chaves Supabase:** Apenas `anon public` no celular (rate limit + allowlist origem)
- 🌡️ **Temperatura:** Se > 42 °C, parar (usar `termux-battery-status` ou `adb shell dumpsys battery`)
- 💾 **RAM:** Usar modelo 0.5B; só 1.5B se `free -m` > 2 GB

---

## 📂 ARQUIVOS-CHAVE

```
Servidor-Celular/
├── CLAUDE.md                    # Instruções deste projeto
├── config.env.example           # Template (NUNCA config.env)
├── docs/
│   ├── LOG.md                   # Histórico por data
│   ├── ROADMAP.md               # Fases 0-4
│   ├── APRENDIZADOS.md          # Erros resolvidos
│   ├── PMSC.md                  # ← ESTE ARQUIVO
│   └── API.md                   # (TODO: Fase 2)
├── rede/
│   ├── dispositivos.json        # Cadastro Wi-Fi
│   └── rede.ps1                 # Menu: Listar, Conectar, Executar, SSH...
├── gateway/
│   ├── server.py                # HTTP mock (127.0.0.1:8787)
│   └── catalog.json             # Produtos (substitua por real)
├── termux/
│   ├── install.sh               # Setup llama.cpp, Python, modelo
│   ├── start.sh / stop.sh       # Sobe/derruba serviços
│   ├── boot.sh                  # → ~/.termux/boot/ (Termux:Boot)
│   ├── vigia.sh                 # Reinicia serviços que caem
│   ├── ponte_supabase.py        # (TODO: Bridge Supabase)
│   └── bot_telegram.py          # (TODO: Fase 3)
└── site/
    └── taikazet-widget.js       # (TODO: Widget site)
```

---

## 🎮 COMANDOS RÁPIDOS (PowerShell no Windows)

```powershell
# Menu de aparelhos
. .\rede\rede.ps1              # Listar, Conectar, SSH, Executar, Enviar, etc.

# SSH direto (após setup)
ssh -p 8022 192.168.15.18      # Acesso Wi-Fi (preferido)
ssh -p 8022 localhost          # Via USB + adb forward

# Testar gateway
adb forward tcp:8787 tcp:8787
curl http://localhost:8787/health

# Enviar arquivo
scp -P 8022 arquivo.py 192.168.15.18:~/taikazet/

# Verificação
ferramentas\verificar.ps1      # Checklist completo
```

---

## 🎯 SLASH COMMANDS (Claude Code)

```
/ferramentas        → Verificar setup Windows
/dispositivos       → Menu rede (Listar, Conectar, SSH, Executar)
/conectar          → SSH celular-servidor
/instalar          → Rodar install.sh (llama.cpp, modelo)
/iniciar           → Subir serviços (gateway, bridge, bot)
/supabase          → Criar/testar bridge Supabase
/telegram          → Configurar bot Telegram
/testar            → Teste ponta a ponta
/catalogo          → Atualizar produtos
/integrar-site     → Instalar widget
/status            → Ver serviços rodando
/parar             → Desligar serviços
```

---

## 💡 PRÓXIMO PASSO IMEDIATO

**👉 Fase 2: Bridge Supabase**

1. Criar conta gratuita em https://supabase.com
2. Copiar `URL` e `Anon Key`
3. Salvar em `config.env` (nunca commitar)
4. Rodar `supabase/schema.sql` no editor SQL do Supabase
5. Preparar `termux/ponte_supabase.py` (polling celular)
6. Adicionar vigia + boot automático
7. Testar offline (todos PCs desligados)

---

## 📞 CONTATO & CRÉDITOS

- **Usuário:** bruno.cesarmrosa@gmail.com
- **Repo:** https://github.com/brunocesarmrosa-rgb/Servidor-Celular
- **Operador:** Claude Code (sessão atualizada 26/11/2026)
- **Status:** Pronto para Fase 2 ✨

---

**Use este documento como "quick reference" na próxima sessão. Ele substitui leituras longas.**
