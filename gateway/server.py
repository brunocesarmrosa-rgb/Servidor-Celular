"""Gateway do Taikazet: protege o llama-server e injeta o catálogo.
Só biblioteca padrão. Endpoints: GET /health, POST /sugerir {"mensagem": "...", "historico": [...]}
"""
import json, os, re, threading, time, urllib.request
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler

API_KEY = os.environ.get("API_KEY", "")
ORIGINS = [o.strip() for o in os.environ.get("ALLOWED_ORIGINS", "").split(",") if o.strip()]
RATE = int(os.environ.get("RATE_PER_MIN", "12"))
SEM = threading.Semaphore(int(os.environ.get("MAX_CONCURRENT", "1")))
LLM = "http://127.0.0.1:8080/v1/chat/completions"
BASE = os.path.dirname(os.path.abspath(__file__))
_hits, _lock = {}, threading.Lock()

def catalogo():
    with open(os.path.join(BASE, "catalog.json"), encoding="utf-8") as f:
        return json.load(f)

def relevantes(msg, itens, n=15):
    palavras = set(re.findall(r"\w{3,}", msg.lower()))
    def score(p):
        txt = " ".join([p["nome"], p.get("categoria", ""), " ".join(p.get("tags", []))]).lower()
        return sum(w in txt for w in palavras)
    return sorted(itens, key=score, reverse=True)[:n]

SYSTEM = ("Você é Taikazet, assistente de compras do site. Responda em português, curto e simpático. "
          "Sugira no máximo 3 produtos, SOMENTE da lista abaixo, citando o id entre colchetes, ex: [P001]. "
          "Se nada servir, diga isso e faça uma pergunta para entender melhor. Nunca invente preço ou produto.\n"
          "PRODUTOS:\n")

def limitado(ip):
    agora = time.time()
    with _lock:
        lst = [t for t in _hits.get(ip, []) if agora - t < 60]
        lst.append(agora); _hits[ip] = lst
        return len(lst) > RATE

class H(BaseHTTPRequestHandler):
    def _cors(self):
        o = self.headers.get("Origin", "")
        if o in ORIGINS:
            self.send_header("Access-Control-Allow-Origin", o)
            self.send_header("Access-Control-Allow-Headers", "Content-Type, X-Api-Key")
            self.send_header("Access-Control-Allow-Methods", "POST, GET, OPTIONS")

    def _json(self, code, obj):
        b = json.dumps(obj, ensure_ascii=False).encode()
        self.send_response(code); self._cors()
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(b))); self.end_headers(); self.wfile.write(b)

    def do_OPTIONS(self):
        self.send_response(204); self._cors(); self.end_headers()

    def do_GET(self):
        if self.path == "/health":
            return self._json(200, {"ok": True, "produtos": len(catalogo())})
        self._json(404, {"erro": "não encontrado"})

    def do_POST(self):
        if self.path != "/sugerir":
            return self._json(404, {"erro": "não encontrado"})
        if self.headers.get("X-Api-Key") != API_KEY:
            return self._json(401, {"erro": "chave inválida"})
        ip = self.headers.get("CF-Connecting-IP") or self.client_address[0]
        if limitado(ip):
            return self._json(429, {"erro": "muitas requisições, aguarde"})
        try:
            dados = json.loads(self.rfile.read(min(int(self.headers.get("Content-Length", 0)), 8000)))
            msg = str(dados.get("mensagem", ""))[:500]
            hist = [h for h in dados.get("historico", [])[-6:] if h.get("role") in ("user", "assistant")]
        except Exception:
            return self._json(400, {"erro": "json inválido"})
        itens = catalogo()
        lista = relevantes(msg, itens)
        ctx = "\n".join(f"[{p['id']}] {p['nome']} | {p.get('categoria','')} | R$ {p['preco']:.2f}" for p in lista)
        body = {"messages": [{"role": "system", "content": SYSTEM + ctx}] + hist + [{"role": "user", "content": msg}],
                "temperature": 0.4, "max_tokens": 220}
        if not SEM.acquire(timeout=30):
            return self._json(503, {"erro": "ocupado, tente de novo"})
        try:
            req = urllib.request.Request(LLM, json.dumps(body).encode(), {"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=90) as r:
                texto = json.load(r)["choices"][0]["message"]["content"]
        except Exception as e:
            return self._json(502, {"erro": f"modelo indisponível: {e}"})
        finally:
            SEM.release()
        ids = set(re.findall(r"\[(P?\w+)\]", texto))
        produtos = [p for p in itens if p["id"] in ids]
        self._json(200, {"resposta": texto, "produtos": produtos})

    def log_message(self, fmt, *a):
        print(time.strftime("%H:%M:%S"), self.address_string(), fmt % a, flush=True)

if __name__ == "__main__":
    print("Taikazet gateway em 127.0.0.1:8787 (teste local via adb forward)", flush=True)
    ThreadingHTTPServer(("127.0.0.1", 8787), H).serve_forever()
