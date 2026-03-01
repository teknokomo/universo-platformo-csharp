# System Patterns

## Architecture Patterns

### Modular Package Structure
- **Mandatory pattern**: All features MUST be in `src/packages/` directory
- Each feature split into `-frt` (frontend) and `-srv` (backend) packages
- Each package has `base/` subdirectory for primary implementation
- Example: `auth-srv/base/` for authentication service

### Dependency Injection Pattern
- Services registered via extension methods (e.g., `AddSupabaseAuth()`)
- Configuration via Options pattern with `IOptions<T>`
- Scoped services for per-request/session state
- Singleton for shared resources

### EF Core Multi-Database Migration Target Pattern
- **Rule**: Design-time migrations must use named targets and provider selection via `--database <target>`.
- **Configuration source**: `src/packages/db-migrations/base/migration-settings.json`.
- **Factory contract**: `MetahubsDbContextFactory` loads settings and resolves target from CLI args.
- **Supported providers**: PostgreSQL, SQL Server, SQLite.
- **Provider adaptation**:
  - PostgreSQL keeps `jsonb`, filtered indexes, and GIN indexes.
  - SQL Server/SQLite use text-backed JSON conversion for `JsonDocument` fields.
  - PostgreSQL-only filters/methods are not applied to non-PostgreSQL providers.
- **Operational commands**:
  - `dotnet ef migrations add <Name> -- --database <target>`
  - `dotnet ef database update -- --database <target>`
  - `dotnet ef migrations script --output <path.sql> -- --database <target>`
- **Why**: Provides Django-like migration ergonomics while preserving browser-compatible runtime architecture.

## Authentication Pattern (Supabase)

### Session Persistence with Singleton Client
- **Pattern**: Singleton Supabase client with lazy initialization and session restoration
- **Implementation**: `SupabaseClientProvider` provides shared client instance
- **Storage**: Browser localStorage via `LocalStorageService` (JSInterop)
- **Location**: Client services in `main-frt/Services/`
- **Why**: Single Supabase client maintains session state across component lifecycles
- **Flow**:
  1. App loads → SupabaseClientProvider registered as scoped service
  2. First auth operation → Client lazily initialized
  3. During init → Tokens loaded from localStorage if present
  4. SetSession called with stored tokens → User authenticated
  5. On login/signup → Tokens saved to localStorage
  6. On logout → Tokens cleared from localStorage
  7. On page refresh → Steps 2-4 repeat, session restored automatically

### Service Architecture
- **SupabaseClientProvider**: 
  - Manages single Supabase.Client instance per scope
  - Lazy initialization with session restoration
  - Token persistence methods (SaveTokensAsync, ClearTokensAsync)
- **ClientAuthService**: 
  - Implements IAuthService directly
  - Uses SupabaseClientProvider for all operations
  - No longer a decorator, direct implementation
- **LocalStorageService**: JSInterop wrapper for browser storage

### Service Layer
```
IAuthService (interface)
  ↓
AuthService (implementation)
  ↓
Supabase Client
```

### State Management
```
SupabaseAuthenticationStateProvider
  ↓
AuthenticationStateProvider (Blazor)
  ↓
CascadingAuthenticationState
  ↓
Components (AuthorizeView, [Authorize])
```

### Configuration Structure
```json
{
  "Supabase": {
    "Url": "project-url",
    "Key": "anon-key",
    "AutoRefreshToken": true,
    "PersistSession": true
  }
}
```

## UI Component Patterns

### MudBlazor Components
- Use `MudContainer` with `MaxWidth` for responsive layouts
- `MudPaper` for card-style containers with elevation
- `MudButton` with consistent variants (Filled for primary, Outlined for secondary)
- `MudSnackbar` for notifications via `ISnackbar` injection

### Form Handling
- `EditForm` with `Model` and `OnValidSubmit`
- `DataAnnotationsValidator` for validation
- Loading states with `MudProgressCircular`
- Error handling with try-catch and snackbar notifications

### Protected Routes
- Use `[Authorize]` attribute on pages
- `AuthorizeView` component for conditional rendering
- `AuthorizeRouteView` in App.razor for route-level auth
- `RedirectToLogin` component for unauthorized access

## Code Organization

### Service Package Structure
```
auth-srv/base/
├── Configuration/       # Settings classes
├── Interfaces/          # Service contracts
├── Models/              # DTOs and domain models
├── Services/            # Service implementations
└── README.md            # Package documentation
```

### Metahubs Service Package
```
metahubs-srv/base/
├── Interfaces/          # Service contracts (IMetahubsService)
├── Models/              # Runtime entity models with Postgrest attributes
│   └── Metahub.cs       # [Table], [Column] attributes for HTTP API
├── Services/            # Service implementations (MetahubsService)
│   ├── MetahubsService.cs                 # Uses Supabase.Client (HTTP-based)
│   └── ServiceCollectionExtensions.cs     # DI registration
└── README.md            # Package documentation
```

**Data Access Pattern**:
- **Runtime**: Supabase Client (PostgREST) for HTTP-based database operations (browser-compatible)
- **Design-time migrations**: Separate `db-migrations` package (see below)
- Models use Postgrest attributes: `[Table("metahubs")]`, `[Column("_upl_created_at")]`, `[PrimaryKey]`
- JSONB fields mapped to `JsonDocument` for localized content
- Soft delete pattern with `_upl_deleted` and `_mhb_deleted` flags
- RLS policies enforced automatically by Supabase

**Query Pattern Example**:
```csharp
var metahubs = await _supabaseClient
    .From<Metahub>()
    .Filter("_upl_deleted", Postgrest.Constants.Operator.Equals, false)
    .Filter("_mhb_deleted", Postgrest.Constants.Operator.Equals, false)
    .Order("_upl_created_at", Postgrest.Constants.Ordering.Descending)
    .Get();
```

**Entity Models**:
- `Metahub` - Main configuration container (like a "database" in 1C:Enterprise)
- (Future: `MetahubBranch`, `MetahubUser`, `Publication`, `PublicationVersion`)

### Database Migration Package
```
db-migrations/base/
├── Data/
│   ├── Entities/              # EF Core entity models (design-time only)
│   │   ├── BaseEntity.cs      # System fields (_upl_*, _mhb_*)
│   │   ├── MetahubEntity.cs
│   │   ├── MetahubBranchEntity.cs
│   │   ├── MetahubUserEntity.cs
│   │   ├── PublicationEntity.cs
│   │   └── PublicationVersionEntity.cs
│   ├── MetahubsDbContext.cs           # EF Core context with fluent API
│   └── MetahubsDbContextFactory.cs    # Design-time factory for dotnet ef
├── Migrations/                 # Generated EF Core migrations
├── Program.cs                  # Console app (not run at runtime)
├── README.md                   # Migration workflow instructions
└── DbMigrationGenerator.csproj # EF Core, Npgsql packages
```

**Purpose**: Generate SQL migrations from C# entity models
**NOT used at runtime** - Blazor WASM cannot use EF Core (browser cannot connect to PostgreSQL via TCP)

**Migration Workflow**:
1. Define/update entities in `Data/Entities/`
2. Generate migration: `dotnet ef migrations add <Name> --project db-migrations/base`
3. Export SQL: `dotnet ef migrations script --output supabase/migrations/<timestamp>_<name>.sql`
4. Manual adjustments: Add RLS policies, convert ENUMs in SQL file
5. Apply: Copy SQL to Supabase Studio SQL Editor and execute

**Why This Pattern**:
- **Problem**: Blazor WASM runs in browser → cannot make TCP connections to PostgreSQL
- **EF Core requires**: Direct socket access to database (Npgsql driver)
- **Solution**: Use EF Core only for SQL generation, apply migrations manually
- **Benefits**: Type-safe C# models, automatic index generation, migration tracking
- **Trade-offs**: RLS policies require manual SQL, ENUMs need conversion (EF Core generates TEXT)

### Frontend Integration
```
main-frt/base/
├── Components/          # Reusable UI components
├── Pages/               # Routable pages
├── Layout/              # Layout components
├── Program.cs           # DI configuration
└── _Imports.razor       # Global usings
```

- UI parity: Mirror React/MUI spacing and colors in MudBlazor with explicit inline styles and CSS vars/fallbacks; use matching grid breakpoints (12/6/3) for cards.
- Background overlay: Full-page background image with a radial gradient overlay (ellipse 80% 50% at 50% -20%) and z-index layering to keep text legible.
- Header: Fixed, translucent app bar with blur, soft border, and contained width; includes language toggle and login action aligned to the right.
- Footer: Four link items (Telegram, email, Terms, Privacy) with icons; guest variant uses white text, shadow, and subtle hover lift.
