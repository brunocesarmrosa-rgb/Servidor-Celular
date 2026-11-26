#!/data/data/com.termux/files/usr/bin/bash
# Sobe: modelo local + ponte Supabase + (opcional) bot Telegram + (opcional) gateway HTTP local
cd "$(dirname "$0")/.."
set -a; source ./config.env; set +a
mkdir -p logs
termux-wake-lock 2>/dev/null || true
rodar() { pgrep -f "$1" >/dev/null || nohup "${@:2}" > "logs/$3.log" 2>&1 & }
pgrep -f llama-server >/dev/null || nohup llama-server -m "models/$MODEL_FILE" --host 127.0.0.1 --port 8080 -t "$THREADS" -c "$CTX" -np 1 > logs/llama.log 2>&1 &
sleep 5
[ -n "$SUPABASE_URL" ] && { pgrep -f ponte_supabase.py >/dev/null || (cd gateway && nohup python ponte_supabase.py > ../logs/ponte.log 2>&1 &); }
[ -n "$TELEGRAM_TOKEN" ] && { pgrep -f bot_telegram.py >/dev/null || (cd gateway && nohup python bot_telegram.py > ../logs/telegram.log 2>&1 &); }
pgrep -f gateway/server.py >/dev/null || nohup python gateway/server.py > logs/gateway.log 2>&1 &
sleep 2; pgrep -fl "llama-server|ponte_supabase|bot_telegram|server.py"
