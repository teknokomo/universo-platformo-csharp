-- ============================================================
-- Fix 42501 on INSERT with RETURNING.
-- Applied: 2026-02-23
-- Cause:   supabase-csharp sends INSERT ... RETURNING * so it can
--          return the created row to the client.  PostgreSQL
--          evaluates SELECT policies against the newly inserted row
--          before returning it.  Both existing SELECT policies fail
--          for a freshly created private metahub:
--            - metahubs_select_own  → no metahubs_users row yet
--            - metahubs_select_public → is_public = false
--          Result: 42501 even though the INSERT policy passed.
-- Fix:     Add a lightweight SELECT policy that allows the creator
--          (_upl_created_by = auth.uid()) to read back the row
--          immediately after creating it.
-- ============================================================

CREATE POLICY metahubs_select_creator ON metahubs.metahubs
    FOR SELECT TO authenticated
    USING (_upl_created_by = auth.uid());

-- Reload PostgREST schema cache
NOTIFY pgrst, 'reload schema';
