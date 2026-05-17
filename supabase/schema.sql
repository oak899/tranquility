-- Run in Supabase SQL Editor (Dashboard → SQL → New query)

create extension if not exists "pgcrypto";

create table if not exists public.appointments (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null,
  phone text not null,
  email text not null,
  visit_at timestamptz not null,
  source text not null default 'app'
);

create table if not exists public.consultations (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz,
  kind text not null check (kind in ('facial', 'head_spa')),
  payload jsonb not null default '{}'::jsonb,
  source text not null default 'app',
  status text not null default 'active' check (status in ('active', 'deleted'))
);

create index if not exists appointments_created_at_idx on public.appointments (created_at desc);
create index if not exists consultations_created_at_idx on public.consultations (created_at desc);
create index if not exists consultations_active_created_idx
  on public.consultations (created_at desc)
  where status = 'active';

alter table public.appointments enable row level security;
alter table public.consultations enable row level security;

-- No public policies: app writes go through Vercel API using service role key.
