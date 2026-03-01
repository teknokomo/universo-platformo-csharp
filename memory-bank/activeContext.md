# Active Context

## Current Focus: Metahub Dashboard Page (2026-02-27) ✅ COMPLETED

### Changes made this session (2026-02-27, 2nd pass)

| File | Change |
|---|---|
| `metahubs-srv/Models/MetahubBranch.cs` | New: MetahubBranch model mapping to `metahubs.metahubs_branches` |
| `metahubs-srv/Interfaces/IMetahubsService.cs` | Added `GetMetahubBranchesAsync(Guid metahubId)` |
| `metahubs-srv/Services/MetahubsService.cs` | Implemented `GetMetahubBranchesAsync` |
| `main-frt/Pages/MetahubDashboard.razor` | New: `/metahubs/{id}` page — sidebar, branch banner, 6 section cards, branches table |
| `main-frt/Pages/Metahubs.razor` | Cards/rows clickable → `OpenMetahub(id)`; inject `NavigationManager` |

**Build**: 0 errors, 0 warnings ✅

### Dashboard structure (`/metahubs/{MetahubId}`)
- Sidebar: back link + metahub nav (Dashboard, Объекты, Элементы, Макеты, Виджеты, Настройки)
- Breadcrumbs: Метахабы → [metahub name]; metahub header with codename + public badge
- Branch info banner: schema_name in monospace, branch codename
- 6 section cards: Объекты, Элементы, Макеты, Виджеты, Перечисления, Настройки
- Branches table (when multiple branches exist)

## Previous Focus: Per-Metahub Schema Provisioning (2026-02-27) ✅ COMPLETED

### Changes made this session (2026-02-27)

| File | Change |
|---|---|
| `supabase/migrations/20260227000000_provision_metahub_schema_function.sql` | New: SECURITY DEFINER function `metahubs.provision_metahub_schema(uuid, uuid)` |
| `supabase/migrations/20260227000001_move_provision_fn_to_public_and_backfill.sql` | Function in `public`, wrapper in `metahubs`, 11 metahubs backfilled |
| `metahubs-srv/Services/MetahubsService.cs` | Added `ProvisionMetahubSchemaAsync` called from `CreateMetahubAsync` |

**Migrations applied** via `supabase db push --yes` ✅ — 11 schemas created

---

## Previous Focus: LocalizedContent JSONB Module (2026-02-24) ✅ COMPLETED

### Changes made this session (2026-02-24)

| File | Change |
|---|---|
| `metahubs-srv/Models/LocalizedContentLocale.cs` | New: per-locale entry with `content`, `version`, `isActive`, `createdAt`, `updatedAt` |
| `metahubs-srv/Models/LocalizedContent.cs` | New: full JSONB module — `_schema`, `locales{}`, `_primary`; factory/mutation/read/serialization API |
| `main-frt/Components/LocalizedContentField.razor` | New: reusable MudBlazor tab component for any `@bind-Value` string JSONB field; language tabs (RU/EN) + add-locale button |
| `main-frt/Components/CreateMetahubDialog.razor` | Refactored: replaced 4 separate RU/EN fields with 2 `<LocalizedContentField>` components; codename auto-gen reads primary locale from JSON |
| `main-frt/Pages/Metahubs.razor` | Updated `GetLocalizedName`: new format (`locales.{locale}.content`) + legacy flat fallback |

**Build**: metahubs-srv → 0 errors, main-frt → 0 errors ✅


```json
{
  "_schema": "1",
  "locales": {
    "ru": { "content": "Список покупок", "version": 1, "isActive": true, "createdAt": "...", "updatedAt": "..." },
    "en": { "content": "Shopping list",  "version": 1, "isActive": true, "createdAt": "...", "updatedAt": "..." }
  },
  "_primary": "ru"
}
```

### How to use LocalizedContentField in any form
```razor
<LocalizedContentField Label="Название"
                       @bind-Value="someJsonString"
                       Required="true"
                       Multiline="false"
                       DefaultPrimaryLocale="ru" />
```
`someJsonString` is a `string?` that gets serialized/deserialized automatically.

---

## Previous Focus: Metahubs display + InitializeSessionAsync idempotency (2026-02-23) ✅ COMPLETED

### Changes made (2026-02-23, 2nd pass)

| File | Change |
|---|---|
| `Metahubs.razor` | Inject `SupabaseClientProvider`; `OnInitializedAsync` awaits `InitializeSessionAsync()` before `LoadMetahubsAsync()` |
| `Metahubs.razor` `LoadMetahubsAsync` | Calls `ApplyJwtToPostgrest(GetCurrentAccessToken())` before service call |
| `SupabaseClientProvider.cs` | `InitializeSessionAsync` is now idempotent: stores `_initTask` field; repeated calls return the same `Task<T>` |



### ✅ Completed This Session (2026-02-23)

#### Architectural requirement: tables must live in `metahubs` schema, not `public`
- **Root issue**: tables had been moved to `public` for PostgREST compatibility, but team lead requires schema separation.
- **Solution**: expose `metahubs` schema via PostgREST in addition to `public`.

#### Changes made
| File | Change |
|---|---|
| `supabase/migrations/20260223000000_return_to_metahubs_schema.sql` | Move all 5 tables public→metahubs, drop stale policies, recreate correct RLS, grant schema access |
| `supabase/config.toml` | Added `metahubs` to `schemas` list |
| `MetahubsDbContext.cs` | `HasDefaultSchema("metahubs")` |
| `20260223120000_SchemaBackToMetahubs.cs` + `.Designer.cs` | New EF migration |
| `MetahubsDbContextModelSnapshot.cs` | Updated to `metahubs` schema |
| `SupabaseClientProvider.cs` | Added `Schema = "metahubs"` to `SupabaseOptions` |

#### ⚠️ Manual step required (one-time, Supabase Dashboard)
Go to **Dashboard → Settings → API → Exposed schemas** and add `metahubs`.
Without this PostgREST will ignore `Accept-Profile: metahubs` headers and fall back to `public`.

#### Migration applied
- `supabase db push --yes` → `20260223000000_return_to_metahubs_schema.sql` applied ✅
- Build: 0 errors, 0 warnings ✅

### Immediate Next Steps
1. **Manual**: Add `metahubs` to exposed schemas in Supabase Dashboard → Settings → API.
2. Hard-refresh browser (`Ctrl+Shift+R`) to pick up updated Blazor WASM build.
3. Test: navigate to `/metahubs`, create a metahub — should work.

---

## Previous: JWT Forwarding Code Fix (2026-02-22)

### ✅ Completed This Session (2026-02-22, 2nd pass)

#### Root Cause Confirmed via REST API Diagnostic
- PowerShell `Invoke-RestMethod` confirmed anon INSERT via REST API **returns HTTP 204 (OK)** — DB policies are correct after migration `20260222000000`.
- The 42501 error source is **code-side**: JWT is not properly reaching the Postgrest sub-client.

#### Code Fix 1: `SupabaseClientProvider.InitializeSessionAsync`
- **Bug**: `ApplyJwtToPostgrest(accessToken)` called with OLD token from localStorage — if `SetSession` internally refreshes the JWT, the stale token was being forwarded to Postgrest.
- **Fix**: After `SetSession`, read `CurrentSession.AccessToken ?? accessToken` for the actual current (possibly refreshed) token.

#### Code Fix 2: `MetahubsService.RefreshPostgrestAuth` + DI
- **Bug**: When `CurrentSession == null` (session restoration failed / token expired), nothing was set in Postgrest headers — the raw `sb_publishable_*` key was used as Bearer, which PostgREST can't decode as a valid JWT role-mapping.
- **Fix 1**: Added `GetCurrentAccessToken()` method to `SupabaseClientProvider` returning `CurrentSession.AccessToken ?? _anonKey`.
- **Fix 2**: Registered `Func<string>` delegate in `Program.cs` → `SupabaseClientProvider.GetCurrentAccessToken` (no cross-package dependency).
- **Fix 3**: `MetahubsService(Client, Func<string>?)` constructor accepts optional delegate; `RefreshPostgrestAuth()` uses it as fallback.
- **Build**: 0 errors, 0 warnings ✅

### Immediate Next Steps
1. **Hard-refresh** browser (Ctrl+Shift+R) to pick up the new Blazor WASM build.
2. Test: navigate to `/metahubs`, click "Добавить", create a metahub — should work.
3. After verification: tighten INSERT policy to `WITH CHECK (auth.uid() IS NOT NULL)` and `TO authenticated` only.

### ✅ Previous: RLS 42501 Fix — PostgREST Schema Cache (2026-02-22, 1st pass)
- Migration `20260222000000_force_rls_reset.sql`: full policy reset + `NOTIFY pgrst, 'reload schema'`. Applied ✅
- REST API diagnostic confirmed anon INSERT works at DB level.

### ✅ Previous Session (2026-02-21)

#### Auth Persistence Fix — `App.razor`
- **Root cause**: `InitializeSessionAsync()` restored session but never called `NotifyAuthenticationStateChanged()`.
- **Fix**: Injected `AuthenticationStateProvider` into `App.razor`; after init, cast to `SupabaseAuthenticationStateProvider` and notify.




### ✅ Completed This Session (2026-02-21)

#### Auth Persistence Fix — `App.razor`
- **Root cause**: `InitializeSessionAsync()` restored `Client.Auth` session (tokens from localStorage via `SetSession`) but never called `NotifyAuthenticationStateChanged()` on `SupabaseAuthenticationStateProvider` → `CascadingAuthenticationState` reported anonymous user.
- **Fix**: Injected `AuthenticationStateProvider` into `App.razor`; after `InitializeSessionAsync()` completes, cast to `SupabaseAuthenticationStateProvider` and call `NotifyAuthenticationStateChanged()`.
- Build: **0 errors, 0 warnings** ✅

#### SupabaseClientProvider Architecture (completed 2026-02-20, still current)
- Client created **synchronously** in constructor (no `Lazy<Task<Client>>`).
- `InitializeSessionAsync()` called from `App.razor OnInitializedAsync` (Blazor render thread — JS-interop safe).
- `ApplyJwtToPostgrest(token)` synchronously sets `Postgrest.Options.Headers["Authorization"]`.
- `MetahubsService.RefreshPostgrestAuth()` also sets JWT before every Postgrest call.

#### Database State (2026-02-20, applied)
- RLS policy `metahubs_allow_insert WITH CHECK (true)` + `GRANT INSERT TO anon, authenticated` applied via migration 20260220000002.
- All tables live in `public` schema (PGRST205 fix, schema moved via migration 20260217).

### Immediate Next Steps
1. **Test** the full flow: start app, confirm session is remembered after page refresh (auth persistence), log in, create a Metahub.
2. After verification: optionally tighten RLS policies (`WITH CHECK (auth.uid() IS NOT NULL)`, `GRANT INSERT TO authenticated` only).
3. Continue other feature work (see tasks.md).

  - Pagination (10/20/50 items per page)
  - Owner badge on cards
  - Settings and Add buttons
  - More options menu per card (Edit/Delete)
- **Sample Data**: Two test metahubs included for demonstration

### Next Steps
- Connect to backend API for real metahub data
- Implement Add metahub dialog
- Add Edit and Delete functionality
- Implement list view layout
- Add sorting and filtering options
- Consider adding metahub categories or tags

### Previous: Supabase Authentication Implementation (2026-01-30)
- Implemented complete Supabase authentication system using `supabase-csharp` package
