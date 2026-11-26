Teste ponta a ponta e meça desempenho.
1. `curl http://IP:8787/health`.
2. `curl -X POST http://IP:8787/sugerir -H "X-Api-Key: $API_KEY" -H "Content-Type: application/json" -d '{"mensagem":"quero um presente até 100 reais"}'` — meça o tempo com `time`.
3. Se PUBLIC_HOSTNAME configurado, repita via https://PUBLIC_HOSTNAME.
4. Cheque temperatura: `adb shell dumpsys battery | grep temperature` (valor/10 = °C). Acima de 42 °C: reduza THREADS ou troque para modelo menor.
5. Reporte: tempo de resposta, tokens/s (llama.log), temperatura, RAM. Registre em docs/LOG.md.
