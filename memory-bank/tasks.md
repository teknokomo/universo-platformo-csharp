# Tasks

## Metahub Dashboard Page (2026-02-27) ✅ COMPLETED

- [x] Create `metahubs-srv/Models/MetahubBranch.cs` — maps to `metahubs.metahubs_branches`; schema_name, branch_number, codename, Name/Description JSONB, system fields
- [x] Add `GetMetahubBranchesAsync(Guid metahubId)` to `IMetahubsService` and implement in `MetahubsService`
- [x] Create `main-frt/Pages/MetahubDashboard.razor` at route `/metahubs/{MetahubId:guid}`:
  - Metahub-specific sidebar with back-link and section nav
  - Breadcrumbs, header with name/description/codename
  - Branch info banner (schema_name, codename)
  - 6 section cards: Объекты, Элементы, Макеты, Виджеты, Перечисления, Настройки
  - Branches table
- [x] Update `main-frt/Pages/Metahubs.razor` — cards clickable (added `OpenMetahub(Guid)`), table name cell clickable, inject `NavigationManager`
- [x] Build: 0 errors, 0 warnings ✅



- [x] Create `supabase/migrations/20260227000000_provision_metahub_schema_function.sql` — SECURITY DEFINER function `metahubs.provision_metahub_schema(p_metahub_id uuid, p_user_id uuid)`:
  - Derives schema name `mhb_<uuid_no_dashes>_b1`
  - `CREATE SCHEMA IF NOT EXISTS <schema_name>`
  - Creates 8 standard tables: `_mhb_objects`, `_mhb_attributes`, `_mhb_enum_values`, `_mhb_elements`, `_mhb_layouts`, `_mhb_widgets`, `_mhb_settings`, `_mhb_migrations`
  - Inserts default branch record into `metahubs.metahubs_branches`
  - Updates `metahubs.metahubs.default_branch_id`
  - GRANT EXECUTE to `authenticated`, `service_role`
- [x] Add `ProvisionMetahubSchemaAsync(Guid, Guid?)` private method to `MetahubsService.cs` — calls `_supabaseClient.Rpc("provision_metahub_schema", params)`
- [x] Update `MetahubsService.CreateMetahubAsync` — call `ProvisionMetahubSchemaAsync` after metahubs_users record is created (failure is non-fatal: logged, metahub row kept)
- [x] Build: metahubs-srv 0 errors, main-frt 0 errors ✅
- [ ] **MANUAL**: Apply migration `supabase db push --yes` to provision the SQL function in Supabase



- [x] Create `metahubs-srv/Models/LocalizedContentLocale.cs` — per-locale entry: content, version, isActive, createdAt, updatedAt
- [x] Create `metahubs-srv/Models/LocalizedContent.cs` — full JSONB structure: `_schema`, `locales{}`, `_primary`; factory/mutation/read/serialization helpers
- [x] Create `main-frt/Components/LocalizedContentField.razor` — reusable Blazor tab component; supports any bound `string?` JSON field; language tabs (RU/EN) + add-locale button
- [x] Refactor `CreateMetahubDialog.razor` — remove separate nameRu/nameEn/descriptionRu/descriptionEn fields; use `<LocalizedContentField>` for Name + Description
- [x] Update `Metahubs.razor` `GetLocalizedName` — support new `locales.{locale}.content` format with legacy flat-format fallback
- [x] Build: 0 errors, 0 warnings ✅



- [x] Diagnose "Unexpected character encountered while parsing value: {" — PostgREST returns jsonb columns as JSON objects, Newtonsoft expected a string token
- [x] Create `Converters/JsonRawStringConverter.cs` — reads JSON object/array tokens as raw string; writes raw JSON string back as a real JSON token for INSERT
- [x] Apply `[JsonConverter(typeof(JsonRawStringConverter))]` to `Name` and `Description` columns in `Metahub.cs`
- [x] Build: 0 errors, 0 warnings ✅



- [x] Diagnose empty metahubs list: JWT race between `App.razor` and `Metahubs.razor.OnInitializedAsync`
- [x] `Metahubs.razor`: inject `SupabaseClientProvider`; await `InitializeSessionAsync()` before `LoadMetahubsAsync()`
- [x] `Metahubs.razor` `LoadMetahubsAsync`: call `ApplyJwtToPostgrest(GetCurrentAccessToken())` before service call
- [x] `SupabaseClientProvider.cs`: make `InitializeSessionAsync` idempotent — store `_initTask` and return same `Task` on repeated calls (prevents duplicate auth-listener registration)
- [x] Build: 0 errors, 0 warnings ✅

## Schema Separation: metahubs → dedicated schema (2026-02-23) ✅ COMPLETED

- [x] Create `supabase/migrations/20260223000000_return_to_metahubs_schema.sql`: move tables public→metahubs, drop stale policies, recreate correct RLS, grant `USAGE ON SCHEMA metahubs`
- [x] Update `supabase/config.toml`: add `metahubs` to exposed `schemas` list
- [x] Update `MetahubsDbContext.cs`: `HasDefaultSchema("metahubs")`
- [x] Create EF migration `20260223120000_SchemaBackToMetahubs.cs` + Designer file
- [x] Update `MetahubsDbContextModelSnapshot.cs`: schema → metahubs
- [x] Update `SupabaseClientProvider.cs`: `Schema = "metahubs"` in `SupabaseOptions`
- [x] Apply migration via `supabase db push --yes` ✅
- [x] Verify build: 0 errors, 0 warnings ✅
- [ ] **MANUAL**: Add `metahubs` to exposed schemas in Supabase Dashboard → Settings → API

## RLS 42501 — Code: JWT Forwarding Fix (2026-02-22) ✅ COMPLETED

- [x] **Root cause confirmed**: anon INSERT via REST API works → DB policies are correct; issue is JWT not reaching Postgrest in the Blazor app
- [x] **Bug 1** (`SupabaseClientProvider.InitializeSessionAsync`): `ApplyJwtToPostgrest(accessToken)` was called with the OLD token from localStorage — if `SetSession` internally refreshed the token, the stale token was set in Postgrest headers. **Fix**: Read `CurrentSession.AccessToken ?? accessToken` after `SetSession` and use that as the token to forward.
- [x] **Bug 2** (`MetahubsService.RefreshPostgrestAuth`): When `CurrentSession == null` (session not restored), nothing was set — Postgrest used the raw `sb_publishable_*` anon key Bearer (not a valid JWT). **Fix**: Accept optional `Func<string>? getAccessToken` in constructor; fall back to delegate when `CurrentSession` is null.
- [x] **DI wiring** (`Program.cs`): Register `Func<string>` delegate → `SupabaseClientProvider.GetCurrentAccessToken` so `MetahubsService` can get the best available token without cross-package dependency.
- [x] **New method** (`SupabaseClientProvider.GetCurrentAccessToken()`): Returns `CurrentSession.AccessToken` if signed in, else falls back to `_anonKey`.
- [x] **Build**: main-frt → 0 errors, 0 warnings ✅

## RLS 42501 Fix — PostgREST Schema Cache (2026-02-22) ✅ COMPLETED

- [x] Diagnose 42501 error on `/metahubs` INSERT: confirmed all 10 migrations applied via `supabase migration list --linked`
- [x] Diagnostic run revealed: `metahubs_allow_insert | roles: {public} | check: true` existed but PostgREST schema cache was stale
- [x] Root cause: PostgREST cached old policy state; `NOTIFY pgrst, 'reload schema'` was missing from previous fix migrations
- [x] Created `supabase/migrations/20260222000000_force_rls_reset.sql`:
  - DO-block diagnostic logs current policies via RAISE NOTICE
  - `DISABLE ROW LEVEL SECURITY` → drop ALL policies → `ENABLE ROW LEVEL SECURITY`
  - `FORCE ROW LEVEL SECURITY` to bypass table-owner exemption
  - Recreate 4 clean policies (SELECT public, SELECT own, INSERT WITH CHECK(true), UPDATE)
  - `GRANT INSERT TO anon, authenticated`
  - `NOTIFY pgrst, 'reload schema'` — forces PostgREST cache reload
- [x] Pushed migration: `supabase db push` — "Finished supabase db push." ✅

## Auth Persistence Fix (2026-02-21) ✅ COMPLETED

- [x] Diagnose broken auth persistence after `SupabaseClientProvider` rewrite
  - Root cause: `InitializeSessionAsync()` in App.razor restored the Supabase session (`Client.Auth.SetSession`) but never notified `SupabaseAuthenticationStateProvider` → `CascadingAuthenticationState` showed anonymous
- [x] Fix `App.razor` — inject `AuthenticationStateProvider`; after `InitializeSessionAsync()` cast to `SupabaseAuthenticationStateProvider` and call `NotifyAuthenticationStateChanged()` ✅
- [x] Build: main-frt 0 errors, 0 warnings ✅

## RLS 42501 Fix + push-migrations Automation (2026-02-20) ✅ COMPLETED

- [x] Create `supabase/migrations/20260220000001_fix_insert_rls.sql` — drops all stale INSERT policies; recreates `metahubs_insert_policy WITH CHECK (true)`
- [x] Create `supabase/migrations/20260220000000_register_ef_migrations.sql` — idempotent INSERT into `__EFMigrationsHistory` for both EF migrations
- [x] Link Supabase project: `supabase link --project-ref pleeyslewsialvplxdpg` ✅
- [x] Apply migrations: `supabase db push` (linked project, Management API/HTTPS) — "Finished supabase db push." ✅
- [x] Fix `MetahubsService.CreateMetahubAsync` — set `_upl_created_by` / `_upl_updated_by` from authenticated user
- [x] Fix `push-migrations` command in `Program.cs` — remove `--db-url` (IPv6 blocked); use linked project + stdin `"y"` auto-confirm
- [x] Update `RunProcess` to accept optional `stdinText` parameter for interactive prompts
- [x] **42501 persisted** — diagnosed root cause: anon role had no INSERT GRANT; fixed via migration `20260220000002_rls_allow_insert.sql`
- [x] Create `supabase/migrations/20260220000002_rls_allow_insert.sql` — DO block drops ALL INSERT policies; creates `metahubs_allow_insert WITH CHECK (true)` + `GRANT INSERT TO anon, authenticated`; applied ✅
- [x] Direct REST test: anon INSERT with correct column names → "OK - anon insert works" ✅
- [x] **42501 persisted** (2nd investigation) — root cause: `InitializeAsync()` never called → JWT never forwarded to Postgrest after sign-in
- [x] **42501 persisted (3rd investigation)** — root cause: `Lazy<Task<Client>>` in `SupabaseClientProvider` + `GetAwaiter().GetResult()` in DI caused deadlock/incomplete init in Blazor WASM; `InitializeAsync` (which wires auth→Postgrest JWT listener) never completed; Postgrest always used anon key
- [x] Rewrite `SupabaseClientProvider` — create `Supabase.Client` synchronously in constructor; `InitializeSessionAsync()` separated as async method called from App.razor; `ApplyJwtToPostgrest(token)` sets header synchronously; `Client` property exposes instance directly
- [x] Update `Program.cs` — `AddScoped<Supabase.Client>` now returns `provider.Client` synchronously (no GetAwaiter().GetResult())
- [x] Update `App.razor` — inject `SupabaseClientProvider`; `OnInitializedAsync` calls `InitializeSessionAsync()` (runs on Blazor render thread, JS-interop works correctly)
- [x] Update `MetahubsService` — add `RefreshPostgrestAuth()` that reads `Auth.CurrentSession?.AccessToken` and sets `Postgrest.Options.Headers["Authorization"]`; called at start of every public method
- [x] Build: main-frt + metahubs-srv 0 errors, 0 warnings ✅

## PGRST205 Fix: Metahubs Schema Mismatch (2026-02-20) ✅ COMPLETED

- [x] Fix `SupabaseClientProvider.cs` — remove `Schema = "metahubs"` from `SupabaseOptions`
- [x] Fix `MetahubsDbContext.cs` — `HasDefaultSchema("metahubs")` → `HasDefaultSchema("public")`
- [x] Fix `migration-settings.json` — supabase target schemas: `metahubs` → `public`
- [x] Fix `MigrationSettingsLoader.cs` — fallback schema defaults: `metahubs` → `public`
- [x] Generate EF migration `20260220105741_SchemaToPublic` (RenameTable for 5 tables)
- [x] Add `RestApiUrl` + `ServiceRoleKey` fields to `MigrationDatabaseTarget`
- [x] Implement `register-migrations` command in `Program.cs` — applies EF migration history via Supabase REST API (HTTPS/IPv4) when direct TCP is blocked
- [x] Update `migration-settings.json` with `restApiUrl` field for supabase target
- [x] `serviceRoleKey` added to `migration-settings.json`; EF history registered via SQL migration `20260220000000_register_ef_migrations.sql`

## EF Core 9 Multi-Database Migration System (2026-02-19) ✅ COMPLETED

### Phase 1: Architecture & Configuration
- [x] Define multi-database migration architecture (Django-style database targeting)
- [x] Add configurable database targets/providers for migration generation

### Phase 2: Implementation
- [x] Implement provider-aware design-time DbContext factory (EF Core 9)
- [x] Implement CLI workflow for listing targets and selecting database/provider
- [x] Keep existing PostgreSQL/Supabase workflow backward-compatible

### Phase 3: Validation & Docs
- [x] Build and validate db-migrations package (fixed CS0854 expression tree errors; build 0 warnings / 0 errors)
- [x] Update db-migrations README with multi-database usage examples
- [x] Update memory bank core files with implemented approach and status

## Build Fix: CS0854 Expression Tree Errors (2026-02-20) ✅ COMPLETED
- [x] Identify CS0854 errors — `JsonDocument.Parse()` has optional `JsonDocumentOptions` param, forbidden in expression trees
- [x] Add `ParseJsonDocument(string json)` wrapper static method in `MetahubsDbContext`
- [x] Replace all `JsonDocument.Parse(...)` calls inside `ValueConverter`/`ValueComparer` lambdas
- [x] Rebuild db-migrations — 0 errors, 0 warnings
- [x] Rebuild main-frt (Blazor WASM frontend) — 0 errors, 0 warnings
- [x] Validate CLI: `dotnet run -- list` shows 3 targets, `dotnet run -- show --database supabase` shows correct config
- [x] Verify EF Core migrations: `dotnet ef migrations list` shows `InitialMetahubsSchema`
- [x] Verify Metahubs page and CreateMetahubDialog component exist and compile correctly

## Supabase Authentication Implementation (2026-01-30) ✅ COMPLETED

### Phase 1: Infrastructure Setup ✅
- [x] Create auth-srv backend package structure
- [x] Install supabase-csharp NuGet package
- [x] Create configuration structure for Supabase credentials
- [x] Setup dependency injection for Supabase client

### Phase 2: Core Authentication Service ✅
- [x] Create IAuthService interface
- [x] Implement AuthService with sign-in, sign-up, sign-out methods
- [x] Create AuthState service for managing authentication state
- [x] Add JWT token handling and storage

### Phase 3: Frontend Integration ✅
- [x] Create authentication components (Login, Register forms)
- [x] Add authentication state management in Blazor
- [x] Integrate auth service into main-frt Program.cs
- [x] Create protected route handling

### Phase 4: UI Components ✅
- [x] Create Login page/dialog with MudBlazor
- [x] Create Register page/dialog with MudBlazor
- [x] Update MainLayout to show login/logout menu
- [x] Add user profile dropdown in header

### Phase 5: Testing & Documentation ✅
- [x] Update memory bank files (activeContext, systemPatterns, progress, techContext)

## Metahubs Page Implementation (2026-02-02) ✅ COMPLETED

### Phase 1: Page Creation and Layout ✅
- [x] Create Metahubs.razor page with routing (/metahubs)
- [x] Add authorization requirement
- [x] Implement page header with title and search
- [x] Add view toggle buttons (grid/list) and settings button
- [x] Create "+ Add" button

### Phase 2: Content Display ✅
- [x] Create metahub card components
- [x] Implement grid layout for cards
- [x] Add owner badge to cards
- [x] Display metahub name and description

### Phase 3: Pagination ✅
- [x] Add pagination component at bottom
- [x] Implement page size selector
- [x] Display current page info

## Metahubs Database Schema Implementation (2026-02-11) ✅ COMPLETED

### Overview
Implemented proper ORM architecture for Blazor WASM + Supabase based on research findings:
- EF Core as design-time migration generator (runs outside browser)
- Supabase CLI for applying migrations
- supabase-csharp SDK for runtime data access in Blazor WASM

### Phase 1: Migration Generator Project Setup ✅
- [x] Create separate console project `src/packages/db-migrations/base/DbMigrationGenerator.csproj`
- [x] Move EF Core entities from metahubs-srv to migration generator project
- [x] Configure EF Core with Npgsql in migration generator
- [x] Add connection string configuration for local migration generation

### Phase 2: Generate SQL Migration ✅
- [x] Run `dotnet ef migrations add InitialMetahubsSchema` in migration generator project
- [x] Export SQL script: `dotnet ef migrations script --output ../../supabase/migrations/20260211_create_metahubs_schema.sql`
- [x] Review and adjust generated SQL (add RLS policies, verify JSONB, ENUMs, indexes)
- [x] Create supplementary migration `20260211_add_enums_and_rls.sql` with:
  - PostgreSQL ENUM types (publication_access_mode, publication_schema_status)
  - ALTER TABLE statements to convert TEXT columns to ENUMs
  - Row Level Security enabled on all tables
  - RLS policies for user-based access control
  - GRANT permissions for authenticated users

### Phase 3: Supabase CLI Setup ✅
- [x] Install Scoop package manager for Windows
- [x] Install Supabase CLI v2.75.0 via Scoop
- [x] Initialize Supabase project: `supabase init`
- [x] Create comprehensive migration instructions in `supabase/migrations/README.md`
- Note: CLI login skipped - migrations will be applied manually via Supabase Studio

### Phase 4: Apply Migration via Supabase ⏳ USER ACTION REQUIRED
- [ ] User must execute `20260211_create_metahubs_schema.sql` in Supabase Studio SQL Editor
- [ ] User must execute `20260211_add_enums_and_rls.sql` in Supabase Studio SQL Editor
- [ ] User must verify schema creation (5 tables, 2 ENUMs, RLS enabled)
- Instructions provided in: `supabase/migrations/README.md`

### Phase 5: Refactor Runtime Service (supabase-csharp SDK) ✅
- [x] Remove EF Core packages from metahubs-srv (keep only models)
- [x] Add supabase-community/postgrest-csharp (via supabase-csharp) to metahubs-srv
- [x] Update Metahub model with Postgrest attributes ([Table], [Column], [PrimaryKey])
- [x] Add all system fields to Metahub model (BaseMod extend with full _upl_* and _mhb_* fields)
- [x] Refactor MetahubsService to use Supabase client instead of DbContext
- [x] Implement CRUD operations using PostgREST query builder
- [x] Handle JSONB fields (Name, Description) with JsonDocument

### Phase 6: Update Blazor App Integration ✅
- [x] Update Program.cs to call AddMetahubsService() without configuration parameter
- [x] Remove EF Core DbContext registration (not needed)
- [x] Remove MetahubsDb:ConnectionString from appsettings.json
- [x] Verify build succeeds with no errors
- [x] Metahubs page ready to work with real Supabase data (after migration)

### Phase 7: Documentation & Memory Bank Update ✅
- [x] Create migration instructions in supabase/migrations/README.md
- [x] Create design-time project documentation in db-migrations/base/README.md
- [x] Update techContext.md with Database & ORM Architecture section
- [x] Update systemPatterns.md with migration + runtime pattern (if applicable)
- [x] Update progress.md with ORM Architecture Implementation entry
- [x] Update activeContext.md with completion status and next user steps
- [x] Update tasks.md with completion markers

## Database Integration & Migration Execution (2026-02-17) ✅ COMPLETED

### Migration Application via Supabase CLI ✅
- [x] Resolve migration version conflicts (renamed files with unique timestamps)
- [x] Apply schema migration (20260211000000_create_metahubs_schema.sql)
- [x] Apply ENUMs and RLS migration (20260211000001_add_enums_and_rls.sql)
- [x] Move tables to public schema for API access (20260217000000_move_to_public_schema.sql)
- [x] Update RLS policies for public schema (20260217000001_update_rls_policies.sql)
- [x] Grant permissions to anon/authenticated roles (20260217000002_grant_permissions.sql)
- [x] All migrations applied successfully using `supabase db push`

### Integration Testing ✅
- [x] Verify table accessibility via PostgREST API
- [x] Test read operations through Supabase SDK
- [x] Update Metahub model to use public schema ([Table("metahubs")])
- [x] Build and run application successfully
- [x] Application accessible on http://localhost:5064
- [x] Metahubs page connected to live database

### Documentation Updates ✅
- [x] Update progress.md with migration completion status
- [x] Update activeContext.md with integration success
- [x] Update tasks.md with migration execution details

## Authentication Persistence Fix v2 (2026-02-02) ✅ COMPLETED

### Session Restoration Architecture ✅
- [x] Create SupabaseClientProvider with singleton pattern
- [x] Implement lazy initialization with session restoration
- [x] Refactor ClientAuthService to use shared client
- [x] Update Program.cs DI registration
- [x] Remove decorator pattern in favor of direct implementation
- [x] Test session persistence across page refreshes
- [x] Document usage in README and setup guide
- [x] Implementation complete and ready for testing with Supabase project

## Future Enhancements

### Authentication Extensions
- [ ] Add password reset functionality
- [ ] Implement email verification flow UI
- [ ] Add OAuth providers (Google, GitHub)
- [ ] Create user profile page
- [ ] Add avatar upload

### Security Improvements
- [ ] Move credentials to environment variables
- [ ] Implement server-side API proxy for secure auth
- [ ] Add rate limiting
- [ ] Implement refresh token rotation

## Landing page parity (guest)
- [x] Extract exact layout specs from .backup/start-frontend (AppAppBar, Hero, Testimonials, StartFooter).
	- Notes: Captured AppAppBar blur/rounded toolbar with fixed position, Hero clamp paddings and typography, Testimonials outlined cards with 12/6/3 grid, StartFooter spacing/hover cues.
- [ ] Update StartHeader to fixed blurred toolbar with container spacing matching AppAppBar and hook up login/language handlers.
- [ ] Match Hero padding/width/typography and CTA shadow to React values; ensure gradient overlay and dark variant match.
- [ ] Align ProductCards grid spacing and typography to React testimonials layout.
- [ ] Align StartFooter spacing, hover cues, and icon styling to React guest variant.
- [ ] Run dotnet run --project src\packages\main-frt\base to validate build.
