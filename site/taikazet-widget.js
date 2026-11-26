/* Taikazet — widget (modo caixa de correio Supabase). Uso no site:
   <script>window.TAIKAZET={supabaseUrl:"https://XXXX.supabase.co",anonKey:"CHAVE_ANON_PUBLICA"}</script>
   <script src="/taikazet-widget.js" defer></script>
   A chave anon é pública por design: ela só consegue chamar perguntar() e resposta(). */
(function () {
  const C = window.TAIKAZET || {}; const hist = [];
  const sessao = (localStorage.getItem("tk_s") || (Math.random().toString(36).slice(2) + Date.now()));
  try { localStorage.setItem("tk_s", sessao); } catch (e) {}
  const H = { "Content-Type": "application/json", apikey: C.anonKey, Authorization: "Bearer " + C.anonKey };
  const rpc = (f, b) => fetch(C.supabaseUrl + "/rest/v1/rpc/" + f, { method: "POST", headers: H, body: JSON.stringify(b) }).then(r => r.json());
  const css = `#tk-btn{position:fixed;right:20px;bottom:20px;z-index:9999;border:0;border-radius:30px;padding:12px 18px;background:#111;color:#fff;font:600 14px sans-serif;cursor:pointer}
#tk-box{position:fixed;right:20px;bottom:76px;width:320px;max-height:460px;display:none;flex-direction:column;background:#fff;border-radius:12px;box-shadow:0 6px 30px #0003;z-index:9999;font:14px sans-serif}
#tk-log{flex:1;overflow:auto;padding:12px}.tk-m{margin:6px 0;padding:8px 10px;border-radius:8px;background:#f2f2f2}.tk-u{background:#111;color:#fff;margin-left:40px}
.tk-p{display:block;margin:4px 0;color:#0a58ca}#tk-f{display:flex;border-top:1px solid #eee}#tk-i{flex:1;border:0;padding:10px}#tk-f button{border:0;background:#111;color:#fff;padding:0 14px}`;
  document.head.insertAdjacentHTML("beforeend", `<style>${css}</style>`);
  document.body.insertAdjacentHTML("beforeend", `<button id="tk-btn">Taikazet 💬</button>
<div id="tk-box"><div id="tk-log"><div class="tk-m">Oi! Sou o Taikazet. O que você procura?</div></div>
<form id="tk-f"><input id="tk-i" placeholder="Ex: presente até R$ 100" maxlength="500"><button>Enviar</button></form></div>`);
  const box = document.getElementById("tk-box"), log = document.getElementById("tk-log"), inp = document.getElementById("tk-i");
  document.getElementById("tk-btn").onclick = () => box.style.display = box.style.display === "flex" ? "none" : "flex";
  const add = (t, u) => { const d = document.createElement("div"); d.className = "tk-m" + (u ? " tk-u" : ""); d.textContent = t; log.appendChild(d); log.scrollTop = 1e9; return d; };
  const dormir = ms => new Promise(r => setTimeout(r, ms));
  document.getElementById("tk-f").onsubmit = async (e) => {
    e.preventDefault(); const m = inp.value.trim(); if (!m) return; inp.value = ""; add(m, true);
    const w = add("Taikazet está pensando… (pode levar alguns segundos)");
    try {
      const id = await rpc("perguntar", { p_mensagem: m, p_sessao: sessao, p_historico: hist });
      if (typeof id !== "string") throw 0;
      for (let i = 0; i < 90; i++) {
        await dormir(2000);
        const r = (await rpc("resposta", { p_id: id }))[0];
        if (r && (r.status === "pronto" || r.status === "erro")) {
          w.textContent = r.resposta || "Sem resposta.";
          (r.produtos || []).forEach(p => { const a = document.createElement("a"); a.className = "tk-p"; a.href = p.url; a.textContent = `→ ${p.nome} — R$ ${Number(p.preco).toFixed(2)}`; w.appendChild(a); });
          hist.push({ role: "user", content: m }, { role: "assistant", content: r.resposta || "" }); hist.splice(0, hist.length - 6);
          return;
        }
      }
      w.textContent = "Taikazet demorou demais. Tente de novo em instantes.";
    } catch { w.textContent = "Taikazet está offline no momento."; }
  };
})();
