-- ============================================================================
-- Migration: move provision_metahub_schema from metahubs → public schema
-- PostgREST RPC calls go to /rest/v1/rpc/<name> which resolves to the
-- schema specified in the client's Content-Profile header.
-- The Supabase C# SDK's Client.Rpc() uses the configured Postgrest schema,
-- but in practice the RPC endpoint resolves functions in the search_path.
-- To guarantee discoverability from any schema profile, the function must
-- live in public so it is always found without a Content-Profile override.
-- ============================================================================

-- 1. Drop old version in metahubs schema
DROP FUNCTION IF EXISTS metahubs.provision_metahub_schema(uuid, uuid);

-- 2. Re-create in public schema
CREATE OR REPLACE FUNCTION public.provision_metahub_schema(
    p_metahub_id  uuid,
    p_user_id     uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = metahubs, public
AS $$
DECLARE
    v_schema_name     text;
    v_branch_id       uuid;
    v_now             timestamptz := now();
    v_branch_name     jsonb;
    v_tables          text[];
    v_tbl             text;
BEGIN
    -- ── 1. Derive schema name ─────────────────────────────────────────────
    v_schema_name := 'mhb_' || replace(p_metahub_id::text, '-', '') || '_b1';

    -- ── 2. Create schema ──────────────────────────────────────────────────
    EXECUTE format('CREATE SCHEMA IF NOT EXISTS %I', v_schema_name);

    -- ── 3. Grant usage so authenticated role can query it in the future ───
    --      anon is intentionally excluded: private metahub schemas require auth.
    EXECUTE format('GRANT USAGE ON SCHEMA %I TO authenticated', v_schema_name);

    -- ── 4. Provision standard tables ──────────────────────────────────────

    -- _mhb_objects: object-type registry (catalogs, enumerations, references…)
    EXECUTE format($sql$
        CREATE TABLE IF NOT EXISTS %I._mhb_objects (
            id          uuid        NOT NULL DEFAULT gen_random_uuid(),
            kind        varchar(50) NOT NULL,
            codename    varchar(100) NOT NULL,
            table_name  varchar(150),
            name        jsonb,
            description jsonb,
            sort_order  integer NOT NULL DEFAULT 0,
            is_system   boolean NOT NULL DEFAULT false,
            _upl_created_at  timestamptz NOT NULL DEFAULT now(),
            _upl_created_by  uuid,
            _upl_updated_at  timestamptz NOT NULL DEFAULT now(),
            _upl_updated_by  uuid,
            _upl_deleted     boolean NOT NULL DEFAULT false,
            _upl_deleted_at  timestamptz,
            CONSTRAINT _mhb_objects_pkey PRIMARY KEY (id),
            CONSTRAINT _mhb_objects_codename_unique UNIQUE (codename)
        )
    $sql$, v_schema_name);

    -- _mhb_attributes: fields/attributes of object types
    EXECUTE format($sql$
        CREATE TABLE IF NOT EXISTS %I._mhb_attributes (
            id          uuid        NOT NULL DEFAULT gen_random_uuid(),
            object_id   uuid        NOT NULL,
            kind        varchar(50) NOT NULL,
            codename    varchar(100) NOT NULL,
            name        jsonb,
            description jsonb,
            is_required boolean NOT NULL DEFAULT false,
            is_multiple boolean NOT NULL DEFAULT false,
            default_value text,
            sort_order  integer NOT NULL DEFAULT 0,
            config      jsonb,
            _upl_created_at  timestamptz NOT NULL DEFAULT now(),
            _upl_created_by  uuid,
            _upl_updated_at  timestamptz NOT NULL DEFAULT now(),
            _upl_updated_by  uuid,
            _upl_deleted     boolean NOT NULL DEFAULT false,
            _upl_deleted_at  timestamptz,
            CONSTRAINT _mhb_attributes_pkey PRIMARY KEY (id)
        )
    $sql$, v_schema_name);

    -- _mhb_enum_values: values for enumeration-type objects
    EXECUTE format($sql$
        CREATE TABLE IF NOT EXISTS %I._mhb_enum_values (
            id          uuid        NOT NULL DEFAULT gen_random_uuid(),
            object_id   uuid        NOT NULL,
            codename    varchar(100) NOT NULL,
            name        jsonb,
            color       varchar(20),
            icon        varchar(100),
            sort_order  integer NOT NULL DEFAULT 0,
            is_default  boolean NOT NULL DEFAULT false,
            _upl_created_at  timestamptz NOT NULL DEFAULT now(),
            _upl_created_by  uuid,
            _upl_updated_at  timestamptz NOT NULL DEFAULT now(),
            _upl_updated_by  uuid,
            _upl_deleted     boolean NOT NULL DEFAULT false,
            _upl_deleted_at  timestamptz,
            CONSTRAINT _mhb_enum_values_pkey PRIMARY KEY (id)
        )
    $sql$, v_schema_name);

    -- _mhb_elements: visual/structural elements
    EXECUTE format($sql$
        CREATE TABLE IF NOT EXISTS %I._mhb_elements (
            id          uuid        NOT NULL DEFAULT gen_random_uuid(),
            kind        varchar(50) NOT NULL,
            codename    varchar(100) NOT NULL,
            name        jsonb,
            description jsonb,
            parent_id   uuid,
            sort_order  integer NOT NULL DEFAULT 0,
            config      jsonb,
            _upl_created_at  timestamptz NOT NULL DEFAULT now(),
            _upl_created_by  uuid,
            _upl_updated_at  timestamptz NOT NULL DEFAULT now(),
            _upl_updated_by  uuid,
            _upl_deleted     boolean NOT NULL DEFAULT false,
            _upl_deleted_at  timestamptz,
            CONSTRAINT _mhb_elements_pkey PRIMARY KEY (id)
        )
    $sql$, v_schema_name);

    -- _mhb_layouts: view/page layout configurations
    EXECUTE format($sql$
        CREATE TABLE IF NOT EXISTS %I._mhb_layouts (
            id           uuid        NOT NULL DEFAULT gen_random_uuid(),
            kind         varchar(50) NOT NULL DEFAULT 'page',
            codename     varchar(100) NOT NULL,
            name         jsonb,
            description  jsonb,
            object_id    uuid,
            layout_json  jsonb,
            is_default   boolean NOT NULL DEFAULT false,
            _upl_created_at  timestamptz NOT NULL DEFAULT now(),
            _upl_created_by  uuid,
            _upl_updated_at  timestamptz NOT NULL DEFAULT now(),
            _upl_updated_by  uuid,
            _upl_deleted     boolean NOT NULL DEFAULT false,
            _upl_deleted_at  timestamptz,
            CONSTRAINT _mhb_layouts_pkey PRIMARY KEY (id)
        )
    $sql$, v_schema_name);

    -- _mhb_widgets: reusable widget definitions
    EXECUTE format($sql$
        CREATE TABLE IF NOT EXISTS %I._mhb_widgets (
            id          uuid        NOT NULL DEFAULT gen_random_uuid(),
            kind        varchar(50) NOT NULL,
            codename    varchar(100) NOT NULL,
            name        jsonb,
            description jsonb,
            config      jsonb,
            _upl_created_at  timestamptz NOT NULL DEFAULT now(),
            _upl_created_by  uuid,
            _upl_updated_at  timestamptz NOT NULL DEFAULT now(),
            _upl_updated_by  uuid,
            _upl_deleted     boolean NOT NULL DEFAULT false,
            _upl_deleted_at  timestamptz,
            CONSTRAINT _mhb_widgets_pkey PRIMARY KEY (id)
        )
    $sql$, v_schema_name);

    -- _mhb_settings: key-value settings store
    EXECUTE format($sql$
        CREATE TABLE IF NOT EXISTS %I._mhb_settings (
            id          uuid        NOT NULL DEFAULT gen_random_uuid(),
            key         varchar(200) NOT NULL,
            value       jsonb,
            description text,
            _upl_created_at  timestamptz NOT NULL DEFAULT now(),
            _upl_created_by  uuid,
            _upl_updated_at  timestamptz NOT NULL DEFAULT now(),
            _upl_updated_by  uuid,
            CONSTRAINT _mhb_settings_pkey PRIMARY KEY (id),
            CONSTRAINT _mhb_settings_key_unique UNIQUE (key)
        )
    $sql$, v_schema_name);

    -- _mhb_migrations: migration/change history for this branch schema
    EXECUTE format($sql$
        CREATE TABLE IF NOT EXISTS %I._mhb_migrations (
            id             uuid        NOT NULL DEFAULT gen_random_uuid(),
            migration_name varchar(200) NOT NULL,
            description    text,
            applied_at     timestamptz  NOT NULL DEFAULT now(),
            applied_by     uuid,
            checksum       varchar(64),
            CONSTRAINT _mhb_migrations_pkey PRIMARY KEY (id),
            CONSTRAINT _mhb_migrations_name_unique UNIQUE (migration_name)
        )
    $sql$, v_schema_name);

    -- ── 5. Grant table-level privileges ───────────────────────────────────
    --      anon gets no access; RLS (step 5.1) handles per-user isolation.
    EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA %I TO authenticated', v_schema_name);

    -- ── 5.1. Enable RLS and add metahub-membership policies ───────────────
    --       Only users listed in metahubs.metahubs_users for this metahub
    --       can read or write data in its private schema tables.
    v_tables := ARRAY[
        '_mhb_objects', '_mhb_attributes', '_mhb_enum_values',
        '_mhb_elements', '_mhb_layouts', '_mhb_widgets',
        '_mhb_settings', '_mhb_migrations'
    ];
    FOREACH v_tbl IN ARRAY v_tables LOOP
        EXECUTE format('ALTER TABLE %I.%I ENABLE ROW LEVEL SECURITY', v_schema_name, v_tbl);
        EXECUTE format(
            $pol$
            CREATE POLICY metahub_members_only ON %I.%I
            AS PERMISSIVE FOR ALL TO authenticated
            USING (
                EXISTS (
                    SELECT 1 FROM metahubs.metahubs_users mu
                    WHERE mu.metahub_id = %L
                      AND mu.user_id = auth.uid()
                      AND mu._upl_deleted = false
                )
            )
            WITH CHECK (
                EXISTS (
                    SELECT 1 FROM metahubs.metahubs_users mu
                    WHERE mu.metahub_id = %L
                      AND mu.user_id = auth.uid()
                      AND mu._upl_deleted = false
                )
            )
            $pol$,
            v_schema_name, v_tbl, p_metahub_id, p_metahub_id
        );
    END LOOP;

    -- ── 6. Insert default branch record ───────────────────────────────────
    v_branch_id   := gen_random_uuid();
    v_branch_name := jsonb_build_object(
        '_schema',  '1',
        'locales',  jsonb_build_object('en', jsonb_build_object('content', 'main')),
        '_primary', 'en'
    );

    INSERT INTO metahubs.metahubs_branches (
        "Id",
        metahub_id,
        source_branch_id,
        "Name",
        "Description",
        "Codename",
        branch_number,
        schema_name,
        _upl_created_at,
        _upl_created_by,
        _upl_updated_at,
        _upl_updated_by,
        _upl_version,
        _upl_archived,
        _upl_deleted,
        _mhb_published,
        _mhb_archived,
        _mhb_deleted
    ) VALUES (
        v_branch_id,
        p_metahub_id,
        NULL,
        v_branch_name,
        NULL,
        'main',
        1,
        v_schema_name,
        v_now,
        p_user_id,
        v_now,
        p_user_id,
        1,
        false,
        false,
        false,
        false,
        false
    );

    -- ── 7. Set default_branch_id on the metahub ───────────────────────────
    UPDATE metahubs.metahubs
       SET default_branch_id = v_branch_id,
           _upl_updated_at   = v_now,
           _upl_updated_by   = p_user_id,
           _upl_version      = _upl_version + 1
     WHERE "Id" = p_metahub_id;

    -- ── 8. Return result payload ───────────────────────────────────────────
    RETURN jsonb_build_object(
        'schema_name', v_schema_name,
        'branch_id',   v_branch_id,
        'metahub_id',  p_metahub_id
    );

EXCEPTION WHEN OTHERS THEN
    RAISE;
END;
$$;

-- Grant EXECUTE to authenticated role (function is called via PostgREST RPC)
REVOKE ALL ON FUNCTION public.provision_metahub_schema(uuid, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.provision_metahub_schema(uuid, uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.provision_metahub_schema(uuid, uuid) TO service_role;

-- Thin wrapper in metahubs schema so the Supabase C# SDK can call it with
-- Content-Profile: metahubs (which is set when Schema = "metahubs" in SupabaseOptions).
-- Without this wrapper PostgREST would fail to find the function when using the
-- metahubs schema profile even though it lives in public.
DROP FUNCTION IF EXISTS metahubs.provision_metahub_schema(uuid, uuid);

CREATE OR REPLACE FUNCTION metahubs.provision_metahub_schema(
    p_metahub_id  uuid,
    p_user_id     uuid
)
RETURNS jsonb
LANGUAGE sql
SECURITY DEFINER
SET search_path = public, metahubs
AS $$
    SELECT public.provision_metahub_schema(p_metahub_id, p_user_id);
$$;

REVOKE ALL ON FUNCTION metahubs.provision_metahub_schema(uuid, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION metahubs.provision_metahub_schema(uuid, uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION metahubs.provision_metahub_schema(uuid, uuid) TO service_role;

-- Also provision the schema for any metahubs that were already created
-- but not yet provisioned (default_branch_id IS NULL).
DO $$
DECLARE
    rec RECORD;
    result jsonb;
BEGIN
    FOR rec IN
        SELECT "Id", _upl_created_by
          FROM metahubs.metahubs
         WHERE default_branch_id IS NULL
           AND _upl_deleted = false
    LOOP
        BEGIN
            result := public.provision_metahub_schema(rec."Id", rec._upl_created_by);
            RAISE NOTICE 'Provisioned schema for metahub %: %', rec."Id", result->>'schema_name';
        EXCEPTION WHEN OTHERS THEN
            RAISE WARNING 'Failed to provision schema for metahub %: %', rec."Id", SQLERRM;
        END;
    END LOOP;
END;
$$;
