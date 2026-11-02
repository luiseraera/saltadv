-- SaltJus: cole e execute no Supabase (projeto SaltJus): SQL Editor > New query > Run
-- Cria a tabela de registros (clientes, processos, prazos, honorários) e as regras
-- que deixam cada usuário ver e alterar só os próprios dados.

create table public.registros (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id text not null check (char_length(id) between 1 and 80),
  tipo text not null check (tipo in ('cliente','processo','evento','honorario')),
  dados jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);
create index registros_user_tipo_idx on public.registros (user_id, tipo);

alter table public.registros enable row level security;
create policy "ver os proprios registros" on public.registros for select to authenticated using ((select auth.uid()) = user_id);
create policy "criar os proprios registros" on public.registros for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "alterar os proprios registros" on public.registros for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "apagar os proprios registros" on public.registros for delete to authenticated using ((select auth.uid()) = user_id);

-- Exclusão de conta pelo próprio usuário (botão "Excluir minha conta" em Conta).
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;
  delete from public.registros where user_id = auth.uid();
  delete from auth.users where id = auth.uid();
end;
$$;
revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
