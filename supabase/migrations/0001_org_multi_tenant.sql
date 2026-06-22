-- ============================================================
-- DevOps Incident Commander Dashboard
-- Migration 0001: Multi-tenant organizations, invites, QR join
-- requests, org-scoped integration settings, and shared
-- (org-scoped) incidents/comments replacing per-device storage.
--
-- Run this once against your Supabase project's SQL editor
-- (or via `supabase db push` if you adopt the Supabase CLI).
-- This migration assumes a fresh-start cutover (see plan
-- Section E): pre-existing `profiles.role` and
-- `integration_settings` (user-scoped) rows are not migrated
-- 1:1 into the new org model, since there is no reliable
-- automatic way to decide which organization an existing user's
-- credentials belong to.
-- ============================================================

create extension if not exists "pgcrypto";

-- ============================================================
-- TABLE: organizations
-- ============================================================
create table if not exists public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_by uuid not null references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

create index if not exists idx_organizations_created_by on public.organizations(created_by);

-- ============================================================
-- TABLE: profiles (trimmed to identity only — role moves to
-- organization_members since role is now per-membership)
-- ============================================================
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now()
);

alter table public.profiles drop column if exists role;
alter table public.profiles add column if not exists display_name text;
alter table public.profiles add column if not exists created_at timestamptz not null default now();

-- ============================================================
-- TABLE: organization_members
-- ============================================================
create table if not exists public.organization_members (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'responder' check (role in ('viewer', 'responder', 'commander')),
  joined_at timestamptz not null default now(),
  unique (organization_id, user_id)
);

create index if not exists idx_org_members_org on public.organization_members(organization_id);
create index if not exists idx_org_members_user on public.organization_members(user_id);

-- ============================================================
-- HELPER FUNCTIONS (SECURITY DEFINER to dodge RLS self-recursion)
-- ============================================================
create or replace function public.is_org_member(p_org_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.organization_members
    where organization_id = p_org_id and user_id = auth.uid()
  );
$$;

create or replace function public.org_role(p_org_id uuid)
returns text
language sql
security definer
set search_path = public
stable
as $$
  select role from public.organization_members
  where organization_id = p_org_id and user_id = auth.uid()
  limit 1;
$$;

create or replace function public.is_org_commander(p_org_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select coalesce(public.org_role(p_org_id) = 'commander', false);
$$;

create or replace function public.is_org_responder_or_above(p_org_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select coalesce(public.org_role(p_org_id) in ('responder', 'commander'), false);
$$;

-- ============================================================
-- TABLE: org_invites (invite-code/link flow — instant-join)
-- ============================================================
create table if not exists public.org_invites (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  code text not null unique default substr(replace(gen_random_uuid()::text, '-', ''), 1, 10),
  created_by uuid not null references auth.users(id),
  role_to_grant text not null default 'responder' check (role_to_grant in ('viewer', 'responder', 'commander')),
  max_uses integer,
  use_count integer not null default 0,
  expires_at timestamptz,
  revoked boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists idx_org_invites_org on public.org_invites(organization_id);

-- ============================================================
-- TABLE: join_requests (QR scan-to-join flow — pending approval)
-- ============================================================
create table if not exists public.join_requests (
  id uuid primary key default gen_random_uuid(),
  requester_user_id uuid not null references auth.users(id) on delete cascade,
  token text not null unique,
  organization_id uuid references public.organizations(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'approved', 'denied', 'expired')),
  requested_role text not null default 'responder' check (requested_role in ('viewer', 'responder', 'commander')),
  expires_at timestamptz not null default (now() + interval '10 minutes'),
  resolved_by uuid references auth.users(id),
  resolved_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists idx_join_requests_token on public.join_requests(token);
create index if not exists idx_join_requests_requester on public.join_requests(requester_user_id);
create index if not exists idx_join_requests_org on public.join_requests(organization_id);

-- ============================================================
-- TABLE: integration_settings (org-scoped, replacing user-scoped)
-- ============================================================
-- NOTE: if you have an existing user-scoped `integration_settings`
-- table from before this migration, rename it out of the way first:
--   alter table if exists public.integration_settings rename to integration_settings_legacy_by_user;
alter table if exists public.integration_settings rename to integration_settings_legacy_by_user;

create table if not exists public.integration_settings (
  organization_id uuid primary key references public.organizations(id) on delete cascade,
  github_owner text not null default '',
  github_repo text not null default '',
  encrypted_github_token text not null default '',
  encrypted_pager_duty_token text not null default '',
  aws_access_key text not null default '',
  encrypted_aws_secret text not null default '',
  aws_region text not null default 'us-east-1',
  azure_tenant_id text not null default '',
  azure_client_id text not null default '',
  encrypted_azure_secret text not null default '',
  azure_subscription_id text not null default '',
  gcp_project_id text not null default '',
  encrypted_gcp_token text not null default '',
  gcp_is_api_key boolean not null default true,
  updated_by uuid references auth.users(id),
  updated_at timestamptz not null default now()
);

-- ============================================================
-- TABLE: incidents (org-scoped, replacing SharedPreferences overlay)
-- ============================================================
create table if not exists public.incidents (
  id text primary key,
  organization_id uuid not null references public.organizations(id) on delete cascade,
  title text not null,
  description text not null,
  status text not null default 'triggered' check (status in ('triggered', 'acknowledged', 'escalated', 'resolved')),
  urgency text not null,
  service_data text not null,
  provider text not null check (provider in ('gcp', 'aws', 'azure', 'githubActions', 'pagerDuty')),
  created_at timestamptz not null,
  acknowledged_at timestamptz,
  assigned_at timestamptz,
  resolved_at timestamptz,
  assigned_to uuid references public.organization_members(id) on delete set null,
  raw_provider_payload jsonb,
  last_synced_at timestamptz not null default now()
);

create index if not exists idx_incidents_org on public.incidents(organization_id);
create index if not exists idx_incidents_status on public.incidents(organization_id, status);

-- ============================================================
-- TABLE: incident_comments
-- ============================================================
create table if not exists public.incident_comments (
  id uuid primary key default gen_random_uuid(),
  incident_id text not null references public.incidents(id) on delete cascade,
  organization_id uuid not null references public.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id),
  user_name text not null,
  text text not null,
  created_at timestamptz not null default now()
);

create index if not exists idx_incident_comments_incident on public.incident_comments(incident_id);
create index if not exists idx_incident_comments_org on public.incident_comments(organization_id);

-- ============================================================
-- RLS: enable on every tenant table
-- ============================================================
alter table public.organizations enable row level security;
alter table public.profiles enable row level security;
alter table public.organization_members enable row level security;
alter table public.org_invites enable row level security;
alter table public.join_requests enable row level security;
alter table public.integration_settings enable row level security;
alter table public.incidents enable row level security;
alter table public.incident_comments enable row level security;

-- ============================================================
-- RLS POLICIES: organizations
-- ============================================================
drop policy if exists "org_select_members" on public.organizations;
create policy "org_select_members" on public.organizations
  for select using (public.is_org_member(id));

drop policy if exists "org_insert_any_authenticated" on public.organizations;
create policy "org_insert_any_authenticated" on public.organizations
  for insert with check (auth.uid() = created_by);

drop policy if exists "org_update_commander" on public.organizations;
create policy "org_update_commander" on public.organizations
  for update using (public.is_org_commander(id));

drop policy if exists "org_delete_commander" on public.organizations;
create policy "org_delete_commander" on public.organizations
  for delete using (public.is_org_commander(id));

create or replace function public.handle_new_organization()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.organization_members (organization_id, user_id, role)
  values (new.id, new.created_by, 'commander');
  return new;
end;
$$;

drop trigger if exists on_organization_created on public.organizations;
create trigger on_organization_created
  after insert on public.organizations
  for each row execute function public.handle_new_organization();

-- ============================================================
-- RLS POLICIES: profiles
-- ============================================================
drop policy if exists "profiles_select_self_or_org_peers" on public.profiles;
create policy "profiles_select_self_or_org_peers" on public.profiles
  for select using (
    auth.uid() = id
    or exists (
      select 1 from public.organization_members m1
      join public.organization_members m2 on m1.organization_id = m2.organization_id
      where m1.user_id = auth.uid() and m2.user_id = profiles.id
    )
  );

drop policy if exists "profiles_insert_self" on public.profiles;
create policy "profiles_insert_self" on public.profiles
  for insert with check (auth.uid() = id);

drop policy if exists "profiles_update_self" on public.profiles;
create policy "profiles_update_self" on public.profiles
  for update using (auth.uid() = id);

-- ============================================================
-- RLS POLICIES: organization_members
-- ============================================================
drop policy if exists "members_select_org_peers" on public.organization_members;
create policy "members_select_org_peers" on public.organization_members
  for select using (public.is_org_member(organization_id));

drop policy if exists "members_insert_commander_or_self_via_function" on public.organization_members;
create policy "members_insert_commander_or_self_via_function" on public.organization_members
  for insert with check (public.is_org_commander(organization_id));
  -- Self-service joins (invite code / QR approval) go through the
  -- SECURITY DEFINER RPCs below, which bypass this policy intentionally
  -- after validating the invite/join_request server-side.

drop policy if exists "members_update_commander" on public.organization_members;
create policy "members_update_commander" on public.organization_members
  for update using (public.is_org_commander(organization_id));

drop policy if exists "members_delete_commander_or_self" on public.organization_members;
create policy "members_delete_commander_or_self" on public.organization_members
  for delete using (
    public.is_org_commander(organization_id) or user_id = auth.uid()
  );

-- ============================================================
-- RLS POLICIES: org_invites
-- ============================================================
drop policy if exists "invites_select_org_members" on public.org_invites;
create policy "invites_select_org_members" on public.org_invites
  for select using (public.is_org_member(organization_id));

drop policy if exists "invites_insert_commander" on public.org_invites;
create policy "invites_insert_commander" on public.org_invites
  for insert with check (public.is_org_commander(organization_id));

drop policy if exists "invites_update_commander" on public.org_invites;
create policy "invites_update_commander" on public.org_invites
  for update using (public.is_org_commander(organization_id));

drop policy if exists "invites_delete_commander" on public.org_invites;
create policy "invites_delete_commander" on public.org_invites
  for delete using (public.is_org_commander(organization_id));

-- ============================================================
-- RLS POLICIES: join_requests
-- ============================================================
drop policy if exists "join_requests_select_self_or_org_commander" on public.join_requests;
create policy "join_requests_select_self_or_org_commander" on public.join_requests
  for select using (
    requester_user_id = auth.uid()
    or (organization_id is not null and public.is_org_commander(organization_id))
  );

drop policy if exists "join_requests_insert_self" on public.join_requests;
create policy "join_requests_insert_self" on public.join_requests
  for insert with check (requester_user_id = auth.uid());

drop policy if exists "join_requests_update_commander_or_requester_cancel" on public.join_requests;
create policy "join_requests_update_commander_or_requester_cancel" on public.join_requests
  for update using (
    (organization_id is not null and public.is_org_commander(organization_id))
    or requester_user_id = auth.uid()
  );

-- ============================================================
-- RLS POLICIES: integration_settings
-- ============================================================
drop policy if exists "integration_settings_select_org_members" on public.integration_settings;
create policy "integration_settings_select_org_members" on public.integration_settings
  for select using (public.is_org_member(organization_id));

drop policy if exists "integration_settings_insert_commander" on public.integration_settings;
create policy "integration_settings_insert_commander" on public.integration_settings
  for insert with check (public.is_org_commander(organization_id));

drop policy if exists "integration_settings_update_commander" on public.integration_settings;
create policy "integration_settings_update_commander" on public.integration_settings
  for update using (public.is_org_commander(organization_id));

drop policy if exists "integration_settings_delete_commander" on public.integration_settings;
create policy "integration_settings_delete_commander" on public.integration_settings
  for delete using (public.is_org_commander(organization_id));

-- ============================================================
-- RLS POLICIES: incidents
-- ============================================================
drop policy if exists "incidents_select_org_members" on public.incidents;
create policy "incidents_select_org_members" on public.incidents
  for select using (public.is_org_member(organization_id));

drop policy if exists "incidents_insert_responder_or_above" on public.incidents;
create policy "incidents_insert_responder_or_above" on public.incidents
  for insert with check (public.is_org_responder_or_above(organization_id));

drop policy if exists "incidents_update_responder_or_above" on public.incidents;
create policy "incidents_update_responder_or_above" on public.incidents
  for update using (public.is_org_responder_or_above(organization_id));

drop policy if exists "incidents_delete_commander" on public.incidents;
create policy "incidents_delete_commander" on public.incidents
  for delete using (public.is_org_commander(organization_id));

-- ============================================================
-- RLS POLICIES: incident_comments
-- ============================================================
drop policy if exists "comments_select_org_members" on public.incident_comments;
create policy "comments_select_org_members" on public.incident_comments
  for select using (public.is_org_member(organization_id));

drop policy if exists "comments_insert_responder_or_above" on public.incident_comments;
create policy "comments_insert_responder_or_above" on public.incident_comments
  for insert with check (
    public.is_org_responder_or_above(organization_id) and user_id = auth.uid()
  );

drop policy if exists "comments_delete_own_or_commander" on public.incident_comments;
create policy "comments_delete_own_or_commander" on public.incident_comments
  for delete using (
    user_id = auth.uid() or public.is_org_commander(organization_id)
  );

-- ============================================================
-- RPC: redeem_org_invite (instant-join via code/link)
-- ============================================================
create or replace function public.redeem_org_invite(p_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_invite public.org_invites;
  v_org_id uuid;
begin
  select * into v_invite from public.org_invites
    where code = p_code and revoked = false
    and (expires_at is null or expires_at > now())
    and (max_uses is null or use_count < max_uses)
  for update;

  if v_invite is null then
    raise exception 'Invite code invalid, expired, or exhausted';
  end if;

  insert into public.organization_members (organization_id, user_id, role)
  values (v_invite.organization_id, auth.uid(), v_invite.role_to_grant)
  on conflict (organization_id, user_id) do nothing;

  update public.org_invites set use_count = use_count + 1 where id = v_invite.id;

  v_org_id := v_invite.organization_id;
  return v_org_id;
end;
$$;

grant execute on function public.redeem_org_invite(text) to authenticated;

-- ============================================================
-- RPC: lookup_join_request (admin scans QR, resolves token -> requester identity)
-- ============================================================
create or replace function public.lookup_join_request(p_token text)
returns table (
  request_id uuid,
  requester_user_id uuid,
  requester_display_name text,
  requested_role text,
  status text,
  expires_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
begin
  return query
    select jr.id, jr.requester_user_id, p.display_name, jr.requested_role, jr.status, jr.expires_at
    from public.join_requests jr
    left join public.profiles p on p.id = jr.requester_user_id
    where jr.token = p_token and jr.status = 'pending' and jr.expires_at > now();
end;
$$;

grant execute on function public.lookup_join_request(text) to authenticated;

-- ============================================================
-- RPC: approve_join_request / deny_join_request
-- ============================================================
create or replace function public.approve_join_request(p_request_id uuid, p_organization_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_req public.join_requests;
begin
  if not public.is_org_commander(p_organization_id) then
    raise exception 'Only commanders can approve join requests';
  end if;

  select * into v_req from public.join_requests
    where id = p_request_id and status = 'pending' and expires_at > now()
  for update;

  if v_req is null then
    raise exception 'Join request not found, already resolved, or expired';
  end if;

  insert into public.organization_members (organization_id, user_id, role)
  values (p_organization_id, v_req.requester_user_id, v_req.requested_role)
  on conflict (organization_id, user_id) do nothing;

  update public.join_requests
    set status = 'approved', organization_id = p_organization_id,
        resolved_by = auth.uid(), resolved_at = now()
    where id = p_request_id;
end;
$$;

grant execute on function public.approve_join_request(uuid, uuid) to authenticated;

create or replace function public.deny_join_request(p_request_id uuid, p_organization_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_org_commander(p_organization_id) then
    raise exception 'Only commanders can deny join requests';
  end if;
  update public.join_requests
    set status = 'denied', organization_id = p_organization_id,
        resolved_by = auth.uid(), resolved_at = now()
    where id = p_request_id and status = 'pending';
end;
$$;

grant execute on function public.deny_join_request(uuid, uuid) to authenticated;
