# Applying Metahubs Schema Migration

## Overview

The metahubs database schema is defined in two SQL migration files:
1. `20260211_create_metahubs_schema.sql` - Tables, columns, indexes (EF Core generated)
2. `20260211_add_enums_and_rls.sql` - ENUMs, RLS policies, permissions (manual supplement)

## Option A: Apply via Supabase Studio SQL Editor (Recommended)

### Step 1: Access SQL Editor
1. Go to https://supabase.com/dashboard/project/pleeyslewsialvplxdpg
2. Click **SQL Editor** in the left sidebar
3. Click **New query**

### Step 2: Apply First Migration
1. Open `supabase/migrations/20260211_create_metahubs_schema.sql` in your code editor
2. Copy the entire SQL content
3. Paste into Supabase SQL Editor
4. Click **Run** (or press Ctrl+Enter)
5. Wait for completion - should see "Success. No rows returned" message
6. Verify in **Table Editor**: You should now see `metahubs` schema with 5 tables

### Step 3: Apply Second Migration
1. Open `supabase/migrations/20260211_add_enums_and_rls.sql`
2. Copy the entire SQL content
3. Paste into a new query in Supabase SQL Editor
4. Click **Run**
5. Verify:
   - Check **Database** → **Types**: Should see 2 ENUM types
   - Check any table → **Policies** tab: Should see RLS policies listed

### Step 4: Verify Schema
Run this verification query in SQL Editor:
```sql
-- Check tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'metahubs' 
ORDER BY table_name;

-- Check ENUMs
SELECT typname 
FROM pg_type 
WHERE typnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'metahubs')
AND typtype = 'e';

-- Check RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'metahubs';
```

Expected results:
- 6 tables: `__EFMigrationsHistory`, `metahubs`, `metahubs_branches`, `metahubs_users`, `publications`, `publication_versions`
- 2 ENUMs: `publication_access_mode`, `publication_schema_status`
- All 5 data tables should have `rowsecurity = true`

## Option B: Apply via Supabase CLI (Alternative)

### Prerequisites
This requires Supabase CLI authentication, which needs manual user action.

### Steps
1. Authenticate with Supabase:
   ```bash
   supabase login
   # Browser will open - login with your Supabase account
   ```

2. Link to project:
   ```bash
   supabase link --project-ref pleeyslewsialvplxdpg
   # Enter database password when prompted: IQBo6zsLmpLjMPm8
   ```

3. Apply migrations:
   ```bash
   supabase db push
   ```

This will automatically apply all SQL files in `supabase/migrations/` directory in order.

## What These Migrations Create

### Schema: `metahubs`

**Tables:**
1. **metahubs** - Main metahub entities
2. **metahubs_branches** - Metahub branches (versions/variants)
3. **metahubs_users** - User-metahub relationships and permissions
4. **publications** - Published data collections
5. **publication_versions** - Version history of publications

**System Fields (all tables):**
- Platform-level: `_upl_created_at`, `_upl_updated_at`, `_upl_deleted`, `_upl_archived`, etc.
- Metahub-level: `_mhb_published`, `_mhb_deleted`, `_mhb_archived`

**JSONB Columns:**
- Multilingual content: `name`, `description` (VersionedLocalizedContent pattern)
- Configuration: `access_config`, `schema_snapshot`

**Indexes:**
- 22+ indexes including:
  - Partial unique indexes (exclude soft-deleted)
  - GIN indexes for JSONB search
  - Regular indexes for foreign keys and filters

**Row Level Security (RLS):**
- Enabled on all tables
- Policies enforce:
  - Users can only access metahubs they're members of
  - Public metahubs accessible to all
  - Owners have full permissions
  - Members have read access

**ENUMs:**
- `publication_access_mode`: Full, Restricted
- `publication_schema_status`: Draft, Pending, Synced, Outdated, Error

## Troubleshooting

### Error: "schema metahubs already exists"
If you previously created the schema manually:
```sql
-- Drop existing schema (WARNING: deletes all data)
DROP SCHEMA IF EXISTS metahubs CASCADE;
-- Then rerun the migrations
```

### Error: "type publication_access_mode already exists"
Skip the ENUM creation part of migration 2, or drop and recreate:
```sql
DROP TYPE IF EXISTS metahubs.publication_access_mode CASCADE;
DROP TYPE IF EXISTS metahubs.publication_schema_status CASCADE;
-- Then rerun migration 2
```

### Error: "relation __EFMigrationsHistory already exists"
The migrations table already exists from a previous attempt. This is safe to ignore, or you can:
```sql
-- Check existing migrations
SELECT * FROM metahubs."__EFMigrationsHistory";
-- If empty or you want to reset, drop it
DROP TABLE IF EXISTS metahubs."__EFMigrationsHistory";
```

## Next Steps

After successful migration:
1. ✅ Verify schema in Supabase Studio
2. ✅ Test RLS policies with authenticated user
3. ✅ Update application to use new schema
4. ✅ Create initial test data (optional)
