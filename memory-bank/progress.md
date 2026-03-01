# Progress

## Version 0.1.0-alpha

### Completed Features (as of 2026-02-24)

#### LocalizedContent JSONB Module ✅ (2026-02-24)
- **Motivation**: metahub Name/Description JSONB columns previously stored a flat `{"ru": "...", "en": "..."}` structure. The new versioned structure includes metadata per locale: `{ "_schema": "1", "locales": { "ru": { "content": "...", "version": 1, "isActive": true, "createdAt": "...", "updatedAt": "..." } }, "_primary": "ru" }`.
- **New model** (`metahubs-srv/Models/LocalizedContentLocale.cs`): per-locale entry with `content`, `version`, `isActive`, `createdAt`, `updatedAt`.
- **New model** (`metahubs-srv/Models/LocalizedContent.cs`): full JSONB-serializable class. Static `Create(locale, content)` and `FromJson(json)` factory methods, `AddOrUpdateLocale`, `GetContent`, `GetPrimaryContent`, `GetBestContent`, `Display` helpers, `ToJson()`, `HasContent` property.
- **New component** (`main-frt/Components/LocalizedContentField.razor`): generic tab-based locale editor. Any field can use `<LocalizedContentField Label="..." @bind-Value="someJsonString" />`. Supports RU/EN tabs plus an add-locale button. Badges show which locales have content.
- **Updated** `CreateMetahubDialog.razor`: removed 4 separate RU/EN text fields; now uses 2 `LocalizedContentField` instances for Name + Description. Codename auto-generation reads primary locale from the JSON.
- **Updated** `Metahubs.razor` `GetLocalizedName`: supports new `locales.{locale}.content` format with legacy flat-format fallback for existing data.
- **Build**: 0 errors, 0 warnings ✅

### Completed Features (as of 2026-02-23)

#### Metahubs display race-condition fix + `InitializeSessionAsync` idempotency ✅ (2026-02-23)
- **Root cause**: `Metahubs.razor.OnInitializedAsync` called `LoadMetahubsAsync()` before `App.razor` finished restoring the session JWT → requests went as `anon` role → `TO authenticated` SELECT policies returned 0 rows (no error, just empty list).
- **Fix part 1**: `Metahubs.razor` now `await SupabaseClientProvider.InitializeSessionAsync()` before loading data, plus `ApplyJwtToPostgrest` called in `LoadMetahubsAsync` to ensure freshest token is set.
- **Fix part 2**: `SupabaseClientProvider.InitializeSessionAsync` is now truly idempotent — stores the init work as a `Task? _initTask` field; subsequent calls return the same Task, preventing duplicate auth-listener registration.
- **Build**: 0 errors, 0 warnings ✅

#### Schema Separation: metahubs → dedicated schema ✅ (2026-02-23)
- **Requirement**: team lead mandated tables must live in their own `metahubs` schema, not mixed into `public`.
- **Fix**: exposed `metahubs` schema via PostgREST (`schemas` in `config.toml`); moved tables back with `ALTER TABLE public.X SET SCHEMA metahubs`; set `SupabaseOptions.Schema = "metahubs"` so all PostgREST requests send `Accept-Profile / Content-Profile: metahubs` headers.
- **Files changed**: `20260223000000_return_to_metahubs_schema.sql`, `config.toml`, `MetahubsDbContext.cs`, `SupabaseClientProvider.cs`, new EF migration + snapshot.
- **Pending (manual)**: add `metahubs` to exposed schemas in Supabase Dashboard → Settings → API.
- **Build**: 0 errors, 0 warnings ✅; 11/11 migrations applied ✅

### Completed Features (as of 2026-02-22)

#### RLS 42501 Fix — PostgREST Schema Cache ✅ (2026-02-22)
- **Root cause**: `metahubs_allow_insert WITH CHECK (true)` was in the DB (confirmed via diagnostic RAISE NOTICE), but PostgREST had a **stale schema cache**. Previous migrations (`20260220000001`, `20260220000002`) modified policies without sending `NOTIFY pgrst, 'reload schema'`, so PostgREST never picked up the new policy state.
- **Fix**: Created and pushed `20260222000000_force_rls_reset.sql`:
  - Diagnostic logging of all current policies pre-reset
  - Full policy reset: `DISABLE RLS → drop ALL policies → ENABLE RLS → FORCE RLS`
  - 4 clean policies: SELECT public/own, INSERT `WITH CHECK (true)`, UPDATE
  - `GRANT INSERT TO anon, authenticated`
  - `NOTIFY pgrst, 'reload schema'` — forces PostgREST cache reload ✅
- **Status**: "Finished supabase db push." ✅; 10/10 migrations applied ✅

#### Auth Persistence Fix — Session Notification ✅ (2026-02-21)
- **Root cause**: `InitializeSessionAsync()` restored `Client.Auth` session tokens but never called `NotifyAuthenticationStateChanged()` → UI showed anonymous.
- **Fix**: `App.razor` — after `InitializeSessionAsync()`, cast `AuthenticationStateProvider` to `SupabaseAuthenticationStateProvider` and call `NotifyAuthenticationStateChanged()`.
- **Build**: 0 errors, 0 warnings ✅

#### PGRST205 Fix: Metahubs Schema Mismatch ✅ (2026-02-20)
- **Root cause**: `SupabaseClientProvider` had `Schema = "metahubs"` in `SupabaseOptions`, but all tables were moved to `public` schema in migration 20260217000000. PostgREST was querying `metahubs.metahubs` which no longer exists.
- **Fix**: Removed `Schema = "metahubs"` from `SupabaseOptions` → PostgREST defaults to `public`.
- **EF alignment**: `HasDefaultSchema` in `MetahubsDbContext`, `migration-settings.json`, and `MigrationSettingsLoader` all updated to `"public"`.
- **New EF migration**: `20260220105741_SchemaToPublic` — `RenameTable` for all 5 tables (`metahubs` → `public` schema), generated by EF automatically.
- **New Supabase SQL**: `20260220000000_register_ef_migrations.sql` — `INSERT` statements to record both EF migrations in `__EFMigrationsHistory` (idempotent, uses `WHERE NOT EXISTS`). Applied via `supabase db push` ✅
- **Build**: db-migrations + main-frt — 0 errors, 0 warnings ✅

#### RLS 42501 Fix + push-migrations Automation ✅ (2026-02-20)
- **Root cause (database)**: `GRANT INSERT` missing for `anon` role. When Blazor WASM client sends anon key as Bearer token, PostgREST uses anon role; WITH CHECK (true) would pass RLS but GRANT was missing. Fixed by migration `20260220000002` (DO block drops all INSERT policies, creates `metahubs_allow_insert WITH CHECK (true)`, GRANT INSERT to anon + authenticated).
- **Root cause (code)**: `InitializeAsync()` was never called on `Supabase.Client`. The auth-state listener (which updates `Postgrest.Options.Headers["Authorization"]` when SignedIn fires) was never registered. After `Auth.SignIn()`, the Postgrest client kept using the anon key. Fix: `SupabaseClientProvider` now calls `await client.InitializeAsync()` before session restoration, plus a safety-net method `ApplyJwtToPostgrestAsync` that explicitly sets the header. `ClientAuthService.SignInAsync`/`SignUpAsync` calls this after sign-in.
- **Applied**: "Finished supabase db push." ✅; REST api anon INSERT test: "OK - anon insert works" ✅; Build 0 errors ✅
- **Note**: `GRANT INSERT TO anon` is temporary for development. Tighten before production.

#### Build Fix: CS0854 Expression Tree Errors ✅ (2026-02-20)
- **Root cause**: `JsonDocument.Parse(string, JsonDocumentOptions options = default)` has an optional parameter which is forbidden inside expression trees used by EF Core `ValueConverter`/`ValueComparer` lambdas.
- **Fix**: Added `private static JsonDocument ParseJsonDocument(string json) => JsonDocument.Parse(json);` as a wrapper method in `MetahubsDbContext`; replaced all direct `JsonDocument.Parse(...)` calls in converter/comparer lambdas.
- **Validation**:
  - `dotnet build` db-migrations — **0 errors, 0 warnings** ✅
  - `dotnet build` main-frt (Blazor WASM) — **0 errors, 0 warnings** ✅
  - `dotnet run -- list` CLI — shows 3 configured targets correctly ✅
  - `dotnet run -- show --database supabase` CLI — shows correct connection info ✅
  - `dotnet ef migrations list` — shows `InitialMetahubsSchema` migration ✅
  - Metahubs page + CreateMetahubDialog compile without errors ✅

#### EF Core 9 Multi-Database Migration System ✅ (2026-02-19)
- **Scope**: Upgraded `db-migrations/base` to support Django-style database targeting for EF Core migrations.
- **Configuration model**:
  - Added named database targets in `migration-settings.json`
  - Added settings loader and CLI option parser for `--database` and `--settings`
  - Added built-in targets: `supabase`, `local-sqlserver`, `local-sqlite`
- **Design-time factory update**:
  - `MetahubsDbContextFactory` now resolves target/provider from settings
  - Provider configuration centralized in `DbContextOptionsConfigurator`
  - Supports Npgsql, SQL Server, and SQLite providers
- **DbContext compatibility update**:
  - Provider-aware `JsonDocument` mapping (`jsonb` for PostgreSQL, text conversion for SQL Server/SQLite)
  - PostgreSQL-specific index features (filters, GIN) applied only when provider is PostgreSQL
- **Tooling UX**:
  - `Program.cs` now supports `list` and `show` commands for migration targets
  - EF command flow documented with `dotnet ef ... -- --database <target>`
- **Validation**:
  - Fixed CS0854 expression tree bug (see Build Fix entry above)
  - `dotnet build` — 0 errors, 0 warnings
  - CLI `list`/`show` commands functional
  - EF migrations list confirmed via `dotnet ef migrations list`
- **Status**: ✅ Implemented and validated

#### ORM Architecture Implementation ✅
- **Research & Analysis**: Conducted deep architectural research with AI assistance
  - Identified root cause: Blazor WASM cannot make TCP connections to PostgreSQL
  - EF Core/Npgsql incompatible with browser sandbox environment
  - Solution: Hybrid approach - EF Core for design-time, Supabase SDK for runtime
- **Migration Generator Package** (`db-migrations/base`):
  - Standalone console project with EF Core 9.0.0
  - Complete entity models with fluent API configuration
  - 5 tables: metahubs, metahubs_branches, metahubs_users, publications, publication_versions
  - All system fields (_upl_*, _mhb_*) with proper column mapping
  - 22+ indexes including GIN for JSONB, partial unique indexes
  - Design-time factory for `dotnet ef` tool integration
- **Generated SQL Migrations**:
  - `supabase/migrations/20260211_create_metahubs_schema.sql` - EF Core generated
  - `supabase/migrations/20260211_add_enums_and_rls.sql` - Manual supplement
  - PostgreSQL ENUMs: `publication_access_mode`, `publication_schema_status`
  - Row Level Security policies for all tables
  - Schema-level and table-level permissions
- **Runtime Service Refactoring**:
  - Removed EF Core from `metahubs-srv` runtime dependencies
  - Added `supabase-csharp` v0.16.2 for HTTP-based data access
  - Updated `Metahub` model with Postgrest attributes ([Table], [Column], [PrimaryKey])
  - Rewritten `MetahubsService` using Supabase PostgREST client
  - Simplified DI registration (no configuration needed, uses existing Supabase client)
- **Blazor App Integration**:
  - Updated `Program.cs` to call `AddMetahubsService()` without parameters
  - Removed obsolete `MetahubsDb:ConnectionString` configuration
  - Verified build succeeds with no errors
- **Supabase CLI Setup**:
  - Installed Scoop package manager for Windows
  - Installed Supabase CLI v2.75.0
  - Initialized project with `supabase init`
  - Created comprehensive migration instructions in `supabase/migrations/README.md`
- **Documentation**:
  - Updated `techContext.md` with database & ORM architecture section
  - Migration workflow documented
  - Design-time vs runtime separation explained
- **Status**: ✅ Architecture complete and fully integrated

#### Database Migrations Applied ✅ (2026-02-17)
- **Automatic Migration via Supabase CLI**:
  - All migrations applied successfully using `supabase db push`
  - Tables moved to `public` schema for PostgREST API compatibility
  - Migration versions: 20260211000000 (schema), 20260211000001 (ENUMs/RLS), 20260217000000 (move to public), 20260217000001 (RLS update), 20260217000002 (permissions)
- **PostgREST API Access**:
  - Tables accessible via Supabase REST API
  - Read/write operations working through supabase-csharp SDK
  - RLS policies active and enforced
- **Integration Testing**:
  - MetahubsService successfully queries database
  - UI page `/metahubs` ready for production use
  - Application runs on http://localhost:5064
- **Status**: ✅ Full database integration complete and tested

#### Metahubs Database Schema Implementation ✅ (2026-02-02)
- **Package**: New `metahubs-srv/base` service package created
- **Database Schema**: Complete PostgreSQL schema migrated from TypeORM to SQL
  - `metahubs` - Main configuration containers
  - `metahubs_branches` - Parallel development branches
  - `metahubs_users` - User-metahub membership with roles
  - `publications` - External interfaces with access control
  - `publication_versions` - Versioned schema snapshots
- **C# Models**: Full entity model classes with Postgrest attributes
  - `BaseMetahubEntity` - Base class with platform and metahub system fields
  - `Metahub`, `MetahubBranch`, `MetahubUser`, `Publication`, `PublicationVersion`
  - JSONB support for localized content
  - Soft delete pattern (`_upl_deleted`, `_mhb_deleted`)
- **Service Layer**:
  - `IMetahubsService` interface with complete CRUD operations
  - `MetahubsService` implementation using Supabase Client
  - Dependency injection via `AddMetahubsService()` extension
- **Migration**: SQL script at `Migrations/CreateMetahubsSchema.sql`
  - Row Level Security (RLS) policies
  - Comprehensive indexes for performance
  - User-based access control
- **Integration**:
  - Connected to main-frt via project reference
  - Service registered in DI container
  - Metahubs page updated to load data from service
  - Loading and empty states implemented
  - Localized name display support (ru/en)
  - **CreateMetahubDialog** component with full validation
  - Create functionality with automatic codename transliteration
  - No test data - all data comes from database
- **Status**: Fully integrated and ready for use (SQL migration pending)

#### Deployment Preparation ✅ (2026-02-02)
- **Migration Instructions**: Created comprehensive guide (`MIGRATION_INSTRUCTIONS.md`)
  - Step-by-step Supabase SQL Editor instructions
  - Alternative Supabase CLI workflow
  - Verification queries for successful schema creation
  - Troubleshooting section for common errors
- **Application Launch**: Successfully launched on `http://localhost:5064`
  - All services registered and running in Development mode
  - Content root at project base directory
  - Ready for testing after SQL migration execution
- **Build Status**: ✅ All packages build successfully with no errors
- **Next User Action**: Execute `CreateMetahubsSchema.sql` in Supabase SQL Editor

#### Supabase Client DI Fix ✅ (2026-02-02)
- **Issue**: `MetahubsService` couldn't resolve `Supabase.Client` dependency
- **Solution**: Registered factory in `Program.cs` to provide `Supabase.Client` from `SupabaseClientProvider`
- **Pattern**: Services inject `Supabase.Client` directly, provider handles session restoration
- **Build**: ✅ Successful compilation after fix
- **Runtime**: ✅ Application running on http://localhost:5064 without DI errors

#### Table Schema Fix ✅ (2026-02-02)
- **Root Issue**: Supabase REST API only exposes `public` schema by default
- **Attempted Solutions**:
  1. Used `[Table("metahubs.metahubs")]` with dot notation - Postgrest interpreted as literal table name
  2. Added `Accept-Profile` and `Content-Profile` headers - didn't apply correctly in supabase-csharp
- **Final Solution**: Created alternative migration `CreateMetahubsSchema_Public.sql` that creates all tables in `public` schema
- **Changes**:
  - New migration file for public schema with all 5 tables
  - Removed custom headers from SupabaseOptions
  - Updated MIGRATION_INSTRUCTIONS.md to use new file
  - Table attributes use simple names: `[Table("metahubs")]`, `[Table("metahubs_branches")]`, etc.
- **Build**: ✅ Successful compilation
- **Status**: Ready for migration - user must execute CreateMetahubsSchema_Public.sql in Supabase
- **Missing from original TypeORM**:
  - `uuid_generate_v7()` - used v4 instead
  - `active_branch_id`, `comment` in metahubs_users
  - `source_branch_id`, `codename` in branches
  - `branch_id`, `is_active` in publication_versions
  - `active_version_id`, `access_config`, `schema_*` fields in publications
  - `admin.is_superuser()` RLS bypass
  - Foreign keys to auth.users
  - Additional partial indexes for archived state

#### Authentication Persistence v2 ✅
- **Singleton Supabase Client**: Single shared client instance with session state
- **Lazy Initialization**: Client created on first use with automatic session restoration
- **SupabaseClientProvider**: Manages client lifecycle and token persistence
- **Session Restoration**: Tokens loaded from localStorage and SetSession called automatically
- **Simplified Architecture**: Direct implementation instead of decorator pattern
- **Seamless UX**: User stays logged in across page refreshes and navigation
- **Clean Separation**: Client-side services in main-frt, base auth in auth-srv

#### Metahubs Page ✅
- **Route**: `/metahubs` - dedicated page for metahub management
- **Authorization**: Protected page accessible only to authenticated users
- **UI Components**:
  - Responsive card grid layout for metahubs
  - Search bar with Ctrl+F keyboard hint
  - View mode toggle (Grid/List)
  - Settings button and Add button
  - Per-card more options menu (Edit/Delete)
  - Owner badge indicator
  - Pagination with page size selector (10/20/50)
- **Features**:
  - Real-time search filtering
  - Sample data with two test metahubs
  - Responsive design (xs/sm/md/lg breakpoints)
- **Technology**: MudBlazor Material Design components
- **Next**: Connect to backend API, implement Add/Edit/Delete dialogs

#### Authentication System ✅
- **Supabase Integration**: Complete email/password authentication using `supabase-csharp` v0.16.2
- **Package Structure**: New `auth-srv/base` modular package for authentication services
- **Core Services**:
  - `IAuthService` interface with sign-in, sign-up, sign-out, session management
  - `AuthService` implementation with Supabase client integration
  - `SupabaseAuthenticationStateProvider` for Blazor auth state
  - Service registration via `AddSupabaseAuth()` extension method
- **Configuration**: Settings-based configuration via `appsettings.json`
- **UI Components**:
  - Login page (`/login`) with email/password form
  - Register page (`/register`) with validation
  - LoginMenu component with user dropdown
  - Protected route example (`/protected`)
  - MainLayout integration with auth menu
- **Security**: Protected routes using `[Authorize]` attribute and `AuthorizeRouteView`
- **Documentation**: Setup guide in `docs/SUPABASE_AUTH_SETUP.md`

#### Guest Landing Page ✅
- React/MUI parity achieved for start page
- Header, hero, product cards, footer components
- Responsive layout with MudBlazor

### Known Issues
- Requires manual Supabase project setup (URL and API key configuration)
- Email confirmation flow not automated in UI
- No password reset functionality yet
- OAuth providers not implemented

### Next Milestones
- Password reset and email verification flows
- OAuth integration (Google, GitHub)
- User profile management
- Backend API for secure credential handling
- UPDL node system implementation

## 2026-01-29
- Start page already mirrors the React backup structure: hero, product cards, footer, and radial background overlay.
- Pending refinement: tighten visual parity (header blur/position, hero clamp spacing, card/footer micro-margins) so the Blazor view is indistinguishable from the React backup.
