# Universo Platformo C# - Architecture Documentation

This document outlines the architecture and design decisions for the C# implementation of Universo Platformo.

<details>
<summary>In Russian</summary>

# Universo Platformo C# - Документация архитектуры

Этот документ описывает архитектуру и проектные решения для реализации Universo Platformo на C#.
</details>

## Table of Contents / Содержание

1. [Overview / Обзор](#overview--обзор)
2. [Monorepo Structure / Структура монорепозитория](#monorepo-structure--структура-монорепозитория)
3. [Package Architecture / Архитектура пакетов](#package-architecture--архитектура-пакетов)
4. [Technology Mappings / Соответствие технологий](#technology-mappings--соответствие-технологий)
5. [Authentication / Аутентификация](#authentication--аутентификация)
6. [Database Layer / Слой базы данных](#database-layer--слой-базы-данных)
7. [Frontend Architecture / Архитектура фронтенда](#frontend-architecture--архитектура-фронтенда)
8. [Backend Architecture / Архитектура бэкенда](#backend-architecture--архитектура-бэкенда)
9. [Build System / Система сборки](#build-system--система-сборки)

## Overview / Обзор

Universo Platformo C# is a C# implementation of the Universo Platformo concept, originally developed in React/TypeScript. This implementation maintains the same conceptual architecture while adapting it to the .NET ecosystem and C# best practices.

**Key Design Principles / Ключевые принципы проектирования:**

- **Type Safety**: Leverage C#'s strong typing throughout the stack
- **Modularity**: Package-based architecture with clear boundaries
- **Base Implementations**: Each package has a `base/` folder for future extensibility
- **Blazor WebAssembly**: Modern web UI framework for C#
- **ASP.NET Core**: Robust backend framework
- **Supabase Integration**: Multi-user functionality and data storage

<details>
<summary>In Russian</summary>

Universo Platformo C# - это реализация концепции Universo Platformo на C#, изначально разработанной на React/TypeScript. Эта реализация сохраняет ту же концептуальную архитектуру, адаптируя её к экосистеме .NET и лучшим практикам C#.
</details>

## Monorepo Structure / Структура монорепозитория

Unlike the React version that uses PNPM workspaces, the C# version uses .NET's native monorepo capabilities:

```
universo-platformo-csharp/
├── src/
│   ├── packages/              # Feature packages
│   ├── shared/                # Shared libraries
│   ├── Universo.sln           # Main solution file
│   ├── Directory.Build.props  # Shared MSBuild properties
│   └── Directory.Packages.props # Centralized package versions
├── tests/
│   ├── unit/                  # Unit tests
│   ├── integration/           # Integration tests
│   └── Tests.sln              # Test solution
├── tools/
│   └── build/                 # Build scripts
├── docs/                      # Documentation
├── .github/                   # GitHub configuration
└── .gitignore                 # Git ignore rules
```

### Directory.Build.props

This file contains shared MSBuild properties for all projects:

```xml
<Project>
  <PropertyGroup>
    <LangVersion>latest</LangVersion>
    <Nullable>enable</Nullable>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <GenerateDocumentationFile>true</GenerateDocumentationFile>
  </PropertyGroup>
</Project>
```

### Directory.Packages.props

Centralizes NuGet package versions (similar to PNPM's workspace dependencies):

```xml
<Project>
  <PropertyGroup>
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
  </PropertyGroup>
  <ItemGroup>
    <PackageVersion Include="MudBlazor" Version="7.0.0" />
    <PackageVersion Include="Supabase" Version="0.15.0" />
    <!-- Other packages... -->
  </ItemGroup>
</Project>
```

<details>
<summary>In Russian</summary>

В отличие от версии на React, использующей рабочие области PNPM, версия на C# использует нативные возможности монорепозитория .NET через файлы Directory.Build.props и Directory.Packages.props.
</details>

## Package Architecture / Архитектура пакетов

Each functional area is organized as a package with separate frontend and backend projects:

```
packages/
├── clusters-frt/              # Clusters frontend
│   └── base/
│       ├── Universo.Clusters.Frontend.csproj
│       ├── Pages/
│       ├── Components/
│       ├── Services/
│       └── Models/
├── clusters-srv/              # Clusters backend
│   └── base/
│       ├── Universo.Clusters.Backend.csproj
│       ├── Controllers/
│       ├── Services/
│       ├── Repositories/
│       └── Models/
```

### Package Naming Convention / Соглашение об именовании пакетов

- **Frontend packages**: `<feature>-frt` (e.g., `clusters-frt`)
- **Backend packages**: `<feature>-srv` (e.g., `clusters-srv`)
- **Project names**: `Universo.<Feature>.<Type>` (e.g., `Universo.Clusters.Frontend`)

### Base Folder Pattern / Паттерн папки Base

Each package has a `base/` folder containing the primary implementation. This allows for:

- Multiple implementations in the future (e.g., `base/`, `alternative/`)
- Clear separation of different implementation strategies
- Easy swapping of implementations

<details>
<summary>In Russian</summary>

Каждая функциональная область организована как пакет с отдельными проектами фронтенда и бэкенда. Каждый пакет имеет папку `base/`, содержащую основную реализацию, что позволяет иметь несколько реализаций в будущем.
</details>

## Technology Mappings / Соответствие технологий

Mapping from React version to C# version:

| React Version | C# Version | Purpose |
|---------------|------------|---------|
| PNPM Workspaces | .NET Solution + Directory.*.props | Monorepo management |
| npm packages | NuGet packages | Package management |
| TypeScript | C# | Programming language |
| React | Blazor WebAssembly | Frontend framework |
| Express.js | ASP.NET Core | Backend framework |
| Passport.js | ASP.NET Core Identity | Authentication |
| Material-UI (MUI) | MudBlazor | UI component library |
| React Router | Blazor Router | Routing |
| Redux/Zustand | Fluxor | State management |
| Axios | HttpClient | HTTP client |
| TypeORM | Entity Framework Core | ORM |
| Jest/Vitest | xUnit | Testing framework |
| ESLint | .editorconfig + Roslyn | Code style |

<details>
<summary>In Russian</summary>

| Версия на React | Версия на C# | Назначение |
|-----------------|--------------|------------|
| PNPM Workspaces | Решение .NET + Directory.*.props | Управление монорепозиторием |
| npm пакеты | NuGet пакеты | Управление пакетами |
| TypeScript | C# | Язык программирования |
| React | Blazor WebAssembly | Фреймворк фронтенда |
| Express.js | ASP.NET Core | Фреймворк бэкенда |
</details>

## Authentication / Аутентификация

### Supabase Integration / Интеграция с Supabase

The C# version uses the Supabase C# client library for authentication:

```csharp
public class SupabaseAuthService : IAuthService
{
    private readonly Supabase.Client _client;
    
    public SupabaseAuthService(IConfiguration configuration)
    {
        var url = configuration["Supabase:Url"];
        var key = configuration["Supabase:AnonKey"];
        
        _client = new Supabase.Client(url, key);
    }
    
    public async Task<AuthResponse> SignInAsync(string email, string password)
    {
        return await _client.Auth.SignIn(email, password);
    }
}
```

### ASP.NET Core Identity Integration / Интеграция с ASP.NET Core Identity

For additional authentication features, we integrate ASP.NET Core Identity with Supabase:

```csharp
services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = configuration["Supabase:JwtIssuer"],
            ValidAudience = configuration["Supabase:JwtAudience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(configuration["Supabase:JwtSecret"]))
        };
    });
```

<details>
<summary>In Russian</summary>

Версия на C# использует клиентскую библиотеку Supabase для C# для аутентификации, интегрированную с ASP.NET Core Identity для дополнительных возможностей аутентификации.
</details>

## Database Layer / Слой базы данных

### Entity Framework Core

We use Entity Framework Core as the ORM, configured to work with Supabase's PostgreSQL database:

```csharp
public class UniversoDbContext : DbContext
{
    public DbSet<Cluster> Clusters { get; set; }
    public DbSet<Domain> Domains { get; set; }
    public DbSet<Resource> Resources { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Cluster>()
            .HasMany(c => c.Domains)
            .WithOne(d => d.Cluster)
            .HasForeignKey(d => d.ClusterId);
            
        // Additional configuration...
    }
}
```

### Repository Pattern / Паттерн репозитория

Each entity has a repository for data access:

```csharp
public interface IClusterRepository
{
    Task<Cluster?> GetByIdAsync(Guid id);
    Task<IEnumerable<Cluster>> GetAllAsync();
    Task<Cluster> CreateAsync(Cluster cluster);
    Task UpdateAsync(Cluster cluster);
    Task DeleteAsync(Guid id);
}

public class ClusterRepository : IClusterRepository
{
    private readonly UniversoDbContext _context;
    
    public ClusterRepository(UniversoDbContext context)
    {
        _context = context;
    }
    
    // Implementation...
}
```

<details>
<summary>In Russian</summary>

Мы используем Entity Framework Core в качестве ORM, настроенный для работы с базой данных PostgreSQL от Supabase. Каждая сущность имеет репозиторий для доступа к данным.
</details>

## Frontend Architecture / Архитектура фронтенда

### Blazor WebAssembly

Frontend is built with Blazor WebAssembly, which runs .NET in the browser:

```razor
@page "/clusters"
@inject IClusterService ClusterService

<MudContainer>
    <MudText Typo="Typo.h4">Clusters</MudText>
    
    @if (clusters == null)
    {
        <MudProgressCircular Indeterminate="true" />
    }
    else
    {
        <MudTable Items="@clusters">
            <HeaderContent>
                <MudTh>Name</MudTh>
                <MudTh>Description</MudTh>
            </HeaderContent>
            <RowTemplate>
                <MudTd>@context.Name</MudTd>
                <MudTd>@context.Description</MudTd>
            </RowTemplate>
        </MudTable>
    }
</MudContainer>

@code {
    private List<Cluster>? clusters;
    
    protected override async Task OnInitializedAsync()
    {
        clusters = await ClusterService.GetClustersAsync();
    }
}
```

### MudBlazor Components / Компоненты MudBlazor

MudBlazor provides Material Design components for Blazor:

- `MudTable` - Data tables
- `MudDialog` - Dialogs and modals
- `MudButton` - Buttons
- `MudTextField` - Input fields
- And many more...

### State Management / Управление состоянием

For state management, we use Fluxor (Redux pattern for Blazor):

```csharp
public record ClusterState
{
    public List<Cluster> Clusters { get; init; } = new();
    public bool IsLoading { get; init; }
}

public class LoadClustersAction { }

public class LoadClustersSuccessAction
{
    public List<Cluster> Clusters { get; }
    public LoadClustersSuccessAction(List<Cluster> clusters)
    {
        Clusters = clusters;
    }
}

[FeatureState]
public class ClusterFeature : Feature<ClusterState>
{
    public override string GetName() => "Clusters";
    protected override ClusterState GetInitialState() => new();
}
```

<details>
<summary>In Russian</summary>

Фронтенд построен на Blazor WebAssembly, который запускает .NET в браузере. MudBlazor предоставляет компоненты Material Design. Для управления состоянием используется Fluxor.
</details>

## Backend Architecture / Архитектура бэкенда

### ASP.NET Core

Backend uses ASP.NET Core with minimal API or controller-based approach:

```csharp
[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ClustersController : ControllerBase
{
    private readonly IClusterService _clusterService;
    private readonly ILogger<ClustersController> _logger;
    
    public ClustersController(
        IClusterService clusterService,
        ILogger<ClustersController> logger)
    {
        _clusterService = clusterService;
        _logger = logger;
    }
    
    [HttpGet]
    public async Task<ActionResult<List<Cluster>>> GetClusters()
    {
        _logger.LogInformation("Getting all clusters");
        var clusters = await _clusterService.GetClustersAsync();
        return Ok(clusters);
    }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<Cluster>> GetCluster(Guid id)
    {
        var cluster = await _clusterService.GetClusterAsync(id);
        
        if (cluster == null)
            return NotFound();
            
        return Ok(cluster);
    }
    
    [HttpPost]
    public async Task<ActionResult<Cluster>> CreateCluster(CreateClusterRequest request)
    {
        var cluster = await _clusterService.CreateClusterAsync(request);
        return CreatedAtAction(nameof(GetCluster), new { id = cluster.Id }, cluster);
    }
}
```

### Service Layer / Слой сервисов

Business logic is encapsulated in service classes:

```csharp
public interface IClusterService
{
    Task<List<Cluster>> GetClustersAsync();
    Task<Cluster?> GetClusterAsync(Guid id);
    Task<Cluster> CreateClusterAsync(CreateClusterRequest request);
    Task UpdateClusterAsync(Guid id, UpdateClusterRequest request);
    Task DeleteClusterAsync(Guid id);
}

public class ClusterService : IClusterService
{
    private readonly IClusterRepository _repository;
    private readonly IMapper _mapper;
    private readonly ILogger<ClusterService> _logger;
    
    public ClusterService(
        IClusterRepository repository,
        IMapper mapper,
        ILogger<ClusterService> logger)
    {
        _repository = repository;
        _mapper = mapper;
        _logger = logger;
    }
    
    // Implementation...
}
```

### Dependency Injection / Внедрение зависимостей

Services are registered in `Program.cs`:

```csharp
builder.Services.AddScoped<IClusterRepository, ClusterRepository>();
builder.Services.AddScoped<IClusterService, ClusterService>();
builder.Services.AddDbContext<UniversoDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("Supabase")));
```

<details>
<summary>In Russian</summary>

Бэкенд использует ASP.NET Core с контроллерами. Бизнес-логика инкапсулирована в классах сервисов. Сервисы регистрируются через внедрение зависимостей.
</details>

## Build System / Система сборки

### MSBuild

Projects are built using MSBuild:

```bash
# Build entire solution
dotnet build

# Build specific project
dotnet build src/packages/clusters-frt/base

# Clean build
dotnet clean && dotnet build

# Publish for deployment
dotnet publish -c Release -o publish/
```

### Build Targets / Цели сборки

Custom build targets can be defined in `.csproj` files:

```xml
<Target Name="CustomBuildTask" BeforeTargets="Build">
  <Message Text="Running custom build task" Importance="high" />
</Target>
```

### CI/CD Integration / Интеграция CI/CD

GitHub Actions workflow for building and testing:

```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '9.0.x'
      - run: dotnet restore
      - run: dotnet build --no-restore
      - run: dotnet test --no-build
```

<details>
<summary>In Russian</summary>

Проекты собираются с помощью MSBuild. Пользовательские цели сборки можно определить в файлах `.csproj`. CI/CD интегрируется через GitHub Actions.
</details>

## Development Workflow / Рабочий процесс разработки

1. **Clone repository / Клонировать репозиторий**
2. **Install .NET SDK / Установить .NET SDK**
3. **Restore packages / Восстановить пакеты**: `dotnet restore`
4. **Build solution / Собрать решение**: `dotnet build`
5. **Run tests / Запустить тесты**: `dotnet test`
6. **Start backend / Запустить бэкенд**: `dotnet run --project src/packages/main-srv/base`
7. **Start frontend / Запустить фронтенд**: `dotnet run --project src/packages/main-frt/base`

<details>
<summary>In Russian</summary>

Рабочий процесс разработки включает клонирование репозитория, установку .NET SDK, восстановление пакетов, сборку решения, запуск тестов и запуск приложения.
</details>

## Best Practices / Лучшие практики

1. **Use dependency injection / Использовать внедрение зависимостей**
2. **Follow SOLID principles / Следовать принципам SOLID**
3. **Write unit tests / Писать юнит-тесты**
4. **Document public APIs / Документировать публичные API**
5. **Use async/await / Использовать async/await**
6. **Handle exceptions properly / Правильно обрабатывать исключения**
7. **Use nullable reference types / Использовать nullable reference types**
8. **Follow C# naming conventions / Следовать соглашениям об именовании C#**

## References / Ссылки

- [.NET Documentation](https://docs.microsoft.com/dotnet/)
- [Blazor Documentation](https://docs.microsoft.com/aspnet/core/blazor/)
- [ASP.NET Core Documentation](https://docs.microsoft.com/aspnet/core/)
- [MudBlazor Documentation](https://mudblazor.com/)
- [Entity Framework Core Documentation](https://docs.microsoft.com/ef/core/)
- [Supabase C# Client](https://supabase.com/docs/reference/csharp/introduction)
