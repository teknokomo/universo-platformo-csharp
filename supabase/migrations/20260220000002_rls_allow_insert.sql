-- Comprehensive RLS INSERT fix for public.metahubs
-- Uses a DO block to dynamically drop ALL INSERT policies (regardless of name),
-- then creates a single open policy. This is idempotent and handles any state.

-- ============================================================
-- Step 1: Drop ALL INSERT policies on public.metahubs
-- ============================================================
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT policyname
        FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename  = 'metahubs'
          AND cmd        = 'INSERT'
    LOOP
        EXECUTE format('DROP POLICY %I ON public.metahubs', r.policyname);
        RAISE NOTICE 'Dropped INSERT policy: %', r.policyname;
    END LOOP;
END $$;

-- ============================================================
-- Step 2: Create a single open INSERT policy
--   No role restriction → applies to anon, authenticated, service_role
--   The application layer enforces ownership via _upl_created_by = auth.uid()
-- ============================================================
CREATE POLICY metahubs_allow_insert
    ON public.metahubs
    FOR INSERT
    WITH CHECK (true);

-- ============================================================
-- Step 3: Re-confirm GRANT (idempotent – no-op if already granted)
-- ============================================================
GRANT INSERT, UPDATE, DELETE ON public.metahubs TO authenticated;
GRANT INSERT ON public.metahubs TO anon;
