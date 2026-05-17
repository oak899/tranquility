-- Run in Supabase SQL Editor if consultations table already exists.

alter table public.consultations
  add column if not exists status text not null default 'active'
    check (status in ('active', 'deleted'));

alter table public.consultations
  add column if not exists updated_at timestamptz;

create index if not exists consultations_active_created_idx
  on public.consultations (created_at desc)
  where status = 'active';
