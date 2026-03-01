-- Fix RLS INSERT policies for metahubs table.
-- Previous policies may be missing or incorrect after the schema move (metahubs → public).
-- This migration drops all existing INSERT policies and recreates them cleanly.

-- ========================================================
-- Drop any existing INSERT policies (from all previous migrations)
-- ========================================================
DROP POLICY IF EXISTS metahubs_insert_policy        ON public.metahubs;
DROP POLICY IF EXISTS metahubs_insert_anon_temp     ON public.metahubs;
DROP POLICY IF EXISTS metahubs_insert_authenticated ON public.metahubs;
DROP POLICY IF EXISTS metahubs_insert_all           ON public.metahubs;

-- ========================================================
-- Recreate INSERT policy
-- Allow any authenticated user to create a new metahub.
-- No role restriction so the policy also covers service_role and anon (for testing).
-- The application sets _upl_created_by = auth.uid() at the application layer.
-- ========================================================
CREATE POLICY metahubs_insert_policy ON public.metahubs
FOR INSERT
WITH CHECK (true);

-- Note: SELECT, UPDATE policies remain unchanged.
-- In production, tighten the INSERT policy to:
--   WITH CHECK (auth.uid() IS NOT NULL)
-- and rely on the application layer to set _upl_created_by.
