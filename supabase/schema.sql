-- Caixa de correio do Taikazet (rodar no SQL Editor do Supabase ou via `supabase db push`)
create extension if not exists pgcrypto;

create table if not exists pedidos (
  id uuid primary key default gen_random_uuid(),
  canal text not null default 'site',          -- site | telegram | api
  sessao text,
  mensagem text not null check (length(mensagem) <= 500),
  historico jsonb default '[]',
  status text not null default 'pendente',      -- pendente | processando | pronto | erro
  resposta text,
  produtos jsonb,
  criado_em timestamptz default now(),
  atualizado_em timestamptz default now()
);
create index if not exists pedidos_pend on pedidos (status, criado_em);
alter table pedidos enable row level security;   -- sem policies: anon não lê nem escreve direto

-- Público (site/serviços externos): só estas duas funções
create or replace function perguntar(p_mensagem text, p_sessao text default null, p_historico jsonb default '[]', p_canal text default 'site')
returns uuid language plpgsql security definer set search_path = public as $$
declare v uuid; recentes int;
begin
  select count(*) into recentes from pedidos where sessao = p_sessao and criado_em > now() - interval '1 minute';
  if recentes >= 10 then raise exception 'limite'; end if;
  insert into pedidos (mensagem, sessao, historico, canal)
  values (left(p_mensagem, 500), p_sessao, coalesce(p_historico, '[]'), p_canal) returning id into v;
  return v;
end $$;

create or replace function resposta(p_id uuid)
returns table (status text, resposta text, produtos jsonb) language sql security definer set search_path = public as $$
  select status, resposta, produtos from pedidos where id = p_id;
$$;

-- Celular (service_role): pega o próximo pedido sem duplicar
create or replace function pegar_proximo()
returns setof pedidos language sql security definer set search_path = public as $$
  update pedidos set status = 'processando', atualizado_em = now()
  where id = (select id from pedidos where status = 'pendente'
              or (status = 'processando' and atualizado_em < now() - interval '3 minutes')
              order by criado_em limit 1 for update skip locked)
  returning *;
$$;

revoke all on function pegar_proximo() from public, anon, authenticated;
grant execute on function perguntar(text, text, jsonb, text), resposta(uuid) to anon;

-- Limpeza: apaga pedidos com mais de 7 dias (chamada pelo celular 1x/dia)
create or replace function limpar() returns void language sql security definer as $$
  delete from pedidos where criado_em < now() - interval '7 days';
$$;
revoke all on function limpar() from public, anon, authenticated;
