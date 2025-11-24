# Research: Best Practices for C# Blazor WebAssembly / ASP.NET Core

**Feature**: 001-initial-setup  
**Date**: 2025-11-17  
**Status**: Complete

## Executive Summary

This document consolidates research findings on best practices, patterns, and technical solutions for implementing Universo Platformo on C# with Blazor WebAssembly (frontend) and ASP.NET Core (backend). The research covers architectural patterns, monorepo structure, authentication strategies, UI component libraries, validation, error handling, caching, rate limiting, and testing approaches.

## 1. Blazor WebAssembly Architecture Patterns

### Decision: Clean Architecture with Layered Approach

**Rationale**: Clean Architecture provides clear separation of concerns, testability, and maintainability crucial for enterprise applications.

**Key Patterns**:
- **Separation of Concerns**: Structure solution around distinct layers—Domain, Application, Infrastructure, and Presentation (UI)
- **Component Architecture**: Break UI into small, focused, reusable components with high cohesion
- **Render Mode Agnostic**: Build components that can switch between server and WASM rendering as needed
- **MVVM Pattern**: For complex UIs, separate data, presentation, and business logic
- **State Management**: Use built-in .NET DI, cascading parameters, or Fluxor/Redux for complex global state

**Performance Optimization**:
- **AOT Compilation**: Use Ahead-of-Time compilation for optimized WASM performance
- **Minimize JavaScript Interop**: Limit interop calls and encapsulate them in dedicated components
- **Data Virtualization**: Implement virtualization for large datasets to keep UI responsive
- **Async/Await**: Use throughout for responsive UI

**Alternatives Considered**:
- MVVM-only approach: Rejected as too prescriptive for all scenarios
- Heavy JavaScript interop: Rejected due to performance concerns
- Single-layer architecture: Rejected as not scalable for enterprise needs

**References**:
- Clean Architecture Template Blazor Server (GitHub)
- Blazor Performance Tuning (Microsoft Docs)
- Blazor Basics: 9 Best Practices (Telerik)
- MESCIUS Blazor Best Practices 2024

---

## 2. ASP.NET Core Backend Monorepo Architecture

### Decision: Onion/Clean Architecture with .NET Solution Management

**Rationale**: Onion Architecture provides dependency inversion and testability while .NET solutions naturally support monorepo patterns.

**Recommended Structure**:
```
/repo-root
├── src/
│   ├── packages/
│   │   ├── [feature]-srv/
│   │   │   └── base/
│   │   │       ├── Controllers/
│   │   │       ├── Services/
│   │   │       ├── Models/
│   │   │       ├── Repositories/
│   │   │       └── Tests/
│   │   ├── [feature]-frt/
│   │   │   └── base/
│   │   │       ├── Components/
│   │   │       ├── Pages/
│   │   │       ├── Services/
│   │   │       └── Tests/
│   │   └── [feature]-common/
│   │       └── base/
│   │           ├── Contracts/
│   │           └── Models/
├── shared/
│   └── CommonLib/
├── tests/
└── docs/
```

**Key Principles**:
- **Single .sln File**: Manage all backend services and libraries via a single solution
- **Dependency Injection**: Register abstractions, not concrete types
- **Async Everywhere**: Make hot paths asynchronous to maximize throughput
- **Configuration Management**: Store settings in `appsettings.json` with environment profiles
- **Logging & Monitoring**: Use built-in `ILogger` or structured logging (Serilog)
- **Code Sharing**: Use `shared/` for common interfaces, DTOs, helpers
- **CI/CD Selective Builds**: Only rebuild/test affected projects on change

**Layering**:
- **Domain**: Pure business objects and logic (no dependencies)
- **Application**: Use-cases, orchestrating domain objects
- **Infrastructure**: Implementation details (DB, APIs, etc.)
- **Presentation/API**: Controllers, endpoints—expose application layer to clients

**Alternatives Considered**:
- Microservices from day one: Rejected as over-engineered for initial setup
- Multiple solution files: Rejected as it complicates development workflow
- Direct database access without abstraction: Rejected due to constitution requirements

**References**:
- Microsoft Best Practices (ASP.NET Core 9.0)
- Onion Architecture in .NET (Telerik)
- Monorepo Structure Best Practices
- Practical Monorepo Experience in .NET

---

## 3. Supabase Integration with C#/.NET

### Decision: JWT-Based Authentication with Repository Pattern

**Rationale**: Supabase uses GoTrue for authentication and issues JWTs. Proper validation and abstraction ensures security and flexibility.

**Implementation Pattern**:

**Frontend (Blazor)**:
- Handle authentication via Supabase Auth (JS client or direct HTTP)
- Store session (JWT) securely (httpOnly cookies for web or secure storage)
- Send JWT as Bearer token in API requests

**Backend (ASP.NET Core)**:
- Validate JWT using .NET's JwtBearer authentication middleware
- Extract and use Supabase JWT secret for validation
- No direct session management—just validate each request's token

**Configuration**:
```csharp
var supabaseSignatureKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(supabaseSecretKey));
var validIssuer = "https://<project-id>.supabase.co/auth/v1";
var validAudiences = new List<string>() { "authenticated" };

builder.Services.AddAuthentication().AddJwtBearer(o =>
{
    o.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = supabaseSignatureKey,
        ValidAudiences = validAudiences,
        ValidIssuer = validIssuer
    };
});
```

**Key Practices**:
- **Session Management**: Handle client-side, pass tokens to backend for verification
- **Role-Based Access**: Use custom claims in JWTs for authorization
- **Row Level Security (RLS)**: Ensure JWT is passed with each query for RLS policies
- **Repository Pattern**: Wrap Supabase client in repository for abstraction
- **Token Refresh**: Handle on client, consider short token lifespans with refresh mechanisms

**Alternatives Considered**:
- Server-side session management: Rejected as stateless JWT approach is more scalable
- Direct Supabase client in controllers: Rejected due to tight coupling
- Magic link only authentication: Rejected as too limited for all use cases

**References**:
- Integrating Supabase Auth with .NET (Rody van Sambeek)
- Supabase C# client docs (supabase.com)
- Protect ASP.NET site using Supabase authentication (hashset.dev)

---

## 4. MudBlazor Component Library

### Decision: MudBlazor as Primary UI Component Library

**Rationale**: MudBlazor is the most mature, well-documented Material Design library for Blazor with minimal JavaScript dependencies and strong community support.

**Best Practices**:

**Component Architecture**:
- **Encapsulation**: Build modular, self-contained components
- **Nesting & Hierarchy**: Use `<MudLayout>`, `<MudGrid>`, `<MudItem>` for logical structure
- **Theme Provider**: Use `<MudThemeProvider>` for global theming
- **Property Usage**: Prefer MudBlazor's built-in properties over custom CSS

**Responsive Layouts**:
- Use `<MudGrid>` with breakpoint system (`xs`, `sm`, `lg`, etc.)
- Leverage `<MudContainer>` and utility classes (`m-2`, `p-2`)

**State Management**:
- Integrate with Blazor's cascading parameters and DI
- Use Fluxor or MediatR for complex state scenarios
- Take advantage of .NET 8+ "Auto Render Mode"

**Parameter Management**:
- Never overwrite parameters in `OnParametersSet`
- Use internal variables for default values
- Utilize `ParameterState` pattern for robust parameter handling
- Use `InvokeAsync` for safe parameter updates

**Component Patterns**:
```razor
<MudLayout>
    <MudDrawer Clipped="true" Open="true">
        <NavMenu />
    </MudDrawer>
    <MudMainContent>
        <MudGrid>
            <MudItem xs="8"><MudPaper>Main Content</MudPaper></MudItem>
            <MudItem xs="4"><MudPaper>Sidebar</MudPaper></MudItem>
        </MudGrid>
    </MudMainContent>
</MudLayout>
```

**Alternatives Considered**:
- Blazorise: Good but less Material Design focused
- Radzen Blazor: Good but commercial licensing concerns
- Microsoft Fluent UI Blazor: Less mature ecosystem
- Custom components: Rejected due to development time

**References**:
- MudBlazor Official Docs (mudblazor.com)
- Top Blazor Component Libraries 2024
- MudBlazor GitHub repository
- Context7 MudBlazor documentation

---

## 5. Validation Strategy: FluentValidation

### Decision: FluentValidation for All Data Validation

**Rationale**: FluentValidation provides centralized, testable, reusable validation logic with excellent ASP.NET Core integration.

**Implementation Patterns**:

**Centralized Validator Classes**:
```csharp
public class PersonValidator : AbstractValidator<Person> 
{
  public PersonValidator() 
  {
    RuleFor(x => x.Id).NotNull();
    RuleFor(x => x.Name).Length(0, 10);
    RuleFor(x => x.Email).EmailAddress();
    RuleFor(x => x.Age).InclusiveBetween(18, 60);
  }
}
```

**Automatic Registration**:
```csharp
services.AddValidatorsFromAssemblyContaining<PersonValidator>();
services.AddFluentValidationAutoValidation();
```

**Key Practices**:
- **Separation of Concerns**: Keep validation out of models
- **Rule Composition**: Use chained rules for property validation
- **Conditional Rules**: Leverage `.When()` for complex scenarios
- **Custom Validation**: Implement via `.Must()` for domain-specific requirements
- **Async Validation**: Use `MustAsync` for I/O or external service checks
- **Options Pattern**: Validate startup configuration with `ValidateOnStart()`
- **Localization**: Support with `WithMessage` and localizable resources

**Integration Points**:
- ASP.NET Core Pipeline: Automatic model validation
- Minimal APIs: Manual injection and validation
- Blazor Forms: Client-side and server-side validation
- Configuration: Startup validation

**Alternatives Considered**:
- Data Annotations only: Rejected as less flexible and testable
- Manual validation: Rejected as not scalable or reusable
- JavaScript validation only: Rejected due to security concerns

**References**:
- FluentValidation Official Docs
- Enterprise Patterns and Advanced FluentValidation Usage
- Options Pattern Validation in ASP.NET Core
- Context7 FluentValidation documentation

---

## 6. Error Handling Architecture

### Decision: IExceptionHandler (ASP.NET Core 8+) with Custom Middleware Fallback

**Rationale**: .NET 8+ IExceptionHandler provides modular, type-specific error handling while maintaining centralized exception management.

**Modern Pattern (ASP.NET Core 8+)**:
```csharp
public class NotFoundExceptionHandler : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
    {
        if (exception is NotFoundException)
        {
            var details = new ProblemDetails
            {
                Status = StatusCodes.Status404NotFound,
                Title = "Not Found",
                Detail = exception.Message
            };
            httpContext.Response.StatusCode = StatusCodes.Status404NotFound;
            await httpContext.Response.WriteAsJsonAsync(details, cancellationToken);
            return true;
        }
        return false;
    }
}

// Registration
builder.Services.AddExceptionHandler<NotFoundExceptionHandler>();
app.UseExceptionHandler();
```

**Custom Middleware (Legacy/Fallback)**:
```csharp
public class GlobalExceptionHandlerMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<GlobalExceptionHandlerMiddleware> _logger;

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Unhandled exception occurred");
            context.Response.StatusCode = ex is ApplicationException
                ? StatusCodes.Status400BadRequest
                : StatusCodes.Status500InternalServerError;
            await context.Response.WriteAsJsonAsync(new ProblemDetails
            {
                Type = ex.GetType().Name,
                Title = "An error occurred",
                Detail = ex.Message
            });
        }
    }
}
```

**Key Practices**:
- **Structured Error Responses**: Use RFC 9457-compliant ProblemDetails
- **Severity Levels**: Log with Critical, Error, Warning, Information
- **Blazor Error Boundaries**: Implement for frontend graceful degradation
- **Custom Exception Types**: Create for domain errors (ValidationException, NotFoundException)
- **Health Checks**: Implement endpoints for system status verification
- **Security**: Never expose sensitive information in production error responses
- **Structured Logging**: Use Serilog or NLog

**Blazor Frontend Error Handling**:
```razor
<ErrorBoundary>
    <ChildContent>
        @Body
    </ChildContent>
    <ErrorContent Context="exception">
        <div class="error-message">
            An error occurred. Please try again later.
        </div>
    </ErrorContent>
</ErrorBoundary>
```

**Alternatives Considered**:
- Try-catch in every controller: Rejected as not DRY
- No error handling: Rejected due to production requirements
- Client-side only error handling: Rejected due to security concerns

**References**:
- Global Error Handling in ASP.NET Core (Milan Jovanovic)
- ASP.NET Core Error Handling Master Guide
- Mastering Error Handling in ASP.NET Core 9.0

---

## 7. Caching Strategy

### Decision: Hybrid Caching (IMemoryCache + IDistributedCache/Redis)

**Rationale**: Combine fast local caching with distributed caching for scalability and consistency across multiple instances.

**IMemoryCache (Local)**:
- **Use For**: Single-server scenarios, short-lived data, per-request caching
- **Best For**: Configuration data, UI data, frequently accessed small objects
- **Pattern**:
```csharp
if (_memoryCache.TryGetValue(key, out var value)) return value;
value = FetchFromDb();
_memoryCache.Set(key, value, TimeSpan.FromMinutes(10));
```

**IDistributedCache/Redis (Distributed)**:
- **Use For**: Web farms, cloud environments, large-scale apps, session data
- **Best For**: Product catalogs, user sessions, multi-step workflows
- **Pattern**:
```csharp
await _distributedCache.SetStringAsync(key, value);
value = await _distributedCache.GetStringAsync(key);
```
- **Configuration**:
```csharp
builder.Services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = configuration["Redis:ConnectionString"];
});
```

**Hybrid Pattern (.NET 9+)**:
- Coordinates both caches automatically
- Adds stampede protection
- Customizable serialization
- Best of both worlds

**Key Practices**:
- **Cache-Aside Pattern**: Check cache before hitting data source
- **Expiration Policies**: Configure absolute and sliding expirations
- **Cache Invalidation**: Explicit remove/update for frequently changed data
- **Serialization**: Use System.Text.Json for IDistributedCache
- **Naming Convention**: `{package}:{entity}:{id}`
- **Metrics**: Track cache hit/miss ratios

**Use Cases**:
1. **Session Data (Web Farm)**: Use IDistributedCache with Redis
2. **Single-Server**: Use IMemoryCache
3. **High-Volume Multi-Server**: Layer IMemoryCache with Redis fallback
4. **E-commerce Catalog**: Redis with expiration and update logic

**Alternatives Considered**:
- Memory cache only: Rejected for multi-instance scenarios
- No caching: Rejected due to performance requirements
- Database caching only: Rejected as not flexible enough

**References**:
- Microsoft Docs: In-memory caching
- Caching in ASP.NET Core (Milan Jovanovic)
- HybridCache .NET 9 Preview

---

## 8. API Security & Rate Limiting

### Decision: Built-in ASP.NET Core Rate Limiting Middleware (NET 7+)

**Rationale**: Native rate limiting provides flexible, configurable protection without external dependencies.

**Implementation**:
```csharp
builder.Services.AddRateLimiter(options =>
{
    options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
    
    // Fixed window: 100 requests per minute
    options.AddFixedWindowLimiter("global", o =>
    {
        o.PermitLimit = 100;
        o.Window = TimeSpan.FromMinutes(1);
        o.QueueLimit = 10;
    });
    
    // Per-IP limiting
    options.AddPolicy("PerIpPolicy", context =>
        RateLimitPartition.GetFixedWindowLimiter(
            context.Connection.RemoteIpAddress?.ToString(),
            _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 10,
                Window = TimeSpan.FromSeconds(1)
            }));
});

app.UseRateLimiter();
```

**Usage**:
```csharp
app.MapGet("/api/resource", YourHandler)
    .RequireRateLimiting("global");

[EnableRateLimiting("global")]
public class ApiController : ControllerBase { }
```

**Algorithms**:
- **Fixed Window**: Simple time-based limiting (100 requests per minute)
- **Sliding Window**: Smoother throttling with rolling intervals
- **Token Bucket**: Allows bursts then steady replenishment
- **Concurrency Limiter**: Controls simultaneous active requests

**Key Practices**:
- **IP-based**: 100 requests per 15 minutes for anonymous endpoints
- **User-based**: 1000 requests per hour for authenticated endpoints
- **Configurable Limits**: Different limits per endpoint category
- **Response Headers**: Include X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset
- **Graceful Degradation**: HTTP 429 with Retry-After header
- **Admin Exemption**: Exempt admin endpoints from rate limiting
- **Configuration**: Store in appsettings.json
- **Distributed**: Use Redis for multi-instance deployments

**Alternatives Considered**:
- AspNetCoreRateLimit library: Rejected in favor of built-in middleware
- No rate limiting: Rejected due to security requirements
- WAF only: Rejected as not application-aware

**References**:
- Microsoft Docs: Rate Limiting Middleware
- ASP.NET Core Rate Limiting (Burgyn's blog)
- Built-In Rate Limiting in ASP.NET Core (Code Maze)

---

## 9. Testing Strategy: xUnit with Testcontainers

### Decision: xUnit for Unit/Integration Tests with Testcontainers for Real Dependencies

**Rationale**: xUnit is the modern .NET testing framework, and Testcontainers provides isolated, production-like test environments.

**Patterns**:

**WebApplicationFactory for Integration Tests**:
```csharp
public class IntegrationTestFixture : IAsyncLifetime
{
    public CustomWebApplicationFactory<Startup> Factory { get; }

    public async Task InitializeAsync()
    {
        Factory = new CustomWebApplicationFactory<Startup>();
        // Setup containers, seed data, etc.
    }
    
    public async Task DisposeAsync()
    {
        // Clean up containers, data, etc.
    }
}
```

**Testcontainers for Real Dependencies**:
```csharp
var postgresContainer = new PostgreSqlBuilder()
    .WithImage("postgres:17")
    .WithDatabase("testdb")
    .WithUsername("user")
    .WithPassword("pass")
    .Build();

await postgresContainer.StartAsync();
```

**Key Practices**:
- **Test Only Critical Paths**: Focus on authentication, critical workflows
- **Clean Setup & Teardown**: Each test gets clean database and environment
- **Use Real Services**: Testcontainers for actual external services
- **Dedicated Test Project**: Keep integration tests separate
- **Naming Clarity**: Name tests to state behavior and context
- **End-to-End Scenarios**: Test request/response, error handling, authentication
- **CI/CD Integration**: Hook tests into pipelines
- **Performance**: Minimize integration test count, use parallelization with isolation
- **Maintainability**: Use helper methods, extension functions, base classes

**Test Structure**:
```
/Tests
├── Unit/
│   ├── Domain/
│   ├── Application/
│   └── Infrastructure/
└── Integration/
    ├── Api/
    └── Database/
```

**Alternatives Considered**:
- NUnit: Good but xUnit is more modern
- In-memory databases only: Rejected as not production-like
- No integration tests: Rejected due to quality requirements

**References**:
- Microsoft Docs: Integration Tests in ASP.NET Core
- Testcontainers Best Practices for .NET
- ASP.NET Core Integration Testing Best Practises

---

## 10. .NET Monorepo Management

### Decision: .NET Solution (.sln) with Directory.Build.props

**Rationale**: Native .NET tooling provides excellent monorepo support without additional complexity.

**Structure**:
- **Single .sln file** at repository root
- **Directory.Build.props** for shared configuration
- **Each package** is a separate .csproj
- **Package references** between projects via ProjectReference

**Directory.Build.props**:
```xml
<Project>
  <PropertyGroup>
    <LangVersion>latest</LangVersion>
    <Nullable>enable</Nullable>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <TargetFramework>net8.0</TargetFramework>
  </PropertyGroup>
</Project>
```

**Key Practices**:
- **Consistent Versioning**: Shared across all projects
- **Shared Dependencies**: Common NuGet packages defined once
- **EditorConfig**: Consistent code style
- **CI/CD Optimization**: Build only changed projects
- **Package Interdependencies**: Clear, one-way dependencies only

**Alternatives Considered**:
- Nx/Turborepo: Rejected as overkill for .NET
- Multiple solutions: Rejected as complicates development
- No monorepo: Rejected due to project requirements

**References**:
- What I've learnt about monorepos with .NET
- Developing with Multiple Repositories in Single Solution

---

## Implementation Recommendations

### Technology Stack (Confirmed):
- **Language**: C# .NET 8.0 or later
- **Frontend**: Blazor WebAssembly with MudBlazor
- **Backend**: ASP.NET Core Web API
- **Database**: Supabase (via REST API and/or .NET SDK) with abstraction for EF Core
- **Authentication**: ASP.NET Identity with Supabase JWT validation
- **Validation**: FluentValidation
- **Caching**: IMemoryCache + Redis (IDistributedCache)
- **Testing**: xUnit with Testcontainers
- **Build**: .NET CLI / MSBuild with monorepo structure

### Package Structure (Confirmed):
```
packages/
├── [feature]-srv/
│   └── base/
│       ├── Controllers/
│       ├── Services/
│       ├── Models/
│       ├── Repositories/
│       ├── Validators/
│       ├── Exceptions/
│       └── Tests/
├── [feature]-frt/
│   └── base/
│       ├── Components/
│       ├── Pages/
│       ├── Services/
│       └── Tests/
└── [feature]-common/
    └── base/
        ├── Contracts/
        └── Models/
```

### Next Steps:
1. ✅ Research completed
2. → Phase 1: Generate data-model.md and contracts/
3. → Phase 1: Create quickstart.md
4. → Phase 1: Update agent context
5. → Phase 2: Generate tasks.md

---

## References Summary

### Web Research:
- [Clean Architecture Template Blazor Server (GitHub)](https://github.com/neozhu/CleanArchitectureWithBlazorServer)
- [Blazor Performance Tuning (Microsoft Docs)](https://learn.microsoft.com/en-us/aspnet/core/blazor/performance/)
- [Blazor Basics: 9 Best Practices (Telerik)](https://www.telerik.com/blogs/blazor-basics-9-best-practices-building-blazor-web-applications)
- [Microsoft Best Practices (ASP.NET Core)](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/best-practices)
- [Integrating Supabase Auth with .NET](https://www.rodyvansambeek.com/blog/using-supabase-auth-with-dotnet)
- [MudBlazor Official](https://www.mudblazor.com/)
- [FluentValidation Official Docs](https://docs.fluentvalidation.net/)
- [Global Error Handling in ASP.NET Core (Milan Jovanovic)](https://www.milanjovanovic.tech/blog/global-error-handling-in-aspnetcore-8)
- [Caching in ASP.NET Core](https://www.milanjovanovic.tech/blog/caching-in-aspnetcore-improving-application-performance)
- [Rate Limiting Middleware (Microsoft)](https://learn.microsoft.com/en-us/aspnet/core/performance/rate-limit)
- [Integration Tests in ASP.NET Core (Microsoft)](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests)
- [Testcontainers Best Practices](https://www.milanjovanovic.tech/blog/testcontainers-best-practices-dotnet-integration-testing)

### Context7 MCP Documentation:
- [MudBlazor Component Patterns (/mudblazor/mudblazor)](https://context7.com/mudblazor/mudblazor)
- [FluentValidation ASP.NET Integration (/fluentvalidation/fluentvalidation)](https://context7.com/fluentvalidation/fluentvalidation)
- [ASP.NET Core Documentation (/dotnet/aspnetcore.docs)](https://context7.com/dotnet/aspnetcore)

---

**Research Status**: ✅ Complete  
**Next Phase**: Phase 1 - Design & Contracts  
**Date Completed**: 2025-11-17
