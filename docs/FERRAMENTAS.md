# Ferramentas do projeto — como acessar, baixar, instalar e executar

Instalação automática: no PC rode `powershell -ExecutionPolicy Bypass -File ferramentas\setup-pc.ps1`; para o celular, `ferramentas\setup-android.ps1`. Verificação rápida: `ferramentas\verificar.ps1` (ou `/ferramentas` no Claude Code).

## No PC (Windows)
| Ferramenta | Para quê | Instalar | Executar / checar |
|---|---|---|---|
| **Claude Code** | Operador do projeto | `irm https://claude.ai/install.ps1 \| iex` | `claude` · `/status` (não pode haver "Anthropic base URL") |
| **Git** | Puxar/enviar o acervo | `winget install Git.Git` | `git pull` / `git push` |
| **GitHub CLI** | Login e PRs no GitHub | `winget install GitHub.cli` | `gh auth login` · `gh auth status` |
| **scrcpy** (inclui **adb**) | Ver/controlar a tela do celular e comandos USB | `winget install Genymobile.scrcpy` (ou zip em github.com/Genymobile/scrcpy/releases) | `scrcpy` · `adb devices` |
| **Android Platform Tools** | adb oficial (alternativa) | `winget install Google.PlatformTools` | `adb version` |
| **Node.js LTS** | Rodar o CLI do Supabase via npx | `winget install OpenJS.NodeJS.LTS` | `node -v` · `npx supabase --version` |
| **Supabase CLI** | Criar projeto e aplicar o SQL | `npx supabase@latest` (sem instalar) ou `scoop install supabase` | `npx supabase login` · `npx supabase projects list` |
| **Python 3** | Testes locais do gateway | `winget install Python.Python.3.12` | `python --version` |
| **OpenSSH client** | SSH/SCP no Termux | já vem no Windows 10/11 (Recursos opcionais) | `ssh -p 8022 localhost` (após `adb forward tcp:8022 tcp:8022`) |

## No celular (Android, Samsung M13)
| Ferramenta | Para quê | Instalar | Executar / checar |
|---|---|---|---|
| **Termux** | Linux no celular | já instalado (fonte: F-Droid ou GitHub — não misture fontes) | abrir o app |
| **Termux:Boot** | Iniciar o servidor ao ligar | mesma fonte do Termux; `setup-android.ps1` instala via adb | abrir 1x após instalar |
| **Termux:API** | Bateria/temperatura, wake-lock | mesma fonte do Termux | `termux-battery-status` |
| **llama.cpp** (`llama-server`) | Rodar o modelo | `pkg install llama-cpp` (install.sh) — fallback: compila do GitHub | `llama-server --version` |
| **Python** (Termux) | Ponte Supabase, bot, gateway | `pkg install python` | `python gateway/ponte_supabase.py` |
| **OpenSSH** (Termux) | Acesso remoto do PC | `pkg install openssh; passwd; sshd` | porta 8022 |
| **Modelo GGUF** | O "cérebro" | baixado de huggingface.co (URL no config.env) | arquivo em `models/` |

## Na nuvem (grátis)
| Serviço | Para quê | Acesso |
|---|---|---|
| **GitHub** — Servidor-Celular | Acervo do projeto | github.com/brunocesarmrosa-rgb/Servidor-Celular |
| **Supabase** | Caixa de correio 24h (site ↔ celular) | supabase.com (login GitHub/Google); região sa-east-1 |
| **Hugging Face** | Download dos modelos | huggingface.co/Qwen (sem conta) |
| **Telegram @BotFather** | Criar bot dedicado (opcional) | t.me/BotFather → /newbot |

## Ferramentas avaliadas e não usadas (e por quê)
- **Cloudflare Tunnel**: precisa de domínio na Cloudflare e expõe o celular; trocado pela caixa de correio.
- **Ollama no Termux**: mais pesado que llama.cpp para 4 GB de RAM.
- **Discord como ponte do site**: exigiria expor o token do bot no navegador.
- **Colar comandos via clipboard no scrcpy**: instável; usar adb/SSH.
- **"9Router Proxy"**: NÃO é parte do projeto; remover se aparecer.
