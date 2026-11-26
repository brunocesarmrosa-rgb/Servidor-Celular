# Roadmap — Taikazet / Servidor-Celular

## Fase 0 — Ferramentas
- [ ] Rodar ferramentas\verificar.ps1 e instalar o que faltar

## Fase 0.5 — Rede
- [ ] Preparar acesso Wi-Fi (rede/preparar-acesso.md) e testar `Listar`/`Conectar`
- [ ] Reservar IPs fixos no roteador

## Fase 1 — Agente local no celular
- [ ] Conectar celular (USB/adb) e SSH no Termux
- [ ] Corrigir espelho do Termux e instalar llama-cpp
- [ ] Baixar modelo (Qwen2.5 0.5B) e subir llama-server
- [ ] Testar resposta local (adb forward 8787)

## Fase 2 — Online para serviços externos
- [ ] Criar projeto Supabase e aplicar supabase/schema.sql
- [ ] Ponte celular ↔ Supabase rodando e testada ponta a ponta
- [ ] Vigia + Termux:Boot (volta sozinho após reiniciar)
- [ ] Documentar API em docs/API.md

## Fase 3 — Site e canais
- [ ] Catálogo real em gateway/catalog.json
- [ ] Widget instalado no site
- [ ] Bot Telegram dedicado (opcional)

## Fase 4 — Melhorias
- [ ] Medir tempo de resposta e temperatura; ajustar THREADS/CTX
- [ ] Avaliar modelo 1.5B se houver RAM
- [ ] Plano B sem IA (busca por tags) quando o celular estiver offline
- [ ] Painel de status (pedidos/dia, tempo médio)
