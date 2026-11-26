"""Núcleo do Taikazet: monta o prompt com o catálogo e consulta o llama-server local."""
import json, os, re, urllib.request
BASE = os.path.dirname(os.path.abspath(__file__))
LLM = os.environ.get("LLM_URL", "http://127.0.0.1:8080/v1/chat/completions")
SYSTEM = ("Você é Taikazet, assistente de compras do site. Responda em português, curto e simpático. "
          "Sugira no máximo 3 produtos, SOMENTE da lista abaixo, citando o id entre colchetes, ex: [P001]. "
          "Se nada servir, diga isso e faça uma pergunta. Nunca invente preço ou produto.\nPRODUTOS:\n")

def catalogo():
    with open(os.path.join(BASE, "catalog.json"), encoding="utf-8") as f:
        return json.load(f)

def responder(msg, hist=None):
    itens = catalogo()
    pal = set(re.findall(r"\w{3,}", msg.lower()))
    def score(p):
        t = " ".join([p["nome"], p.get("categoria", ""), " ".join(p.get("tags", []))]).lower()
        return sum(w in t for w in pal)
    lista = sorted(itens, key=score, reverse=True)[:12]
    ctx = "\n".join(f"[{p['id']}] {p['nome']} | {p.get('categoria','')} | R$ {p['preco']:.2f}" for p in lista)
    hist = [h for h in (hist or [])[-6:] if isinstance(h, dict) and h.get("role") in ("user", "assistant")]
    body = {"messages": [{"role": "system", "content": SYSTEM + ctx}] + hist + [{"role": "user", "content": msg[:500]}],
            "temperature": 0.4, "max_tokens": 200}
    req = urllib.request.Request(LLM, json.dumps(body).encode(), {"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=120) as r:
        texto = json.load(r)["choices"][0]["message"]["content"]
    ids = set(re.findall(r"\[(\w+)\]", texto))
    return texto, [p for p in itens if p["id"] in ids]
