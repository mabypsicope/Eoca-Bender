-- Esquema para guardar el registro de la EOCA y el Bender en Supabase.
-- Pegalo en Supabase > SQL Editor y ejecutalo una sola vez.
-- Una fila por usuario: la app guarda ahí todo el registro (JSON).

create table if not exists public.eoca_casos (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  alias      text,                       -- nombre ficticio, solo para identificarlo vos
  data       jsonb not null,             -- estado completo de la app
  updated_at timestamptz not null default now()
);

-- Seguridad a nivel de fila: cada persona ve y modifica solo lo suyo.
alter table public.eoca_casos enable row level security;

create policy "leer lo propio"
  on public.eoca_casos for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "crear lo propio"
  on public.eoca_casos for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "editar lo propio"
  on public.eoca_casos for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "borrar lo propio"
  on public.eoca_casos for delete to authenticated
  using ((select auth.uid()) = user_id);

-- La fecha de modificación la pone el servidor, no el navegador.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger eoca_casos_set_updated_at
  before update on public.eoca_casos
  for each row execute function public.set_updated_at();
