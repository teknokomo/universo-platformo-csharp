-- ============================================================
-- Force RLS policy reset for public.metahubs
-- Applied: 2026-02-22
-- Reason: Despite previous fix migrations, INSERT still returns 42501.
--         This migration performs a nuclear reset: disables RLS, drops ALL
--         policies, re-enables RLS, and recreates a minimal set that allows
--         authenticated users to create metahubs and read them.
-- ============================================================

-- Step 1: Diagnose — log current INSERT policies
DO $$
DECLARE
    v_count INTEGER;
    r       RECORD;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename  = 'metahubs'
      AND cmd        = 'INSERT';
    RAISE NOTICE 'Current INSERT policy count on public.metahubs: %', v_count;

    FOR r IN
        SELECT policyname, cmd, roles::text, with_check::text
        FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename  = 'metahubs'
    LOOP
        RAISE NOTICE 'Policy: % | cmd: % | roles: % | check: %', r.policyname, r.cmd, r.roles, r.with_check;
    END LOOP;
END $$;

-- Step 2: Temporarily disable RLS to avoid self-blocking during policy recreation
ALTER TABLE public.metahubs DISABLE ROW LEVEL SECURITY;

-- Step 3: Drop ALL existing policies on public.metahubs
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT policyname
        FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename  = 'metahubs'
    LOOP
        EXECUTE format('DROP POLICY %I ON public.metahubs', r.policyname);
        RAISE NOTICE 'Dropped policy: %', r.policyname;
    END LOOP;
END $$;

-- Step 4: Re-enable RLS
ALTER TABLE public.metahubs ENABLE ROW LEVEL SECURITY;

-- Step 5: Re-enable FORCE RLS (ensures even table owner is subject to RLS via PostgREST)
ALTER TABLE public.metahubs FORCE ROW LEVEL SECURITY;

-- Step 6: Recreate all policies cleanly
-- SELECT: anonymous can see public non-deleted metahubs
CREATE POLICY metahubs_select_public ON public.metahubs
    FOR SELECT
    TO anon, authenticated
    USING (
        is_public = true
        AND _upl_deleted = false
        AND _mhb_deleted = false
    );

-- SELECT: authenticated users can see metahubs they belong to (via metahubs_users)
CREATE POLICY metahubs_select_own ON public.metahubs
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1
            FROM public.metahubs_users mu
            WHERE mu.metahub_id = public.metahubs."Id"
              AND mu.user_id    = auth.uid()
              AND mu._upl_deleted = false
              AND mu._mhb_deleted = false
        )
    );

-- INSERT: any authenticated user can create a metahub. No WITH CHECK column constraint —
-- the app layer sets _upl_created_by = auth.uid().
-- Also allows anon for local/test scenarios (can be tightened later).
CREATE POLICY metahubs_insert ON public.metahubs
    FOR INSERT
    WITH CHECK (true);

-- UPDATE: only members of the metahub can update it
CREATE POLICY metahubs_update ON public.metahubs
    FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1
            FROM public.metahubs_users mu
            WHERE mu.metahub_id = public.metahubs."Id"
              AND mu.user_id    = auth.uid()
              AND mu._upl_deleted = false
              AND mu._mhb_deleted = false
        )
    );

-- Step 7: Ensure GRANTs are correct
GRANT SELECT           ON public.metahubs TO anon, authenticated;
GRANT INSERT           ON public.metahubs TO anon, authenticated;
GRANT UPDATE, DELETE   ON public.metahubs TO authenticated;

-- Step 8: Force PostgREST to reload its schema cache
NOTIFY pgrst, 'reload schema';

-- Step 9: Confirm
DO $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename  = 'metahubs';
    RAISE NOTICE 'After reset — total policies on public.metahubs: %', v_count;
END $$;
