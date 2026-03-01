-- Update RLS policies after moving tables to public schema
-- Drop old policies from metahubs schema and recreate for public

-- Drop old policies if they still reference the old schema location
DROP POLICY IF EXISTS metahubs_select_policy ON metahubs;
DROP POLICY IF EXISTS metahubs_insert_policy ON metahubs;
DROP POLICY IF EXISTS metahubs_update_policy ON metahubs;
DROP POLICY IF EXISTS metahubs_delete_policy ON metahubs;

-- Recreate policies for metahubs table in public schema
-- Allow anonymous users to read public metahubs
CREATE POLICY metahubs_select_public ON public.metahubs
FOR SELECT
TO anon, authenticated
USING (
    is_public = true
    AND _upl_deleted = false
    AND _mhb_deleted = false
);

-- Allow authenticated users to read their own metahubs
CREATE POLICY metahubs_select_own ON public.metahubs
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.metahubs_users mu
        WHERE mu.metahub_id = metahubs."Id"
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Allow authenticated users to create metahubs
CREATE POLICY metahubs_insert_policy ON public.metahubs
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() IS NOT NULL);

-- Allow owners to update their metahubs
CREATE POLICY metahubs_update_policy ON public.metahubs
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.metahubs_users mu
        WHERE mu.metahub_id = metahubs."Id"
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Allow owners to soft-delete their metahubs
CREATE POLICY metahubs_delete_policy ON public.metahubs
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.metahubs_users mu
        WHERE mu.metahub_id = metahubs."Id"
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Ensure RLS is enabled
ALTER TABLE public.metahubs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.metahubs_branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.metahubs_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.publications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.publication_versions ENABLE ROW LEVEL SECURITY;
