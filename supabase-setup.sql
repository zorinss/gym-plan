-- Выполни это один раз в Supabase: SQL Editor -> New query -> вставь -> Run.
-- Создаёт таблицу для данных и включает защиту: каждый видит только свои данные.

create table if not exists public.states (
  user_id    uuid primary key references auth.users on delete cascade,
  data       jsonb,
  updated_at timestamptz default now()
);

alter table public.states enable row level security;

drop policy if exists "own row select" on public.states;
drop policy if exists "own row insert" on public.states;
drop policy if exists "own row update" on public.states;

create policy "own row select" on public.states
  for select using (auth.uid() = user_id);
create policy "own row insert" on public.states
  for insert with check (auth.uid() = user_id);
create policy "own row update" on public.states
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
