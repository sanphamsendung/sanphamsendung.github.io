-- Run this entire file in Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.products (
  id text primary key,
  name text not null,
  slug text unique not null,
  images text[] default '{}',
  price integer not null default 0,
  original_price integer not null default 0,
  discount integer not null default 0,
  rating numeric(2,1) default 0,
  sold_count text default '0',
  category_id text not null default 'pet',
  description text default '',
  affiliate_link text not null,
  is_active boolean default true,
  is_top_selling boolean default false,
  is_mall boolean default false,
  is_favorite boolean default false,
  rank integer,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Safe migration if the table already existed with an older schema.
alter table public.products add column if not exists images text[] default '{}';
alter table public.products add column if not exists original_price integer default 0;
alter table public.products add column if not exists discount integer default 0;
alter table public.products add column if not exists rating numeric(2,1) default 0;
alter table public.products add column if not exists sold_count text default '0';
alter table public.products add column if not exists category_id text default 'pet';
alter table public.products add column if not exists description text default '';
alter table public.products add column if not exists affiliate_link text default '';
alter table public.products add column if not exists is_active boolean default true;
alter table public.products add column if not exists is_top_selling boolean default false;
alter table public.products add column if not exists is_mall boolean default false;
alter table public.products add column if not exists is_favorite boolean default false;
alter table public.products add column if not exists rank integer;
alter table public.products add column if not exists created_at timestamptz default now();
alter table public.products add column if not exists updated_at timestamptz default now();

alter table public.products enable row level security;
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on table public.products to anon, authenticated;

drop policy if exists "Public can read active products" on public.products;
drop policy if exists "Public can view active products" on public.products;
drop policy if exists "Allow public insert products" on public.products;
drop policy if exists "Allow public update products" on public.products;
drop policy if exists "Allow public delete products" on public.products;

create policy "Public can read active products" on public.products
for select to anon, authenticated using (is_active = true);
create policy "Allow public insert products" on public.products
for insert to anon, authenticated with check (true);
create policy "Allow public update products" on public.products
for update to anon, authenticated using (true) with check (true);
create policy "Allow public delete products" on public.products
for delete to anon, authenticated using (true);
