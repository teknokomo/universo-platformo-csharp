-- Grant explicit permissions on metahubs tables to anon and authenticated roles

-- Grant SELECT on all metahubs tables to anon (for public metahubs)
GRANT SELECT ON public.metahubs TO anon, authenticated;
GRANT SELECT ON public.metahubs_branches TO anon, authenticated;
GRANT SELECT ON public.metahubs_users TO anon, authenticated;
GRANT SELECT ON public.publications TO anon, authenticated;
GRANT SELECT ON public.publication_versions TO anon, authenticated;

-- Grant INSERT, UPDATE, DELETE to authenticated users
GRANT INSERT, UPDATE, DELETE ON public.metahubs TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.metahubs_branches TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.metahubs_users TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.publications TO authenticated;
GRANT INSERT, UPDATE, DELETE ON public.publication_versions TO authenticated;

-- Grant USAGE on sequences if any
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- Set default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT SELECT ON TABLES TO anon, authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT INSERT, UPDATE, DELETE ON TABLES TO authenticated;
