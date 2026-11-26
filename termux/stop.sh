#!/data/data/com.termux/files/usr/bin/bash
pkill -f ponte_supabase.py; pkill -f bot_telegram.py; pkill -f gateway/server.py; pkill -f llama-server
termux-wake-unlock 2>/dev/null; echo parado
