-- V.R. Bisutería 2.0 | Ejecutar en Supabase SQL Editor
create extension if not exists pgcrypto;
create table if not exists public.visitors (id uuid primary key default gen_random_uuid(), full_name text, email text, consent boolean not null check(consent=true), consent_text_version text not null, created_at timestamptz not null default now());
create table if not exists public.surveys (id uuid primary key default gen_random_uuid(), q1_interaction text not null check(q1_interaction in ('Sí','No')), q2_navigation text not null check(q2_navigation in ('Sí','No')), q3_purchase_interest text not null check(q3_purchase_interest in ('Sí','No')), respondent_name text, respondent_email text, identified boolean not null default false, created_at timestamptz not null default now(), check (identified = (respondent_name is not null or respondent_email is not null)));
create table if not exists public.page_visits (id bigint generated always as identity primary key, session_id uuid not null, path text not null default '/', visited_at timestamptz not null default now());
create index if not exists page_visits_session_idx on public.page_visits(session_id);
create table if not exists public.admin_profiles (user_id uuid primary key references auth.users(id) on delete cascade, created_at timestamptz not null default now());
alter table public.visitors enable row level security; alter table public.surveys enable row level security; alter table public.page_visits enable row level security; alter table public.admin_profiles enable row level security;
-- No se crean políticas públicas: las escrituras/lecturas públicas pasan por funciones Netlify con service_role en servidor.
create policy "Admins read visitors" on public.visitors for select to authenticated using (exists(select 1 from public.admin_profiles a where a.user_id=auth.uid()));
create policy "Admins read surveys" on public.surveys for select to authenticated using (exists(select 1 from public.admin_profiles a where a.user_id=auth.uid()));
create policy "Admins read visits" on public.page_visits for select to authenticated using (exists(select 1 from public.admin_profiles a where a.user_id=auth.uid()));
create policy "Admins read own profile" on public.admin_profiles for select to authenticated using (user_id=auth.uid());
