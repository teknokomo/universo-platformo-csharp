# Tech Context

## Core Stack
- **Frontend**: Blazor WebAssembly on .NET 9 / C# 13 using MudBlazor 8.15.0
- **Backend Services**: .NET 9 class libraries with dependency injection
- **Authentication**: Supabase via `supabase-csharp` v0.16.2 NuGet package
- **Database**: Supabase (PostgreSQL) for user management and data storage

## Package Architecture
- **Modular Structure**: All features in `src/packages/` directory
- **Naming Convention**: 
  - `-frt` suffix for frontend packages (Blazor components)
  - `-srv` suffix for backend/service packages (.NET libraries)
- **Current Packages**:
  - `main-frt/base` - Main Blazor WebAssembly application
  - `start-frt/base` - Landing page components (guest experience)
  - `auth-srv/base` - Authentication service package
  - `metahubs-srv/base` - Metahubs data service (uses Supabase SDK)
  - `db-migrations/base` - Database migration generator (EF Core, design-time only)

## Database & ORM Architecture

### Problem: Blazor WASM Cannot Connect Directly to PostgreSQL
- **Challenge**: Blazor WebAssembly runs in browser sandbox → cannot make raw TCP connections to database
- **EF Core/Npgsql/Dapper**: Require direct TCP socket access → incompatible with browser environment
- **Solution**: Hybrid approach using EF Core for design-time (migration generation) and Supabase SDK for runtime (HTTP-based)

### Design-Time: Migration Generation
- **Tool**: `db-migrations/base` - standalone console project with EF Core
- **Purpose**: Generate SQL migrations from C# entity models
- **Multi-DB targeting**: Named targets in `db-migrations/base/migration-settings.json`
- **Target selection**: `--database <target>` argument passed through `dotnet ef ... -- --database <target>`
- **Supported design-time providers**: PostgreSQL, SQL Server, SQLite
- **Process**:
  1. Define entities in `db-migrations/base/Data/Entities/` with EF Core attributes
  2. Run: `dotnet ef migrations add <MigrationName> -- --database <target>`
  3. Export SQL: `dotnet ef migrations script --output supabase/migrations/<timestamp>_<name>.sql -- --database supabase`
  4. Apply via Supabase Studio SQL Editor or Supabase CLI
- **Benefits**: 
  - Type-safe C# models drive schema
  - Automatic index/constraint generation
  - Migration versioning and history
  - One migration workflow for multiple database engines
- **Limitations**: 
  - RLS policies must be added manually to SQL (EF Core doesn't generate them)
  - PostgreSQL ENUMs converted to TEXT by EF Core (manual conversion in supplementary migration)

### Runtime: Data Access (Blazor WASM)
- **Tool**: `metahubs-srv/base` - service library using `supabase-csharp` SDK
- **HTTP-Based**: Works via Supabase REST API (PostgREST), browser-compatible
- **Models**: POCOs with `[Table]` and `[Column]` attributes from `Postgrest.Attributes`
- **Query Pattern**: 
  ```csharp
  var metahubs = await _supabaseClient
      .From<Metahub>()
      .Filter("_upl_deleted", Postgrest.Constants.Operator.Equals, false)
      .Order("_upl_created_at", Postgrest.Constants.Ordering.Descending)
      .Get();
  ```
- **Benefits**:
  - Works in Blazor WASM (HTTP, not TCP)
  - RLS policies enforced automatically by Supabase
  - Type-safe queries with C# models

### Migration Workflow
1. **Define/Update Entities**: Edit `db-migrations/base/Data/Entities/*.cs`
2. **Choose Target**: Verify target with `dotnet run --project src/packages/db-migrations/base -- list`
3. **Generate Migration**: `dotnet ef migrations add <Name> --project db-migrations/base -- --database <target>`
4. **Export SQL (Supabase)**: `dotnet ef migrations script --output supabase/migrations/<timestamp>_<name>.sql -- --database supabase`
5. **Manual Adjustments**: Add RLS policies, fix ENUMs if needed in SQL file
6. **Apply Migration**: Copy SQL to Supabase Studio SQL Editor and run (or `dotnet ef database update` for local SQL Server/SQLite)
7. **Update Runtime Models**: Sync `metahubs-srv/base/Models/*.cs` with schema (if adding new tables/columns)
8. **Build & Test**: `dotnet build` → verify Blazor app works with new schema

## Dependencies

### Authentication Package (auth-srv)
```xml
<PackageReference Include="supabase-csharp" Version="0.16.2" />
<PackageReference Include="Microsoft.AspNetCore.Components.Authorization" Version="9.0.0" />
<PackageReference Include="Microsoft.Extensions.Configuration.Abstractions" Version="9.0.0" />
<PackageReference Include="Microsoft.Extensions.DependencyInjection.Abstractions" Version="9.0.0" />
<PackageReference Include="Microsoft.Extensions.Options" Version="9.0.0" />
```

### Main Frontend (main-frt)
```xml
<PackageReference Include="Microsoft.AspNetCore.Components.WebAssembly" Version="9.0.2" />
<PackageReference Include="Microsoft.AspNetCore.Components.WebAssembly.DevServer" Version="9.0.2" />
<PackageReference Include="MudBlazor" Version="8.15.0" />
```

## Configuration
- **Settings**: `wwwroot/appsettings.json` for client-side configuration
- **Supabase**: URL and API key stored in appsettings (should be env vars in production)
- **Build**: Standard .NET SDK build system
- **Run**: `dotnet run --project src/packages/main-frt/base`

## Reference Stack
- React + MUI backup located at `.backup/start-frontend/base`
- Used solely for visual parity reference
- Not actively maintained or run

## Assets & Resources
- Static assets in `wwwroot/` directories
- Images copied via MSBuild targets
- i18n resources in component-specific directories

## Build & Development
- **Build**: `dotnet build` from repository root
- **Run**: `dotnet run --project src/packages/main-frt/base`
- **Watch**: `dotnet watch --project src/packages/main-frt/base` for hot reload
- PNPM used for documentation tooling only (not for .NET packages)
