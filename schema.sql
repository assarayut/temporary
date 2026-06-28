-- Run this in Supabase Dashboard → SQL Editor

create table if not exists user_data (
  id uuid references auth.users on delete cascade primary key,
  lang text default 'th',
  theme text default 'dark',
  port_names jsonb default '{}',
  strategies jsonb default '{}',
  goals jsonb default '[]',
  extra_ports jsonb default '[]',
  extra_holdings jsonb default '{}',
  watchlist jsonb default '[]',
  members jsonb default '[]',
  custom_stocks jsonb default '[]',
  hidden_stocks jsonb default '[]',
  settings jsonb default '{}',
  updated_at timestamptz default now()
);

alter table user_data enable row level security;

create policy "Users own their data"
  on user_data for all
  using (auth.uid() = id)
  with check (auth.uid() = id);

create table if not exists transactions (
  id bigserial primary key,
  user_id uuid references auth.users on delete cascade not null,
  date date not null,
  type text not null,
  port_id text not null,
  sym text not null,
  amount numeric(14,2) not null,
  owner text not null,
  source text,
  source_from text,
  wht numeric(14,2),
  reason text,
  created_at timestamptz default now()
);

alter table transactions enable row level security;

create policy "Users own their transactions"
  on transactions for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
