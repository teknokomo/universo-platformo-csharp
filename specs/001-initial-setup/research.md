# Phase 0: Research & Design Decisions

**Feature**: Initial Project Setup (001-initial-setup)  
**Date**: 2025-11-17  
**Status**: Complete

## Research Areas

This document resolves all "NEEDS CLARIFICATION" items from the Technical Context and establishes best practices for the technology choices.

---

## 1. .NET Monorepo Solution Structure

### Decision
Use a single .sln file at repository root with Directory.Build.props for shared configuration. Each package is a separate .csproj with clear boundaries.

### Rationale
- **Standard .NET Practice**: Single solution file is the idiomatic approach for .NET monorepos
- **Tooling Support**: Visual Studio, Rider, and VS Code all support this structure natively
- **Build Efficiency**: MSBuild can parallelize builds and detect changed projects
- **Package References**: Project-to-project references maintain type safety and support IntelliSense
- **Versioning**: NuGet Central Package Management allows consistent dependency versions

### Alternatives Considered
- **Multiple Solution Files**: Rejected - increases complexity, harder to maintain consistency
- **No Solution File**: Rejected - poor IDE experience, manual build orchestration needed
- **PNPM Workspaces (from React)**: Not applicable - PNPM is for JavaScript/Node.js ecosystems

### Implementation
```xml
<!-- Directory.Build.props at root -->
<Project>
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <LangVersion>latest</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>
</Project>
```

### References
- [.NET Solution Structure Best Practices](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-sln)
- [Directory.Build.props Documentation](https://learn.microsoft.com/en-us/visualstudio/msbuild/customize-by-directory)

---

## 2. Blazor WebAssembly vs Blazor Server

### Decision
Use Blazor WebAssembly (WASM) for frontend packages, not Blazor Server.

### Rationale
- **Alignment with React Implementation**: WASM provides client-side execution similar to React's browser-based model
- **Offline Capability**: WASM apps can work offline with service workers (important for platform extensibility)
- **Scalability**: Client-side execution reduces server load, no SignalR connection overhead
- **Deployment Flexibility**: Static hosting possible (CDN, GitHub Pages, etc.)
- **Rich Interactivity**: Full access to browser APIs via JavaScript interop

### Alternatives Considered
- **Blazor Server**: Rejected - requires constant server connection, doesn't match React architecture model
- **Blazor Hybrid**: Not applicable - this is a web platform, not a native app

### Implementation Notes
- Use standalone WASM apps in `-frt` packages
- API communication via HttpClient to `-srv` backend packages
- Consider AOT (Ahead-of-Time) compilation for production builds to improve performance

### References
- [Blazor Hosting Models Comparison](https://learn.microsoft.com/en-us/aspnet/core/blazor/hosting-models)
- [Blazor WASM Performance Best Practices](https://learn.microsoft.com/en-us/aspnet/core/blazor/performance)

---

## 3. UI Component Library: MudBlazor

### Decision
Use MudBlazor as the Material Design component library for Blazor.

### Rationale
- **Material Design**: Matches MUI (Material-UI) used in React reference implementation
- **Comprehensive Components**: Rich set of components (data grids, forms, dialogs, navigation)
- **Active Development**: Well-maintained with regular updates and large community
- **Blazor-Native**: Designed specifically for Blazor, not a wrapper around JavaScript libraries
- **Theming Support**: Customizable themes matching Material Design specifications
- **Documentation**: Excellent docs with live examples

### Alternatives Considered
- **Blazorise**: Good library but Bootstrap-focused, doesn't match Material Design requirement
- **MatBlazor**: Rejected - less active development, smaller community
- **Radzen Blazor**: Strong contender, but MudBlazor has better Material Design alignment
- **Build Custom**: Rejected - would require significant effort and delay feature development

### Implementation
```xml
<PackageReference Include="MudBlazor" Version="6.x" />
```

### References
- [MudBlazor Official Site](https://mudblazor.com/)
- [MudBlazor GitHub](https://github.com/MudBlazor/MudBlazor)

---

## 4. Supabase Integration for C#/.NET

### Decision
Use Supabase REST API via HttpClient with custom repository layer, not official SDK initially. Plan for supabase-csharp library evaluation.

### Rationale
- **SDK Status**: supabase-csharp library exists but less mature than JS/Python SDKs
- **Flexibility**: Custom HttpClient approach provides full control over API interactions
- **Abstraction Ready**: Repository pattern makes it easy to swap implementations
- **Authentication**: Supabase Auth works well with JWT tokens in ASP.NET Core
- **Realtime**: Can use supabase-csharp for realtime features if needed later

### Alternatives Considered
- **supabase-csharp Library**: May integrate later once more mature and stable
- **Direct PostgreSQL**: Possible via EF Core, but loses Supabase Auth and API benefits initially
- **GraphQL Client**: Not necessary, REST API is sufficient for initial implementation

### Implementation Approach
```csharp
// Repository abstraction layer
public interface IClusterRepository
{
    Task<Cluster> GetByIdAsync(string id);
    Task<IEnumerable<Cluster>> GetAllAsync();
    Task<Cluster> CreateAsync(Cluster cluster);
    // ... other methods
}

// Supabase implementation
public class SupabaseClusterRepository : IClusterRepository
{
    private readonly HttpClient _httpClient;
    private readonly SupabaseConfig _config;
    
    // Implementation using Supabase REST API
}
```

### References
- [Supabase REST API Documentation](https://supabase.com/docs/guides/api)
- [supabase-csharp Library](https://github.com/supabase-community/supabase-csharp)
- [Supabase Authentication](https://supabase.com/docs/guides/auth)

---

## 5. Authentication: ASP.NET Identity with Supabase Auth

### Decision
Use ASP.NET Core Identity integrated with Supabase Auth JWT tokens.

### Rationale
- **Standards-Based**: JWT tokens are industry standard, work across platforms
- **ASP.NET Integration**: Built-in middleware for JWT authentication
- **Supabase Support**: Supabase Auth provides JWT tokens that can be validated in .NET
- **Role-Based Access**: ASP.NET Identity supports role/claim-based authorization
- **Extensible**: Can add other providers (Google, GitHub) via Supabase Auth

### Alternatives Considered
- **IdentityServer/Duende**: Rejected - overkill for initial setup, adds complexity
- **Auth0**: Not aligned with Supabase requirement
- **Custom JWT**: Rejected - reinventing the wheel, security risks

### Implementation Notes
```csharp
// Startup/Program.cs
services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = "https://your-project.supabase.co";
        options.Audience = "authenticated";
        // Additional configuration
    });
```

### References
- [ASP.NET Core JWT Authentication](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/)
- [Supabase Auth with JWT](https://supabase.com/docs/guides/auth/auth-helpers)

---

## 6. Testing Framework: xUnit

### Decision
Use xUnit for unit and integration tests with Moq for mocking.

### Rationale
- **.NET Community Standard**: xUnit is most popular in modern .NET projects
- **Attributes**: Clean attribute-based test discovery ([Fact], [Theory])
- **Parallel Execution**: Tests run in parallel by default for better performance
- **Integration Tests**: Works well with ASP.NET Core TestServer for API testing
- **Mocking**: Moq is the industry standard for .NET mocking

### Alternatives Considered
- **NUnit**: Viable alternative, but xUnit is more modern and idiomatic
- **MSTest**: Rejected - less flexible, older design

### Implementation Structure
```
packages/[feature]-srv/
└── base/
    ├── [Feature].Server.csproj
    └── [Feature].Tests.csproj     # xUnit test project
        ├── Unit/                   # Unit tests
        ├── Integration/            # Integration tests
        └── Fixtures/               # Test fixtures and helpers
```

### References
- [xUnit Documentation](https://xunit.net/)
- [ASP.NET Core Integration Testing](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests)

---

## 7. Entity Framework Core for Database Abstraction

### Decision
Use Entity Framework Core with code-first approach and repository pattern.

### Rationale
- **ORM Standard**: EF Core is the standard ORM for .NET
- **Database Agnostic**: Supports PostgreSQL, SQL Server, SQLite with provider swap
- **Migrations**: Built-in migration system for schema management
- **LINQ**: Type-safe queries with IntelliSense support
- **Abstraction Layer**: Repository pattern over EF Core enables Supabase REST API initially

### Alternatives Considered
- **Dapper**: Rejected - micro-ORM, less abstraction, more SQL management
- **Direct ADO.NET**: Rejected - too low-level, more boilerplate code

### Implementation Strategy
```csharp
// Domain-specific DbContext
public class ClusterDbContext : DbContext
{
    public DbSet<Cluster> Clusters { get; set; }
    public DbSet<Domain> Domains { get; set; }
    public DbSet<Resource> Resources { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Configure relationships and constraints
    }
}

// Migration per domain package
dotnet ef migrations add InitialCreate --project packages/clusters-srv/base
```

### References
- [Entity Framework Core Documentation](https://learn.microsoft.com/en-us/ef/core/)
- [EF Core with PostgreSQL](https://www.npgsql.org/efcore/)

---

## 8. Package Naming and Organization

### Decision
Follow strict naming convention: `[domain]-[type]` where type is `frt`, `srv`, or `common`.

### Rationale
- **Clarity**: Immediately obvious what each package contains
- **Consistency**: Matches constitution requirements
- **Scalability**: Easy to add new domains and types
- **Tooling**: Simple glob patterns for CI/CD and scripts
- **Searchability**: Easy to find related packages

### Implementation Examples
```
packages/
├── clusters-frt/          # Clusters frontend
├── clusters-srv/          # Clusters backend
├── clusters-common/       # Clusters shared contracts
├── metaverses-frt/        # Metaverses frontend
├── metaverses-srv/        # Metaverses backend
├── auth-srv/              # Auth backend (no frontend)
└── shared-common/         # Platform-wide shared types
```

### base/ Directory Pattern
Each package must contain a `base/` directory for the primary implementation:
```
packages/clusters-srv/
└── base/                  # Base/default implementation
    ├── Controllers/
    ├── Services/
    ├── Repositories/
    └── Clusters.Server.csproj
```

Future alternative implementations (e.g., different DBMS) would be siblings:
```
packages/clusters-srv/
├── base/                  # Supabase implementation
└── postgresql/            # Direct PostgreSQL (future)
```

---

## 9. Bilingual Documentation Strategy

### Decision
Create all documentation in English first, then create Russian version with identical structure and line count.

### Rationale
- **Constitution Requirement**: Non-negotiable per Principle IV
- **Version Control**: Easier to track changes when structure matches
- **Maintenance**: Clear process reduces documentation drift
- **Tooling**: Can build tools to verify structural consistency
- **Community**: Serves both English and Russian developers equally

### Implementation Process
1. Write complete English version (e.g., README.md)
2. Create Russian version with `-RU` suffix (e.g., README-RU.md)
3. Translate content while preserving structure exactly
4. Verify line count matches (use `wc -l` to verify)
5. For Issues/PRs, use spoiler format:
   ```markdown
   ## Title (English)
   
   Content in English...
   
   <details><summary>In Russian</summary>
   
   ## Название (на русском)
   
   Содержание на русском...
   
   </details>
   ```

### References
- [i18n-docs.md Instructions](.github/instructions/i18n-docs.md)

---

## 10. GitHub Labels Strategy

### Decision
Create comprehensive label set covering type, status, priority, and domain categories.

### Rationale
- **Organization**: Clear categorization of issues and PRs
- **Filtering**: Easy to find related work items
- **Automation**: Labels enable GitHub Actions workflows
- **Standards**: Follows `.github/instructions/github-labels.md` requirements
- **Bilingual**: Label descriptions include both English and Russian

### Label Categories
1. **Type**: `type:feature`, `type:bug`, `type:docs`, `type:enhancement`
2. **Status**: `status:planning`, `status:in-progress`, `status:review`, `status:blocked`
3. **Priority**: `priority:critical`, `priority:high`, `priority:medium`, `priority:low`
4. **Domain**: `domain:clusters`, `domain:metaverses`, `domain:auth`, `domain:infrastructure`
5. **Special**: `good first issue`, `help wanted`, `wontfix`

### References
- [GitHub Labels Documentation](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels)

---

## 11. CI/CD Pipeline Structure

### Decision
Use GitHub Actions for CI/CD with separate workflows for build, test, and deploy.

### Rationale
- **Native Integration**: GitHub Actions integrates seamlessly with repository
- **Free Tier**: Generous free minutes for public repositories
- **.NET Support**: Official Microsoft actions for .NET builds
- **Matrix Builds**: Can test against multiple .NET versions
- **Artifact Management**: Built-in artifact storage and deployment

### Workflow Strategy
```yaml
# .github/workflows/build.yml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '8.0.x'
      - run: dotnet build
      - run: dotnet test
```

### References
- [GitHub Actions for .NET](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-net)

---

## Summary of Research Outcomes

All "NEEDS CLARIFICATION" items from Technical Context have been resolved:

| Area | Decision | Confidence |
|------|----------|------------|
| Monorepo Structure | .NET Solution with Directory.Build.props | High |
| Frontend Framework | Blazor WebAssembly | High |
| UI Components | MudBlazor | High |
| Database Access | Repository pattern over Supabase REST API initially | High |
| ORM Strategy | Entity Framework Core with code-first | High |
| Authentication | ASP.NET Identity + Supabase Auth JWT | High |
| Testing | xUnit + Moq | High |
| Documentation | English first, then Russian with identical structure | High |
| CI/CD | GitHub Actions | High |

**Next Phase**: Proceed to Phase 1 (Design & Contracts) to create data models and API contracts.
