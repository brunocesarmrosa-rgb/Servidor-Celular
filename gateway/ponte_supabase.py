"""Ponte celular <-> Supabase. Só conexões de SAÍDA. Busca pedidos, responde com o modelo local."""
import json, os, time, urllib.request
from agente import responder
URL = os.environ["SUPABASE_URL"].rstrip("/")
KEY = os.environ["SUPABASE_SERVICE_KEY"]
H = {"apikey": KEY, "Authorization": f"Bearer {KEY}", "Content-Type": "application/json"}

def rest(metodo, caminho, dados=None, extra=None):
    req = urllib.request.Request(URL + caminho, json.dumps(dados).encode() if dados is not None else None,
                                 {**H, **(extra or {})}, method=metodo)
    with urllib.request.urlopen(req, timeout=30) as r:
        txt = r.read()
        return json.loads(txt) if txt else None

ultima_limpeza = 0
espera = 1.0
print("Ponte Supabase ativa", flush=True)
while True:
    try:
        if time.time() - ultima_limpeza > 86400:
            rest("POST", "/rest/v1/rpc/limpar", {}); ultima_limpeza = time.time()
        itens = rest("POST", "/rest/v1/rpc/pegar_proximo", {})
        if not itens:
            time.sleep(espera); espera = min(espera * 1.5, 5.0); continue
        espera = 1.0
        p = itens[0]
        t0 = time.time()
        try:
            texto, produtos = responder(p["mensagem"], p.get("historico"))
            dados = {"status": "pronto", "resposta": texto, "produtos": produtos}
        except Exception as e:
            dados = {"status": "erro", "resposta": "Taikazet está sobrecarregado, tente de novo.", "produtos": []}
            print("erro modelo:", e, flush=True)
        rest("PATCH", f"/rest/v1/pedidos?id=eq.{p['id']}", dados, {"Prefer": "return=minimal"})
        print(time.strftime("%H:%M:%S"), p["canal"], f"{time.time()-t0:.1f}s", flush=True)
    except Exception as e:
        print("rede:", e, flush=True); time.sleep(10)
