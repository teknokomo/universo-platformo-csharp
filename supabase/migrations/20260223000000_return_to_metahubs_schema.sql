-- ============================================================
-- Return all metahub tables to dedicated 'metahubs' schema.
-- Applied: 2026-02-23
-- Reason:  Architectural requirement — entities must reside in
--          their own schema, not mixed into public. PostgREST is
--          configured to expose 'metahubs' schema in addition to
--          'public' (see Supabase Dashboard → Settings → API and
--          supabase/config.toml).
-- ============================================================

-- ============================================================
-- Step 1: Ensure the metahubs schema exists
-- ============================================================
CREATE SCHEMA IF NOT EXISTS metahubs;

-- ============================================================
-- Step 2: Drop ALL existing policies on public.* tables
--         before moving them (policies carry wrong schema refs
--         and would break after ALTER TABLE ... SET SCHEMA).
-- ============================================================
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT policyname, tablename
        FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename IN ('metahubs','metahubs_branches','metahubs_users','publications','publication_versions')
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', r.policyname, r.tablename);
        RAISE NOTICE 'Dropped policy % on public.%', r.policyname, r.tablename;
    END LOOP;
END $$;

-- ============================================================
-- Step 3: Move tables from public → metahubs schema
-- ============================================================
ALTER TABLE public.publication_versions   SET SCHEMA metahubs;
ALTER TABLE public.publications           SET SCHEMA metahubs;
ALTER TABLE public.metahubs_users         SET SCHEMA metahubs;
ALTER TABLE public.metahubs_branches      SET SCHEMA metahubs;
ALTER TABLE public.metahubs               SET SCHEMA metahubs;

-- ============================================================
-- Step 4: Enable RLS on all tables (idempotent)
-- ============================================================
ALTER TABLE metahubs.metahubs              ENABLE ROW LEVEL SECURITY;
ALTER TABLE metahubs.metahubs              FORCE  ROW LEVEL SECURITY;

ALTER TABLE metahubs.metahubs_branches     ENABLE ROW LEVEL SECURITY;
ALTER TABLE metahubs.metahubs_branches     FORCE  ROW LEVEL SECURITY;

ALTER TABLE metahubs.metahubs_users        ENABLE ROW LEVEL SECURITY;
ALTER TABLE metahubs.metahubs_users        FORCE  ROW LEVEL SECURITY;

ALTER TABLE metahubs.publications          ENABLE ROW LEVEL SECURITY;
ALTER TABLE metahubs.publications          FORCE  ROW LEVEL SECURITY;

ALTER TABLE metahubs.publication_versions  ENABLE ROW LEVEL SECURITY;
ALTER TABLE metahubs.publication_versions  FORCE  ROW LEVEL SECURITY;

-- ============================================================
-- Step 5: Recreate RLS policies with correct schema references
-- ============================================================

-- ---------- metahubs.metahubs ----------
-- SELECT: authenticated users see their own metahubs
CREATE POLICY metahubs_select_own ON metahubs.metahubs
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM metahubs.metahubs_users mu
            WHERE mu.metahub_id = metahubs.metahubs."Id"
              AND mu.user_id    = auth.uid()
              AND mu._upl_deleted = false
              AND mu._mhb_deleted = false
        )
    );

-- SELECT: anon + authenticated see public non-deleted metahubs
CREATE POLICY metahubs_select_public ON metahubs.metahubs
    FOR SELECT TO anon, authenticated
    USING (
        is_public       = true
        AND _upl_deleted = false
        AND _mhb_deleted = false
    );

-- INSERT: any authenticated user may create a new metahub.
-- Ownership record (metahubs_users) is created by the app immediately after.
CREATE POLICY metahubs_insert ON metahubs.metahubs
    FOR INSERT TO authenticated
    WITH CHECK (auth.uid() IS NOT NULL);

-- UPDATE: only members of the metahub
CREATE POLICY metahubs_update ON metahubs.metahubs
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM metahubs.metahubs_users mu
            WHERE mu.metahub_id = metahubs.metahubs."Id"
              AND mu.user_id    = auth.uid()
              AND mu._upl_deleted = false
              AND mu._mhb_deleted = false
        )
    );

-- ---------- metahubs.metahubs_users ----------
-- Authenticated users can read memberships of metahubs they belong to
CREATE POLICY mu_select ON metahubs.metahubs_users
    FOR SELECT TO authenticated
    USING (
        user_id = auth.uid()
        OR EXISTS (
            SELECT 1 FROM metahubs.metahubs_users mu2
            WHERE mu2.metahub_id = metahubs.metahubs_users.metahub_id
              AND mu2.user_id    = auth.uid()
              AND mu2._upl_deleted = false
        )
    );

-- Authenticated users can insert membership records (app sets user_id = auth.uid())
CREATE POLICY mu_insert ON metahubs.metahubs_users
    FOR INSERT TO authenticated
    WITH CHECK (auth.uid() IS NOT NULL);

-- Only the user themselves or metahub owners can update membership records
CREATE POLICY mu_update ON metahubs.metahubs_users
    FOR UPDATE TO authenticated
    USING (user_id = auth.uid());

-- ---------- metahubs.metahubs_branches ----------
CREATE POLICY branches_select ON metahubs.metahubs_branches
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM metahubs.metahubs_users mu
            WHERE mu.metahub_id = metahubs.metahubs_branches.metahub_id
              AND mu.user_id    = auth.uid()
              AND mu._upl_deleted = false
        )
    );

CREATE POLICY branches_insert ON metahubs.metahubs_branches
    FOR INSERT TO authenticated
    WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY branches_update ON metahubs.metahubs_branches
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM metahubs.metahubs_users mu
            WHERE mu.metahub_id = metahubs.metahubs_branches.metahub_id
              AND mu.user_id    = auth.uid()
              AND mu._upl_deleted = false
        )
    );

-- ---------- metahubs.publications ----------
CREATE POLICY pub_select ON metahubs.publications
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM metahubs.metahubs_users mu
            WHERE mu.metahub_id = metahubs.publications.metahub_id
              AND mu.user_id    = auth.uid()
              AND mu._upl_deleted = false
        )
    );

CREATE POLICY pub_insert ON metahubs.publications
    FOR INSERT TO authenticated
    WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY pub_update ON metahubs.publications
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM metahubs.metahubs_users mu
            WHERE mu.metahub_id = metahubs.publications.metahub_id
              AND mu.user_id    = auth.uid()
              AND mu._upl_deleted = false
        )
    );

-- ---------- metahubs.publication_versions ----------
CREATE POLICY pv_select ON metahubs.publication_versions
    FOR SELECT TO authenticated
    USING (
        publication_id IN (
            SELECT p."Id" FROM metahubs.publications p
            JOIN metahubs.metahubs_users mu ON p.metahub_id = mu.metahub_id
            WHERE mu.user_id      = auth.uid()
              AND mu._upl_deleted  = false
        )
    );

CREATE POLICY pv_insert ON metahubs.publication_versions
    FOR INSERT TO authenticated
    WITH CHECK (auth.uid() IS NOT NULL);

-- ============================================================
-- Step 6: Grant schema-level access and table permissions
-- ============================================================
GRANT USAGE ON SCHEMA metahubs TO anon, authenticated;

GRANT SELECT                        ON ALL TABLES IN SCHEMA metahubs TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA metahubs TO authenticated;

-- ============================================================
-- Step 7: Register new EF Core migration in history
-- ============================================================
INSERT INTO public."__EFMigrationsHistory" ("MigrationId", "ProductVersion")
SELECT '20260223120000_SchemaBackToMetahubs', '9.0.0'
WHERE NOT EXISTS (
    SELECT 1 FROM public."__EFMigrationsHistory"
    WHERE "MigrationId" = '20260223120000_SchemaBackToMetahubs'
);

-- ============================================================
-- Step 8: Reload PostgREST schema cache
--         (requires 'metahubs' to be added to exposed schemas
--          in Supabase Dashboard → Settings → API first!)
-- ============================================================
NOTIFY pgrst, 'reload schema';
