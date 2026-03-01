-- Supplementary Migration: Add PostgreSQL ENUMs and RLS Policies
-- This file should be applied AFTER 20260211_create_metahubs_schema.sql
-- It adds features that EF Core doesn't generate automatically

-- ============================================
-- PART 1: Create PostgreSQL ENUM Types
-- ============================================

-- Create ENUM for publication access mode
CREATE TYPE metahubs.publication_access_mode AS ENUM ('Full', 'Restricted');

-- Create ENUM for publication schema status
CREATE TYPE metahubs.publication_schema_status AS ENUM ('Draft', 'Pending', 'Synced', 'Outdated', 'Error');

-- ============================================
-- PART 2: Convert TEXT columns to ENUM types
-- ============================================

-- Convert publications.access_mode from TEXT to ENUM
ALTER TABLE metahubs.publications 
ALTER COLUMN access_mode TYPE metahubs.publication_access_mode 
USING access_mode::metahubs.publication_access_mode;

-- Convert publications.schema_status from TEXT to ENUM
ALTER TABLE metahubs.publications 
ALTER COLUMN schema_status TYPE metahubs.publication_schema_status 
USING schema_status::metahubs.publication_schema_status;

-- ============================================
-- PART 3: Enable Row Level Security (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE metahubs.metahubs ENABLE ROW LEVEL SECURITY;
ALTER TABLE metahubs.metahubs_branches ENABLE ROW LEVEL SECURITY;
ALTER TABLE metahubs.metahubs_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE metahubs.publications ENABLE ROW LEVEL SECURITY;
ALTER TABLE metahubs.publication_versions ENABLE ROW LEVEL SECURITY;

-- ============================================
-- PART 4: Create RLS Policies
-- ============================================

-- Policies for metahubs table
-- Users can view metahubs they have access to via metahubs_users
CREATE POLICY metahubs_select_policy ON metahubs.metahubs
FOR SELECT
USING (
    -- User is in metahubs_users for this metahub
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahubs.metahubs."Id"
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
    -- OR metahub is public and not deleted
    OR (
        is_public = true
        AND _upl_deleted = false
        AND _mhb_deleted = false
    )
);

-- Users can insert metahubs (they become the owner automatically)
CREATE POLICY metahubs_insert_policy ON metahubs.metahubs
FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL);

-- Users can update metahubs they own
CREATE POLICY metahubs_update_policy ON metahubs.metahubs
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahubs.metahubs."Id"
        AND mu.user_id = auth.uid()
        AND mu."Role" = 'owner'
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Users can soft-delete metahubs they own
CREATE POLICY metahubs_delete_policy ON metahubs.metahubs
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahubs.metahubs."Id"
        AND mu.user_id = auth.uid()
        AND mu."Role" = 'owner'
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Policies for metahubs_branches table
-- Users can view branches of metahubs they have access to
CREATE POLICY branches_select_policy ON metahubs.metahubs_branches
FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahubs_branches.metahub_id
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
    OR EXISTS (
        SELECT 1 FROM metahubs.metahubs m
        WHERE m."Id" = metahubs_branches.metahub_id
        AND m.is_public = true
        AND m._upl_deleted = false
        AND m._mhb_deleted = false
    )
);

-- Users can create branches in metahubs they have access to
CREATE POLICY branches_insert_policy ON metahubs.metahubs_branches
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahub_id
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Users can update branches in metahubs they have access to
CREATE POLICY branches_update_policy ON metahubs.metahubs_branches
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahub_id
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Policies for metahubs_users table
-- Users can view members of metahubs they have access to
CREATE POLICY users_select_policy ON metahubs.metahubs_users
FOR SELECT
USING (
    user_id = auth.uid()
    OR EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahubs_users.metahub_id
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Only metahub owners can add/remove users
CREATE POLICY users_insert_policy ON metahubs.metahubs_users
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahub_id
        AND mu.user_id = auth.uid()
        AND mu."Role" = 'owner'
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

CREATE POLICY users_update_policy ON metahubs.metahubs_users
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahub_id
        AND mu.user_id = auth.uid()
        AND mu."Role" = 'owner'
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Policies for publications table
-- Users can view publications of metahubs they have access to
CREATE POLICY publications_select_policy ON metahubs.publications
FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = publications.metahub_id
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
    OR EXISTS (
        SELECT 1 FROM metahubs.metahubs m
        WHERE m."Id" = publications.metahub_id
        AND m.is_public = true
        AND m._upl_deleted = false
        AND m._mhb_deleted = false
    )
);

-- Users can create publications in metahubs they have access to
CREATE POLICY publications_insert_policy ON metahubs.publications
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahub_id
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Users can update publications in metahubs they have access to
CREATE POLICY publications_update_policy ON metahubs.publications
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = metahub_id
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Policies for publication_versions table
-- Users can view publication versions of metahubs they have access to
CREATE POLICY publication_versions_select_policy ON metahubs.publication_versions
FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM metahubs.publications p
        JOIN metahubs.metahubs_users mu ON mu.metahub_id = p.metahub_id
        WHERE p."Id" = publication_versions.publication_id
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
    OR EXISTS (
        SELECT 1 FROM metahubs.publications p
        JOIN metahubs.metahubs m ON m."Id" = p.metahub_id
        WHERE p."Id" = publication_versions.publication_id
        AND m.is_public = true
        AND m._upl_deleted = false
        AND m._mhb_deleted = false
    )
);

-- Users can create publication versions in metahubs they have access to
CREATE POLICY publication_versions_insert_policy ON metahubs.publication_versions
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM metahubs.publications p
        JOIN metahubs.metahubs_users mu ON mu.metahub_id = p.metahub_id
        WHERE p."Id" = publication_id
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- Users can update publication versions in metahubs they have access to
CREATE POLICY publication_versions_update_policy ON metahubs.publication_versions
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM metahubs.publications p
        JOIN metahubs.metahubs_users mu ON mu.metahub_id = p.metahub_id
        WHERE p."Id" = publication_id
        AND mu.user_id = auth.uid()
        AND mu._upl_deleted = false
        AND mu._mhb_deleted = false
    )
);

-- ============================================
-- PART 5: Grant permissions
-- ============================================

-- Grant usage on schema to authenticated users
GRANT USAGE ON SCHEMA metahubs TO authenticated;

-- Grant table permissions
GRANT ALL ON ALL TABLES IN SCHEMA metahubs TO authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA metahubs TO authenticated;

-- Grant ENUM type permissions
GRANT USAGE ON TYPE metahubs.publication_access_mode TO authenticated;
GRANT USAGE ON TYPE metahubs.publication_schema_status TO authenticated;
