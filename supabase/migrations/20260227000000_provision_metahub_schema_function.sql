-- ============================================================================
-- Migration: provision_metahub_schema function
-- When a new metahub is created, this function:
--   1. Derives schema name:  mhb_<uuid_no_dashes>_b1
--   2. Creates the PostgreSQL schema
--   3. Provisions all standard tables inside it
--   4. Inserts a default branch record into metahubs.metahubs_branches
--   5. Updates metahubs.metahubs.default_branch_id
-- Called via PostgREST RPC after the metahub row is inserted.
-- Runs with SECURITY DEFINER so the authenticated user does not need
-- CREATE SCHEMA privilege — only the function owner (postgres) does.
-- ============================================================================

-- Drop old version if it exists (both schemas for safety)
DROP FUNCTION IF EXISTS public.provision_metahub_schema(uuid, uuid);
DROP FUNCTION IF EXISTS metahubs.provision_metahub_schema(uuid, uuid);

CREATE OR REPLACE FUNCTION metahubs.provision_metahub_schema(
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
            kind        varchar(50) NOT NULL,          -- "catalog", "enumeration", "reference", …
            codename    varchar(100) NOT NULL,
            table_name  varchar(150),                  -- actual table name for catalog objects
            name        jsonb,                         -- localized display name
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
            kind        varchar(50) NOT NULL,          -- "string", "integer", "boolean", "enum", "reference", …
            codename    varchar(100) NOT NULL,
            name        jsonb,
            description jsonb,
            is_required boolean NOT NULL DEFAULT false,
            is_multiple boolean NOT NULL DEFAULT false,
            default_value text,
            sort_order  integer NOT NULL DEFAULT 0,
            config      jsonb,                         -- extra type-specific configuration
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
            object_id   uuid        NOT NULL,          -- FK → _mhb_objects (kind = "enumeration")
            codename    varchar(100) NOT NULL,
            name        jsonb,
            color       varchar(20),                   -- optional colour tag (hex / css name)
            icon        varchar(100),                  -- optional icon identifier
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

    -- _mhb_elements: visual/structural elements (UI blocks, nodes, etc.)
    EXECUTE format($sql$
        CREATE TABLE IF NOT EXISTS %I._mhb_elements (
            id          uuid        NOT NULL DEFAULT gen_random_uuid(),
            kind        varchar(50) NOT NULL,
            codename    varchar(100) NOT NULL,
            name        jsonb,
            description jsonb,
            parent_id   uuid,                          -- hierarchical nesting
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
            kind         varchar(50) NOT NULL DEFAULT 'page',   -- "page", "card", "list", "form", …
            codename     varchar(100) NOT NULL,
            name         jsonb,
            description  jsonb,
            object_id    uuid,                         -- optional: layout bound to an object type
            layout_json  jsonb,                        -- full layout descriptor
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

    -- _mhb_settings: key-value settings store for this branch
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

-- Only superuser / service_role can call it directly.
-- Revoke from public, grant to authenticated so it's callable via PostgREST RPC
-- using the metahubs schema profile (Content-Profile: metahubs).
REVOKE ALL ON FUNCTION metahubs.provision_metahub_schema(uuid, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION metahubs.provision_metahub_schema(uuid, uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION metahubs.provision_metahub_schema(uuid, uuid) TO service_role;
