"""Bot do Telegram (opcional). Long polling: só conexões de saída."""
import json, os, time, urllib.request, urllib.parse
from agente import responder
API = f"https://api.telegram.org/bot{os.environ['TELEGRAM_TOKEN']}/"
hist = {}

def tg(metodo, **p):
    dados = urllib.parse.urlencode(p).encode()
    with urllib.request.urlopen(API + metodo, dados, timeout=60) as r:
        return json.load(r)["result"]

off = 0
print("Bot Telegram ativo", flush=True)
while True:
    try:
        for u in tg("getUpdates", offset=off, timeout=50):
            off = u["update_id"] + 1
            m = u.get("message") or {}
            txt, chat = m.get("text"), m.get("chat", {}).get("id")
            if not txt or not chat: continue
            if txt.startswith("/start"):
                tg("sendMessage", chat_id=chat, text="Oi! Sou o Taikazet. Me diga o que procura."); continue
            tg("sendChatAction", chat_id=chat, action="typing")
            h = hist.setdefault(chat, [])
            try:
                resp, prods = responder(txt, h)
                links = "\n".join(f"• {p['nome']} — R$ {p['preco']:.2f}\n{p['url']}" for p in prods)
                out = resp + ("\n\n" + links if links else "")
            except Exception:
                out = "Estou ocupado agora, tente em instantes."; resp = ""
            h += [{"role": "user", "content": txt}, {"role": "assistant", "content": resp}]; del h[:-6]
            tg("sendMessage", chat_id=chat, text=out[:4000])
    except Exception as e:
        print("erro:", e, flush=True); time.sleep(5)
