-- Temporary policy to allow anon to create metahubs for testing
-- This should be removed or restricted in production

CREATE POLICY metahubs_insert_anon_temp ON public.metahubs
FOR INSERT
TO anon
WITH CHECK (true);

-- Note: In production, remove this policy and require authentication
