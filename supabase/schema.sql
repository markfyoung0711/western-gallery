-- western-gallery schema
-- Paste this whole file into the Supabase SQL editor and run it once.
-- Edit the admin email on the marked line first.

-- ---------------------------------------------------------------- admins
-- Who is allowed to edit. Matched against the signed-in user's email claim,
-- so an address can be added here before that person has ever signed in.
create table if not exists public.admin_emails (
  email text primary key
);

-- >>> EDIT THIS LINE <<<
insert into public.admin_emails (email) values ('you@example.com')
  on conflict (email) do nothing;

-- security definer so it can read admin_emails past that table's own RLS
create or replace function public.is_admin() returns boolean
  language sql stable security definer set search_path = public as $$
    select exists (
      select 1 from public.admin_emails e
      where lower(e.email) = lower(coalesce(auth.jwt() ->> 'email',''))
    );
  $$;

grant execute on function public.is_admin() to anon, authenticated;

alter table public.admin_emails enable row level security;
-- deliberately no policies: nobody reads this table directly

-- ---------------------------------------------------------------- settings
create table if not exists public.gallery_settings (
  id             boolean primary key default true check (id),
  title          text not null default 'Gallery',
  tagline        text not null default '',
  email          text not null default '',
  default_format text not null default 'salon',
  show_name      text not null default '',
  show_where     text not null default '',
  show_when      text not null default '',
  updated_at     timestamptz not null default now()
);
insert into public.gallery_settings (id) values (true) on conflict (id) do nothing;

alter table public.gallery_settings enable row level security;

drop policy if exists "settings readable by anyone" on public.gallery_settings;
create policy "settings readable by anyone"
  on public.gallery_settings for select using (true);

drop policy if exists "settings writable by admins" on public.gallery_settings;
create policy "settings writable by admins"
  on public.gallery_settings for update
  using (public.is_admin()) with check (public.is_admin());

-- ---------------------------------------------------------------- works
create table if not exists public.works (
  id          uuid primary key default gen_random_uuid(),
  title       text not null default 'Untitled',
  category    text not null default 'landscapes',
  medium      text not null default '',
  width_in    numeric,
  height_in   numeric,
  year        int,
  price       numeric,
  status      text not null default 'available',
  in_show     boolean not null default false,
  story       text not null default '',
  image_path  text,
  thumb_path  text,
  motif       text,
  sort        int not null default 0,
  published   boolean not null default false,
  created_at  timestamptz not null default now()
);

create index if not exists works_sort_idx on public.works (sort);

alter table public.works enable row level security;

-- visitors see published works; an admin sees everything, drafts included
drop policy if exists "published works readable" on public.works;
create policy "published works readable"
  on public.works for select
  using (published = true or public.is_admin());

drop policy if exists "works writable by admins" on public.works;
create policy "works writable by admins"
  on public.works for all
  using (public.is_admin()) with check (public.is_admin());

-- ---------------------------------------------------------------- storage
insert into storage.buckets (id, name, public)
  values ('artwork', 'artwork', true)
  on conflict (id) do nothing;

drop policy if exists "artwork readable by anyone" on storage.objects;
create policy "artwork readable by anyone"
  on storage.objects for select using (bucket_id = 'artwork');

drop policy if exists "artwork uploadable by admins" on storage.objects;
create policy "artwork uploadable by admins"
  on storage.objects for insert
  with check (bucket_id = 'artwork' and public.is_admin());

drop policy if exists "artwork updatable by admins" on storage.objects;
create policy "artwork updatable by admins"
  on storage.objects for update
  using (bucket_id = 'artwork' and public.is_admin());

drop policy if exists "artwork deletable by admins" on storage.objects;
create policy "artwork deletable by admins"
  on storage.objects for delete
  using (bucket_id = 'artwork' and public.is_admin());
