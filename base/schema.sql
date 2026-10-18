-- =====================================================================
--  Studio Kanté — base des cartes numériques
--  À coller dans Supabase : projet → SQL Editor → New query → Run.
--  Le script est rejouable : on peut le relancer sans rien casser.
-- =====================================================================

-- ---------------------------------------------------------------- tables

create table if not exists public.restaurants (
  id           uuid primary key default gen_random_uuid(),
  slug         text unique not null check (slug ~ '^[a-z0-9-]{2,60}$'),
  nom_fr       text not null,
  nom_ar       text,
  tagline_fr   text,
  tagline_ar   text,
  wa           text not null check (wa ~ '^[0-9]{9,15}$'),
  ouvre        int  not null default 12 check (ouvre between 0 and 23),
  ferme        int  not null default 23 check (ferme between 1 and 30),
  aide         jsonb not null default '{}'::jsonb,
  actif        boolean not null default true,
  cree_le      timestamptz not null default now(),
  constraint horaires_coherents check (ferme > ouvre)
);

-- qui a le droit de modifier quelle carte
create table if not exists public.membres (
  restaurant_id uuid not null references public.restaurants(id) on delete cascade,
  user_id       uuid not null references auth.users(id) on delete cascade,
  role          text not null default 'patron' check (role in ('patron','studio')),
  ajoute_le     timestamptz not null default now(),
  primary key (restaurant_id, user_id)
);

create table if not exists public.sections (
  id            uuid primary key default gen_random_uuid(),
  restaurant_id uuid not null references public.restaurants(id) on delete cascade,
  cle           text not null check (cle ~ '^[a-z0-9-]{1,40}$'),
  rang          int  not null default 0,
  titre_fr      text not null,
  titre_ar      text,
  -- une « formule » est une section à prix unique, sans liste de plats
  formule       boolean not null default false,
  f_titre_fr    text,
  f_titre_ar    text,
  f_detail_fr   text,
  f_detail_ar   text,
  prix          numeric(10,2) check (prix is null or prix >= 0),
  unique (restaurant_id, cle)
);

create table if not exists public.plats (
  id         uuid primary key default gen_random_uuid(),
  section_id uuid not null references public.sections(id) on delete cascade,
  rang       int  not null default 0,
  nom_fr     text not null,
  nom_ar     text,
  desc_fr    text,
  desc_ar    text,
  prix       numeric(10,2) not null check (prix >= 0),
  photo      text,
  etiquettes text[] not null default '{}',
  -- un plat en rupture reste dans la carte mais n'est plus commandable
  dispo      boolean not null default true,
  maj_le     timestamptz not null default now()
);

create index if not exists plats_section_rang  on public.plats (section_id, rang);
create index if not exists sections_resto_rang on public.sections (restaurant_id, rang);
create index if not exists membres_user        on public.membres (user_id);

-- --------------------------------------------- qui gère quoi (sans récursion)
-- Une politique qui interrogerait « membres » directement déclencherait la
-- politique de « membres », donc une récursion. On passe par une fonction
-- security definer : elle lit la table en contournant RLS, et ne répond que
-- par oui ou non sur le restaurant demandé.
create or replace function public.gere(rid uuid)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.membres
    where restaurant_id = rid and user_id = auth.uid()
  );
$$;

revoke all on function public.gere(uuid) from public;
grant execute on function public.gere(uuid) to authenticated;

-- la même chose, en partant d'une section
create or replace function public.gere_section(sid uuid)
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1
    from public.sections s
    join public.membres m on m.restaurant_id = s.restaurant_id
    where s.id = sid and m.user_id = auth.uid()
  );
$$;

revoke all on function public.gere_section(uuid) from public;
grant execute on function public.gere_section(uuid) to authenticated;

-- ------------------------------------------------------------- verrouillage
alter table public.restaurants enable row level security;
alter table public.membres     enable row level security;
alter table public.sections    enable row level security;
alter table public.plats       enable row level security;

-- Lecture publique : n'importe quel client attablé doit pouvoir lire la carte,
-- sans compte. Seules les cartes actives sortent.
drop policy if exists resto_lecture on public.restaurants;
create policy resto_lecture on public.restaurants
  for select using (actif);

drop policy if exists sections_lecture on public.sections;
create policy sections_lecture on public.sections
  for select using (exists (
    select 1 from public.restaurants r
    where r.id = restaurant_id and r.actif
  ));

drop policy if exists plats_lecture on public.plats;
create policy plats_lecture on public.plats
  for select using (exists (
    select 1 from public.sections s
    join public.restaurants r on r.id = s.restaurant_id
    where s.id = section_id and r.actif
  ));

-- Écriture : seulement le patron de ce restaurant.
drop policy if exists resto_ecriture on public.restaurants;
create policy resto_ecriture on public.restaurants
  for update to authenticated
  using (public.gere(id)) with check (public.gere(id));

drop policy if exists sections_ecriture on public.sections;
create policy sections_ecriture on public.sections
  for all to authenticated
  using (public.gere(restaurant_id)) with check (public.gere(restaurant_id));

drop policy if exists plats_ecriture on public.plats;
create policy plats_ecriture on public.plats
  for all to authenticated
  using (public.gere_section(section_id)) with check (public.gere_section(section_id));

-- Chacun ne voit que ses propres rattachements.
drop policy if exists membres_lecture on public.membres;
create policy membres_lecture on public.membres
  for select to authenticated using (user_id = auth.uid());

-- Personne ne s'ajoute lui-même à un restaurant : c'est le studio qui
-- rattache un patron, depuis le tableau de bord Supabase.
-- (Aucune politique insert/update/delete sur membres : tout est refusé.)

-- ------------------------------------------------------------------ droits
-- Supabase accorde ces droits par défaut aux nouvelles tables. On les écrit
-- quand même : ainsi c'est RLS, et seulement RLS, qui décide de tout — et
-- le schéma dit explicitement ce qu'il autorise.
grant usage on schema public to anon, authenticated;
grant select on public.restaurants, public.sections, public.plats to anon, authenticated;
grant select on public.membres to authenticated;
grant update on public.restaurants to authenticated;
grant insert, update, delete on public.sections, public.plats to authenticated;
-- personne ne touche à la table des rattachements depuis l'extérieur
revoke insert, update, delete on public.membres from anon, authenticated;

-- -------------------------------------------------------- horodatage des maj
create or replace function public.touche_plat()
returns trigger language plpgsql as $$
begin
  new.maj_le := now();
  return new;
end;
$$;

drop trigger if exists plats_maj on public.plats;
create trigger plats_maj before update on public.plats
  for each row execute function public.touche_plat();

-- ---------------------------------------------- la carte en un seul appel
-- Le moteur n'a pas à faire trois requêtes : cette vue renvoie la carte
-- entière, dans la forme que la page attend déjà.
create or replace function public.carte(p_slug text)
returns jsonb
language sql
stable
set search_path = public
as $$
  select jsonb_build_object(
    'slug',    r.slug,
    'demo',    false,
    'nom',     jsonb_build_object('fr', r.nom_fr,     'ar', coalesce(r.nom_ar, r.nom_fr)),
    'tagline', jsonb_build_object('fr', coalesce(r.tagline_fr,''), 'ar', coalesce(r.tagline_ar,'')),
    'wa',      r.wa,
    'ouvre',   r.ouvre,
    'ferme',   r.ferme,
    'aide',    r.aide,
    'sections', coalesce((
      select jsonb_agg(sec order by sec_rang)
      from (
        select s.rang as sec_rang,
          case when s.formule then
            jsonb_build_object(
              'id', s.cle, 'fr', s.titre_fr, 'ar', coalesce(s.titre_ar, s.titre_fr),
              'deal', true,
              'fr_t', coalesce(s.f_titre_fr,''),  'ar_t', coalesce(s.f_titre_ar, s.f_titre_fr, ''),
              'fr_d', coalesce(s.f_detail_fr,''), 'ar_d', coalesce(s.f_detail_ar, s.f_detail_fr, ''),
              'price', coalesce(s.prix, 0)
            )
          else
            jsonb_build_object(
              'id', s.cle, 'fr', s.titre_fr, 'ar', coalesce(s.titre_ar, s.titre_fr),
              'items', coalesce((
                select jsonb_agg(
                  jsonb_build_object(
                    'fr', p.nom_fr, 'ar', coalesce(p.nom_ar, p.nom_fr),
                    'p',  p.prix,
                    'fd', coalesce(p.desc_fr,''), 'ad', coalesce(p.desc_ar, p.desc_fr, ''),
                    'img', coalesce(p.photo,''),
                    'tags', to_jsonb(p.etiquettes)
                  ) order by p.rang, p.nom_fr)
                from public.plats p
                where p.section_id = s.id and p.dispo
              ), '[]'::jsonb)
            )
          end as sec
        from public.sections s
        where s.restaurant_id = r.id
      ) q
    ), '[]'::jsonb)
  )
  from public.restaurants r
  where r.slug = p_slug and r.actif;
$$;

grant execute on function public.carte(text) to anon, authenticated;

-- ------------------------------------------- de l'atelier vers la base
-- L'atelier produit déjà la bonne forme. Cette fonction l'avale telle quelle :
-- une carte saisie à la main peut donc passer dans la base sans ressaisie.
-- Réservée au studio : à lancer depuis le SQL Editor.
create or replace function public.importer(f jsonb)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  rid  uuid;
  sec  jsonb;
  it   jsonb;
  sid  uuid;
  i    int := 0;
  j    int;
begin
  insert into public.restaurants (slug, nom_fr, nom_ar, tagline_fr, tagline_ar,
                                  wa, ouvre, ferme, aide)
  values (
    f->>'slug',
    f#>>'{nom,fr}',
    nullif(f#>>'{nom,ar}', ''),
    nullif(f#>>'{tagline,fr}', ''),
    nullif(f#>>'{tagline,ar}', ''),
    regexp_replace(coalesce(f->>'wa',''), '[^0-9]', '', 'g'),
    coalesce((f->>'ouvre')::int, 12),
    coalesce((f->>'ferme')::int, 23),
    coalesce(f->'aide', '{}'::jsonb)
  )
  on conflict (slug) do update set
    nom_fr = excluded.nom_fr, nom_ar = excluded.nom_ar,
    tagline_fr = excluded.tagline_fr, tagline_ar = excluded.tagline_ar,
    wa = excluded.wa, ouvre = excluded.ouvre, ferme = excluded.ferme,
    aide = excluded.aide
  returning id into rid;

  -- on remplace la carte entière : c'est un import, pas une fusion
  delete from public.sections where restaurant_id = rid;

  for sec in select * from jsonb_array_elements(coalesce(f->'sections', '[]'::jsonb))
  loop
    insert into public.sections (restaurant_id, cle, rang, titre_fr, titre_ar,
                                 formule, f_titre_fr, f_titre_ar,
                                 f_detail_fr, f_detail_ar, prix)
    values (
      rid,
      coalesce(nullif(sec->>'id',''), 'section-' || i),
      i,
      coalesce(nullif(sec->>'fr',''), 'Sans titre'),
      nullif(sec->>'ar',''),
      coalesce((sec->>'deal')::boolean, false),
      nullif(sec->>'fr_t',''), nullif(sec->>'ar_t',''),
      nullif(sec->>'fr_d',''), nullif(sec->>'ar_d',''),
      nullif(sec->>'price','')::numeric
    )
    returning id into sid;

    j := 0;
    for it in select * from jsonb_array_elements(coalesce(sec->'items', '[]'::jsonb))
    loop
      insert into public.plats (section_id, rang, nom_fr, nom_ar,
                                desc_fr, desc_ar, prix, photo, etiquettes)
      values (
        sid, j,
        coalesce(nullif(it->>'fr',''), 'Sans nom'),
        nullif(it->>'ar',''),
        nullif(it->>'fd',''), nullif(it->>'ad',''),
        coalesce(nullif(it->>'p','')::numeric, 0),
        nullif(it->>'img',''),
        coalesce(
          (select array_agg(x) from jsonb_array_elements_text(coalesce(it->'tags','[]'::jsonb)) x),
          '{}'::text[]
        )
      );
      j := j + 1;
    end loop;
    i := i + 1;
  end loop;

  return rid;
end;
$$;

revoke all on function public.importer(jsonb) from public, anon, authenticated;
