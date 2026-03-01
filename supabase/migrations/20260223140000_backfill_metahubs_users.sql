-- ============================================================
-- Backfill metahubs_users for existing metahubs.
-- Applied: 2026-02-23
-- 
-- Reason: CreateMetahubAsync previously did not insert a row
--   into metahubs_users after creating the metahub. The RLS
--   policy metahubs_select_own requires a metahubs_users row
--   to exist. Without it, previously created (private) metahubs
--   are invisible on subsequent page loads.
--
-- This migration creates an 'owner' membership record for every
-- metahub whose creator (_upl_created_by) has no membership row.
-- ============================================================

INSERT INTO metahubs.metahubs_users (
    "Id",
    metahub_id,
    user_id,
    "Role",
    _upl_created_at,
    _upl_created_by,
    _upl_updated_at,
    _upl_updated_by,
    _upl_version,
    _upl_archived,
    _upl_deleted,
    _upl_locked,
    _mhb_published,
    _mhb_archived,
    _mhb_deleted
)
SELECT
    gen_random_uuid()       AS "Id",
    m."Id"                  AS metahub_id,
    m._upl_created_by       AS user_id,
    'owner'                 AS "Role",
    now()                   AS _upl_created_at,
    m._upl_created_by       AS _upl_created_by,
    now()                   AS _upl_updated_at,
    m._upl_created_by       AS _upl_updated_by,
    1                       AS _upl_version,
    false                   AS _upl_archived,
    false                   AS _upl_deleted,
    false                   AS _upl_locked,
    false                   AS _mhb_published,
    false                   AS _mhb_archived,
    false                   AS _mhb_deleted
FROM metahubs.metahubs m
WHERE
    m._upl_created_by IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM metahubs.metahubs_users mu
        WHERE mu.metahub_id = m."Id"
          AND mu.user_id    = m._upl_created_by
          AND mu._upl_deleted = false
    );

-- Report how many rows were inserted
DO $$
DECLARE inserted_count integer;
BEGIN
    GET DIAGNOSTICS inserted_count = ROW_COUNT;
    RAISE NOTICE 'backfill_metahubs_users: inserted % rows', inserted_count;
END $$;

-- Reload PostgREST schema cache (needed after DML that may affect cached plans)
NOTIFY pgrst, 'reload schema';
