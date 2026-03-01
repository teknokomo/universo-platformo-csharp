-- ============================================================
-- Fix infinite recursion in metahubs_users RLS policy.
-- Applied: 2026-02-23
-- Cause:   mu_select policy on metahubs.metahubs_users contained
--          an EXISTS subquery that re-queried metahubs_users itself,
--          causing PostgreSQL to detect infinite recursion (42P17)
--          whenever any other policy (e.g. metahubs_select_own)
--          accessed metahubs_users during an INSERT check.
-- Fix:     Simplify mu_select to USING (user_id = auth.uid()) only.
--          Users see only their own membership rows — sufficient for
--          all app flows (create metahub → insert metahubs_users row).
-- ============================================================

-- Drop the recursive policy
DROP POLICY IF EXISTS mu_select ON metahubs.metahubs_users;

-- Recreate without self-referencing subquery
CREATE POLICY mu_select ON metahubs.metahubs_users
    FOR SELECT TO authenticated
    USING (user_id = auth.uid());

-- Reload PostgREST schema cache
NOTIFY pgrst, 'reload schema';
