# Agente Offline — Prós e Contras

## Prós
- **Custo zero de API**: nada pago por token; custo = energia do celular (~2–5 W).
- **Privacidade**: conversas não vão para terceiros (só passam pelo túnel criptografado).
- **Controle total**: você escolhe modelo, prompt e regras; nada muda sem você querer.
- **Hardware reaproveitado** e baixo consumo; Termux + llama.cpp não exige root.
- **Troca fácil de modelo**: qualquer GGUF (Qwen, Llama, Gemma, Phi).
- **Inferência 100% offline**: se a internet cair, o modelo continua funcionando localmente.

## Contras
- **Não é 100% offline para o site**: um site público precisa alcançar o celular, então o túnel (Cloudflare) exige internet. Offline é só a IA.
- **Lento e pouca concorrência**: em geral 5–15 tokens/s em intermediários e 15–30 em topo de linha; uma resposta leva 5–20 s. Atende ~1 visitante por vez (fila no gateway).
- **Qualidade limitada**: modelos de 1–4B erram mais, podem inventar produtos (mitigado: só aceitamos IDs do catálogo).
- **Ponto único de falha**: queda de energia, Wi-Fi, atualização do Android ou o sistema matando o Termux = Taikazet fora do ar. O widget mostra "offline".
- **Calor e desgaste**: uso contínuo esquenta; o limite de bateria em 80% ajuda, mas monitore a temperatura.
- **Economia de bateria do Android** pode encerrar processos: desative a otimização de bateria do Termux e use `termux-wake-lock`.
- **Segurança**: expor um aparelho doméstico exige cuidado (chave de API, rate limit, allowlist de origem, llama-server só em localhost; já está no projeto).
- **Depuração Wi-Fi** muda de porta ao reiniciar e pode desligar sozinha; por isso o projeto usa SSH depois do primeiro acesso.
- **Escala**: com tráfego real (dezenas de usuários simultâneos), uma API paga barata ou um mini-PC tende a valer mais a pena.

## Alternativas avaliadas
| Opção | Quando usar |
|---|---|
| **llama.cpp no Termux (escolhida)** | Mais leve, API compatível com OpenAI, pacote pronto no Termux |
| Ollama no Termux | Mais simples de trocar modelos, porém mais pesado |
| Apps (PocketPal, MLC Chat) | Bons para chat pessoal, ruins para servir o site |
| Sugestão sem IA (busca por tags) | Instantâneo e confiável; ótimo como plano B quando o celular estiver offline |

## Ponte escolhida: "caixa de correio" (Supabase)
| Opção de meio de campo | Grátis | Celular expõe porta? | Site consegue usar? | Veredito |
|---|---|---|---|---|
| **Supabase (fila + funções)** | Sim | Não | Sim, direto do navegador | **Escolhida** |
| Cloudflare Workers + D1 | Sim | Não | Sim | Plano B equivalente |
| Cloudflare Tunnel | Sim | Não (túnel) | Sim | Exige domínio na Cloudflare; site fora quando celular cai |
| Telegram | Sim | Não | Não (exporia o token do bot) | Ótimo como canal extra |
| Discord | Sim | Não | Não (mesmo problema) | Ótimo para comunidade |
