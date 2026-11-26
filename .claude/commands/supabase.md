Configure a ponte "caixa de correio" no Supabase (gratuito).
1. Se o usuário não tiver conta: peça que crie em supabase.com (login com GitHub/Google) — é o único passo manual. Instale o CLI (`npm i -g supabase` ou `scoop install supabase`) e rode `supabase login` (abre o navegador).
2. `supabase projects create taikazet --region sa-east-1 --db-password <gerar forte>` (ou use um projeto existente). Pegue URL e chaves com `supabase projects api-keys --project-ref REF`.
3. Aplique `supabase/schema.sql` (`supabase link --project-ref REF` + `supabase db query < supabase/schema.sql`, ou via psql na connection string).
4. Grave SUPABASE_URL, SUPABASE_ANON_KEY e SUPABASE_SERVICE_KEY no config.env, envie ao celular, reinicie com start.sh.
5. Teste: chame rpc/perguntar com a chave anon via curl, espere, chame rpc/resposta e confira status "pronto". Teste também que a anon NÃO consegue `GET /rest/v1/pedidos` (deve vir vazio ou 401).
6. Avise: projetos gratuitos parados são pausados; a ponte consulta o tempo todo, o que mantém o projeto ativo.
