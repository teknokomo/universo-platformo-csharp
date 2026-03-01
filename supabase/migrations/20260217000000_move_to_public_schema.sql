-- Move metahubs tables from metahubs schema to public schema
-- This makes them accessible via Supabase PostgREST API without additional configuration

-- Step 1: Move tables to public schema
ALTER TABLE IF EXISTS metahubs.metahubs SET SCHEMA public;
ALTER TABLE IF EXISTS metahubs.metahubs_branches SET SCHEMA public;
ALTER TABLE IF EXISTS metahubs.metahubs_users SET SCHEMA public;
ALTER TABLE IF EXISTS metahubs.publications SET SCHEMA public;
ALTER TABLE IF EXISTS metahubs.publication_versions SET SCHEMA public;
ALTER TABLE IF EXISTS metahubs."__EFMigrationsHistory" SET SCHEMA public;

-- Step 2: Move ENUM types to public schema
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'publication_access_mode' AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'metahubs')) THEN
        ALTER TYPE metahubs.publication_access_mode SET SCHEMA public;
    END IF;
    
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'publication_schema_status' AND typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'metahubs')) THEN
        ALTER TYPE metahubs.publication_schema_status SET SCHEMA public;
    END IF;
END $$;

-- Step 3: Drop empty metahubs schema (optional, comment out if you want to keep it)
-- DROP SCHEMA IF EXISTS metahubs CASCADE;

-- Step 4: Verify tables are in public schema
SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename LIKE 'metahubs%';
