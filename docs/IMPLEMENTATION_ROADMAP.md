# Universo Platformo C# - Implementation Roadmap

**Version**: 1.0.0  
**Date**: 2025-11-17  
**Based on**: React Project Analysis (REACT_PROJECT_ANALYSIS.md)  
**Constitution Version**: 1.1.0

## Overview

This roadmap outlines the phased implementation strategy for Universo Platformo C#, based on architectural patterns and lessons learned from the React reference implementation. The approach emphasizes incremental development, with each phase building on the previous one.

## Implementation Philosophy

### Core Principles
1. **Reference-Driven**: Learn from React implementation's successes and failures
2. **Incremental**: Build foundational packages first, then domain-specific features
3. **Pattern Replication**: Apply proven three-entity pattern across domains
4. **Quality First**: Each package must be fully tested before moving forward
5. **Bilingual**: All documentation in English and Russian from day one

### Success Metrics
- Each package independently buildable and testable
- Constitution compliance verified for all code
- Zero circular dependencies between packages
- Complete bilingual documentation
- All tests passing before phase completion

## Phase 1: Foundation (Weeks 1-4)

**Goal**: Establish project infrastructure and shared libraries

**CRITICAL PRE-REQUISITE**: All work in Phase 1 and beyond MUST follow Constitution Principle I - Monorepo Package Architecture (NON-NEGOTIABLE). The `packages/` directory structure is MANDATORY before any feature implementation begins.

### 1.1 Project Setup (Week 1)

**Tasks**:
- [ ] Initialize .NET 8 solution structure
- [ ] Configure Directory.Build.props for shared package versions
- [ ] Set up EditorConfig for C# coding standards
- [ ] **⚠️ CRITICAL: Create `src/packages/` directory structure** (Constitution Principle I)
- [ ] Create `src/shared/` directory (ONLY for infrastructure, NOT features)
- [ ] Configure .gitignore for .NET projects
- [ ] Set up GitHub labels from `.github/instructions/github-labels.md`
- [ ] Create README.md and README-RU.md for root project
- [ ] Add packages/ structure validation to code review checklist

**Deliverables**:
- Working .NET solution
- Build system configured
- **`src/packages/` directory exists and is ready for feature packages**
- **`src/shared/` directory exists for infrastructure only**
- Project documentation (EN/RU)
- Package structure validation checklist

**Acceptance Criteria**:
- `dotnet build` succeeds for entire solution
- All documentation is bilingual with identical structure
- GitHub labels match the instruction file
- **`src/packages/` directory exists and is documented**
- **Validation checklist prevents feature code outside packages/**
- README.md clearly explains packages/ vs shared/ distinction

### 1.2 Shared Infrastructure Packages (Weeks 2-3)

**NOTE**: These packages go in `shared/` NOT `packages/` because they are cross-cutting infrastructure.

#### Universo.Types Package
**Purpose**: Shared DTOs, interfaces, and contracts

**Components**:
- Core interfaces (IEntity, ITimestamped, ISoftDeletable)
- Common DTOs (PagedResult<T>, ApiResponse<T>)
- UPDL type definitions (port from React TypeScript)
- Domain model interfaces

**Structure**:
```
packages/universo-types/
└── base/
    ├── src/
    │   ├── Common/           # Common interfaces and base types
    │   ├── Updl/             # UPDL type definitions
    │   └── Domain/           # Domain-specific interfaces
    ├── Universo.Types.csproj
    └── README.md / README-RU.md
```

**Acceptance Criteria**:
- All types properly documented with XML comments
- No dependencies on other Universo packages
- NuGet package can be referenced by other projects
- Bilingual documentation complete

#### Universo.Utils Package
**Purpose**: Common utility functions and helpers

**Components**:
- String utilities
- Date/time helpers
- JSON serialization helpers
- UPDL processor (port from React)
- Validation helpers

**Structure**:
```
packages/universo-utils/
└── base/
    ├── src/
    │   ├── Text/             # String utilities
    │   ├── Time/             # Date/time helpers
    │   ├── Json/             # JSON utilities
    │   └── Updl/             # UPDL processor
    ├── tests/
    │   └── Universo.Utils.Tests/
    ├── Universo.Utils.csproj
    └── README.md / README-RU.md
```

**Acceptance Criteria**:
- Unit test coverage > 80%
- All public methods documented
- xUnit tests all passing
- Bilingual documentation complete

#### Universo.I18n Package
**Purpose**: Centralized localization resources

**Components**:
- Resource files (.resx) for EN and RU
- IStringLocalizer extensions
- Culture management utilities
- Shared translations for common UI elements

**Structure**:
```
packages/universo-i18n/
└── base/
    ├── src/
    │   ├── Resources/        # .resx files
    │   ├── Extensions/       # IStringLocalizer extensions
    │   └── Culture/          # Culture utilities
    ├── Universo.I18n.csproj
    └── README.md / README-RU.md
```

**Acceptance Criteria**:
- EN and RU resource files complete
- Culture switching working
- Fallback to English when RU not available
- Bilingual documentation complete

#### Universo.Components Package
**Purpose**: Shared Blazor UI components (MudBlazor-based)

**Components**:
- Layout components (MainLayout, NavMenu)
- Common dialogs (ConfirmDialog, MessageDialog)
- Form components (TextInput, SelectInput)
- List components (DataGrid wrapper, Pagination)
- Theme configuration

**Structure**:
```
packages/universo-components/
└── base/
    ├── src/
    │   ├── Layout/           # Layout components
    │   ├── Dialogs/          # Dialog components
    │   ├── Forms/            # Form components
    │   ├── Lists/            # List/table components
    │   └── Themes/           # Theme configurations
    ├── wwwroot/
    │   └── css/              # Component styles
    ├── Universo.Components.csproj
    └── README.md / README-RU.md
```

**Dependencies**:
- MudBlazor
- Universo.I18n

**Acceptance Criteria**:
- All components support both light and dark themes
- Components are responsive (mobile-friendly)
- Documentation includes usage examples
- Blazor component tests using bUnit
- Bilingual documentation complete

### 1.3 Cross-Cutting Infrastructure (Week 3-4)

**Goal**: Implement foundational infrastructure patterns required by all packages

#### Error Handling Infrastructure

**Purpose**: Centralized error handling for consistent error responses and improved debugging

**Components**:
- Global exception middleware
- Standard error response DTOs
- Custom exception hierarchy
- Blazor error boundary components
- Structured logging configuration

**Package**: `Universo.Common` (new shared infrastructure package)

**Structure**:
```
shared/Universo.Common/          # ⚠️ NOTE: In shared/ not packages/ (infrastructure)
├── src/
│   ├── Exceptions/              # Custom exception types
│   │   ├── ValidationException.cs
│   │   ├── NotFoundException.cs
│   │   ├── UnauthorizedException.cs
│   │   └── BusinessLogicException.cs
│   ├── Middleware/              # ASP.NET middleware
│   │   ├── GlobalExceptionMiddleware.cs
│   │   └── RequestLoggingMiddleware.cs
│   ├── DTOs/                    # Common DTOs
│   │   ├── ErrorResponse.cs
│   │   ├── ValidationErrorResponse.cs
│   │   └── ApiResponse.cs
│   ├── Components/              # Blazor components
│   │   └── ErrorBoundary.razor
│   └── Extensions/              # Extension methods
│       ├── ExceptionExtensions.cs
│       └── LoggingExtensions.cs
├── Universo.Common.csproj
└── README.md / README-RU.md
```

**Key Classes**:
```csharp
// ErrorResponse.cs
public class ErrorResponse
{
    public string Message { get; set; }
    public string? Details { get; set; }
    public string? TraceId { get; set; }
    public DateTime Timestamp { get; set; }
    public Dictionary<string, string[]>? ValidationErrors { get; set; }
}

// GlobalExceptionMiddleware.cs
public class GlobalExceptionMiddleware
{
    // Catches all unhandled exceptions
    // Logs with appropriate severity
    // Returns structured ErrorResponse
    // Maps exceptions to HTTP status codes
}
```

**Acceptance Criteria**:
- All unhandled exceptions caught and logged
- Consistent error JSON structure across all endpoints
- HTTP status codes correctly assigned (400, 401, 404, 500, etc.)
- Sensitive information never exposed in production errors
- Correlation IDs for request tracing
- Blazor error boundaries prevent app crashes

#### Validation Pipeline

**Purpose**: Consistent input validation across all API endpoints

**Components**:
- FluentValidation integration
- Validation middleware
- Base validator classes
- Automatic model state validation

**Package**: `Universo.Common` (extends existing package)

**Structure** (additions to Universo.Common):
```
packages/universo-common/base/src/
├── Validators/           # Validation infrastructure
│   ├── BaseValidator.cs
│   ├── ValidationExtensions.cs
│   └── Common validators (EmailValidator, etc.)
├── Attributes/           # Custom validation attributes
│   ├── NotEmptyGuidAttribute.cs
│   └── ValidEnumAttribute.cs
└── Filters/              # Action filters
    └── ValidateModelStateFilter.cs
```

**Example Domain Validator**:
```csharp
// In Universo.Clusters.Srv package
public class CreateClusterDtoValidator : AbstractValidator<CreateClusterDto>
{
    public CreateClusterDtoValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Cluster name is required")
            .MaximumLength(255).WithMessage("Name cannot exceed 255 characters");
            
        RuleFor(x => x.Description)
            .MaximumLength(1000)
            .When(x => x.Description != null);
    }
}
```

**Acceptance Criteria**:
- Validation executes before controller actions
- Validation errors returned in standardized ErrorResponse format
- 100% DTO coverage with validators in domain packages
- Client-side and server-side validation consistent
- Validation rules testable in isolation
- Fluent API provides clear, readable rules

#### Caching Infrastructure

**Purpose**: Improve performance through strategic caching

**Components**:
- Memory cache configuration
- Redis distributed cache setup
- Cache service abstraction
- Cache-aside pattern helpers

**Package**: `Universo.Common` (extends existing shared infrastructure package)

**Structure** (additions to Universo.Common in shared/):
```
shared/Universo.Common/src/     # ⚠️ NOTE: In shared/ not packages/
├── Caching/
│   ├── ICacheService.cs          # Cache abstraction
│   ├── CacheService.cs           # Implementation
│   ├── CacheKeys.cs              # Key naming conventions
│   ├── CacheOptions.cs           # Configuration options
│   └── Extensions/
│       └── CacheExtensions.cs    # Helper methods
└── Configuration/
    └── CacheConfiguration.cs     # Startup configuration
```

**Configuration**:
```csharp
// appsettings.json
{
  "Caching": {
    "Redis": {
      "Configuration": "localhost:6379",
      "InstanceName": "Universo:"
    },
    "DefaultTTL": {
      "ReferenceData": 3600,      // 1 hour
      "UserData": 900,             // 15 minutes
      "SessionData": 1800          // 30 minutes
    }
  }
}

// ICacheService.cs
public interface ICacheService
{
    Task<T?> GetAsync<T>(string key, CancellationToken cancellationToken = default);
    Task SetAsync<T>(string key, T value, TimeSpan? ttl = null, CancellationToken cancellationToken = default);
    Task RemoveAsync(string key, CancellationToken cancellationToken = default);
    Task RemoveByPatternAsync(string pattern, CancellationToken cancellationToken = default);
}
```

**Acceptance Criteria**:
- Both memory and distributed cache configured
- Cache keys follow naming convention: `{package}:{entity}:{id}`
- TTL appropriately configured per data type
- Cache invalidation strategy documented
- Performance tests show measurable caching benefit
- Cache hit/miss metrics tracked

#### Rate Limiting

**Purpose**: Protect APIs from abuse and ensure fair usage

**Components**:
- IP-based rate limiting
- User-based rate limiting
- Configurable limit policies
- Rate limit response headers

**Package**: Uses AspNetCoreRateLimit NuGet package

**Configuration**:
```csharp
// appsettings.json
{
  "IpRateLimiting": {
    "EnableEndpointRateLimiting": true,
    "StackBlockedRequests": false,
    "RealIpHeader": "X-Real-IP",
    "HttpStatusCode": 429,
    "GeneralRules": [
      {
        "Endpoint": "*:/api/*",
        "Period": "15m",
        "Limit": 100
      },
      {
        "Endpoint": "*:/api/auth/*",
        "Period": "1h",
        "Limit": 20
      }
    ]
  },
  "ClientRateLimiting": {
    "EnableEndpointRateLimiting": true,
    "GeneralRules": [
      {
        "Endpoint": "*",
        "Period": "1h",
        "Limit": 1000
      }
    ]
  }
}

// Program.cs setup
builder.Services.AddMemoryCache();
builder.Services.Configure<IpRateLimitOptions>(builder.Configuration.GetSection("IpRateLimiting"));
builder.Services.Configure<ClientRateLimitOptions>(builder.Configuration.GetSection("ClientRateLimiting"));
builder.Services.AddInMemoryRateLimiting();
builder.Services.AddSingleton<IRateLimitConfiguration, RateLimitConfiguration>();

app.UseIpRateLimiting();
app.UseClientRateLimiting();
```

**Acceptance Criteria**:
- Rate limits enforced on all public APIs
- Appropriate HTTP 429 (Too Many Requests) responses
- Rate limit headers included (X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset)
- Different limits for anonymous vs authenticated users
- Admin endpoints can be exempt from rate limiting
- Rate limiting configuration testable

**Deliverables for Section 1.3**:
- Universo.Common package with error handling, validation, caching
- Global exception middleware configured
- FluentValidation integrated
- Redis distributed cache configured
- Rate limiting configured and tested
- Structured logging with Serilog
- Health check endpoints
- Documentation for all infrastructure patterns

**Total Time Estimate**: 2 weeks (overlaps with week 3-4)

### 1.4 Authentication System (Week 4)

#### Universo.Auth.Srv Package
**Purpose**: Backend authentication service

**Components**:
- ASP.NET Core Identity integration
- Supabase connector for Identity
- JWT bearer authentication
- Session management
- Password reset functionality
- Email verification

**Structure**:
```
packages/universo-auth-srv/
└── base/
    ├── src/
    │   ├── Identity/         # Identity configuration
    │   ├── Supabase/         # Supabase integration
    │   ├── Jwt/              # JWT handling
    │   ├── Controllers/      # Auth controllers
    │   └── Services/         # Auth services
    ├── tests/
    │   └── Universo.Auth.Srv.Tests/
    ├── Universo.Auth.Srv.csproj
    └── README.md / README-RU.md
```

**Acceptance Criteria**:
- Login/logout working with JWT
- Supabase integration functional
- Password reset flow complete
- Integration tests for all endpoints
- Bilingual documentation complete

#### Universo.Auth.Frt Package
**Purpose**: Frontend authentication components

**Components**:
- LoginForm component
- RegisterForm component
- PasswordResetForm component
- SessionGuard component
- AuthenticationStateProvider

**Structure**:
```
packages/universo-auth-frt/
└── base/
    ├── src/
    │   ├── Components/       # Auth UI components
    │   ├── Services/         # Auth state management
    │   └── Providers/        # AuthenticationStateProvider
    ├── wwwroot/
    │   └── css/              # Auth component styles
    ├── Universo.Auth.Frt.csproj
    └── README.md / README-RU.md
```

**Dependencies**:
- Universo.Components
- Universo.I18n
- Universo.Auth.Srv (for DTOs)

**Acceptance Criteria**:
- Login/logout UI working
- Token refresh automatic
- Session persistence across page reloads
- Mobile-friendly responsive design
- Bilingual UI labels
- Bilingual documentation complete

## Phase 2: Core Domain Implementation (Weeks 5-8)

**Goal**: Implement first complete domain using three-entity pattern as reference

### 2.1 Clusters Domain (Weeks 5-6)

**Why Clusters First?**
The React implementation shows Clusters as a mature, well-structured domain that exemplifies the three-entity pattern. It will serve as the reference implementation for all future domains.

#### Universo.Clusters.Srv Package

**Entities**:
1. **Cluster** (Top-level) - Container for domains
2. **Domain** (Mid-level) - Logical grouping within cluster
3. **Resource** (Bottom-level) - Individual items

**Structure**:
```
packages/universo-clusters-srv/
└── base/
    ├── src/
    │   ├── Data/
    │   │   ├── Entities/     # EF Core entities
    │   │   ├── Migrations/   # EF migrations
    │   │   └── ClusterDbContext.cs
    │   ├── Repositories/     # Repository pattern
    │   ├── Services/         # Business logic
    │   ├── Controllers/      # API controllers
    │   └── Dto/              # Data transfer objects
    ├── tests/
    │   └── Universo.Clusters.Srv.Tests/
    ├── Universo.Clusters.Srv.csproj
    └── README.md / README-RU.md
```

**API Endpoints**:
- `GET /api/clusters` - List clusters
- `POST /api/clusters` - Create cluster
- `GET /api/clusters/{id}` - Get cluster details
- `PUT /api/clusters/{id}` - Update cluster
- `DELETE /api/clusters/{id}` - Delete cluster
- Similar endpoints for domains and resources

**Acceptance Criteria**:
- Full CRUD operations for all three entities
- Entity Framework migrations working
- Repository pattern implemented
- Integration tests for all endpoints
- Swagger/OpenAPI documentation
- Bilingual documentation complete

#### Universo.Clusters.Frt Package

**Components**:
- ClusterList page
- ClusterDetail page
- ClusterForm dialog
- DomainList component
- ResourceList component

**Structure**:
```
packages/universo-clusters-frt/
└── base/
    ├── src/
    │   ├── Pages/            # Page components
    │   ├── Components/       # Reusable components
    │   ├── Services/         # API client services
    │   └── Models/           # View models
    ├── wwwroot/
    │   ├── css/              # Styles
    │   └── i18n/             # Translations (EN/RU)
    ├── Universo.Clusters.Frt.csproj
    └── README.md / README-RU.md
```

**Acceptance Criteria**:
- All CRUD operations working in UI
- Responsive design (mobile/desktop)
- Loading states implemented
- Error handling with user feedback
- Bilingual UI (EN/RU)
- Bilingual documentation complete

### 2.2 Uniks (Workspaces) Domain (Weeks 7-8)

**Purpose**: Workspace management (equivalent to React's Uniks)

**Entities**:
1. **Unik** (Workspace - Top-level)
2. **UserUnik** (User-workspace association)
3. **Permissions** (Access control)

**Implementation**:
Similar structure to Clusters but with user association logic.

**Special Features**:
- Multi-user workspaces
- Role-based access control
- Workspace invitations
- Workspace switching in UI

**Acceptance Criteria**:
- Users can create/manage workspaces
- Multiple users can share a workspace
- Permissions enforced on backend
- Workspace switcher in UI
- Bilingual documentation complete

## Phase 3: Advanced Features (Weeks 9-12)

### 3.1 Profile Management (Week 9)

**Packages**:
- Universo.Profile.Srv - User profile API
- Universo.Profile.Frt - Profile UI

**Features**:
- Email/password updates
- Profile information management
- Avatar upload
- Account settings

### 3.2 Metaverses Domain (Week 10)

**Purpose**: Replicate three-entity pattern with different naming

**Entities**:
1. **Metaverse** (Top-level)
2. **Section** (Mid-level)
3. **Entity** (Bottom-level)

**Goal**: Demonstrate pattern reusability

### 3.3 Spaces and Canvases (Week 11-12)

**Purpose**: Visual canvas editor foundation

**Packages**:
- Universo.Spaces.Srv - Canvas management API
- Universo.Spaces.Frt - Visual editor (Blazor.Diagrams)

**Features**:
- Node-based visual editor
- Save/load canvas state
- Basic node types
- Connection validation

## Phase 4: UPDL and Templates (Weeks 13-16)

### 4.1 UPDL System (Weeks 13-14)

**Packages**:
- Universo.Updl - UPDL node definitions and processor

**Components**:
- Node type definitions (ported from React)
- UPDL processor
- Validation system
- Serialization/deserialization

### 4.2 Template System (Weeks 15-16)

**Packages**:
- Universo.Template.Quiz - AR.js quiz template
- Universo.Template.Mmoomm - PlayCanvas MMO template

**Features**:
- Template registry system
- UPDL to target platform conversion
- Template-specific builders

## Phase 5: Publishing and AI (Weeks 17-20)

### 5.1 Publication System (Weeks 17-18)

**Packages**:
- Universo.Publish.Srv - Publication API
- Universo.Publish.Frt - Publication UI

**Features**:
- Export to various formats
- Public URL generation
- Asset management
- CDN integration

### 5.2 Space Builder AI (Weeks 19-20)

**Packages**:
- Universo.SpaceBuilder.Srv - Prompt-to-flow API
- Universo.SpaceBuilder.Frt - Prompt UI

**Features**:
- Integration with Azure OpenAI or Semantic Kernel
- Prompt to UPDL graph conversion
- Validation and normalization
- Append/replace modes

## Phase 6: Multiplayer and Analytics (Weeks 21-24)

### 6.1 Multiplayer Infrastructure (Weeks 21-22)

**Package**:
- Universo.Multiplayer.Srv - SignalR-based multiplayer

**Features**:
- Room/lobby system
- State synchronization
- Player management
- Entity replication

### 6.2 Analytics (Weeks 23-24)

**Packages**:
- Universo.Analytics.Srv - Analytics API
- Universo.Analytics.Frt - Analytics dashboard

**Features**:
- Quiz results tracking
- Usage metrics
- Data visualization
- Reports generation

## Quality Assurance Throughout All Phases

### Testing Requirements
- Unit tests for all services and utilities
- Integration tests for all API endpoints
- Component tests for all Blazor components
- End-to-end tests for critical user flows

### Documentation Requirements
- XML documentation for all public APIs
- README files (EN/RU) for each package
- Architecture decision records (ADRs) for major decisions
- API documentation (Swagger/OpenAPI)

### Code Quality
- Follow C# coding conventions
- EditorConfig enforcement
- Code review for all PRs
- Constitution compliance verification

## Risk Management

### Technical Risks
- **Entity Framework Performance**: Monitor query performance, implement caching
- **Blazor WASM Size**: Lazy loading, code splitting
- **Supabase Limitations**: Plan migration path to standalone PostgreSQL

### Process Risks
- **Scope Creep**: Stick to phased approach, defer nice-to-haves
- **React Project Changes**: Weekly monitoring, monthly sync meetings
- **Documentation Drift**: Automated checks for bilingual documentation

## Success Criteria

### Phase Completion
Each phase considered complete when:
- All planned packages implemented
- All tests passing (>80% coverage)
- Documentation complete (EN/RU)
- Constitution compliance verified
- Code reviewed and merged

### Project Success
Overall project considered successful when:
- All 6 phases completed
- Feature parity with React implementation core features
- Zero critical bugs
- Performance benchmarks met
- Community documentation published

## Monitoring and Adaptation

### Weekly Reviews
- Progress against roadmap
- Blockers and risks
- Quality metrics
- React project changes

### Monthly Reviews
- Phase completion status
- Constitution amendments needed
- Roadmap adjustments
- Stakeholder feedback

### Quarterly Reviews
- Overall project health
- Technology stack evaluation
- Resource allocation
- Long-term strategy alignment

## Appendix A: Package Dependency Graph

```
Universo.Types
    ↑
Universo.Utils ← Universo.I18n
    ↑               ↑
Universo.Components
    ↑
Universo.Auth.Frt → Universo.Auth.Srv
    ↑
Domain Packages (Clusters, Uniks, etc.)
    ↑
Advanced Features (UPDL, Templates, Publish)
```

## Appendix B: Technology Stack Summary

| Category | Technology | Version | Purpose |
|----------|-----------|---------|---------|
| Framework | .NET | 8+ | Core framework |
| Frontend | Blazor WebAssembly | Latest | UI framework |
| Backend | ASP.NET Core | 8+ | API framework |
| UI Library | MudBlazor | Latest | Material Design components |
| ORM | Entity Framework Core | 8+ | Database access |
| Database | PostgreSQL | 14+ | Primary database |
| Supabase | supabase-csharp | Latest | Auth and initial DB |
| Testing | xUnit, bUnit | Latest | Unit and component testing |
| API Docs | Swashbuckle | Latest | OpenAPI/Swagger |
| Real-time | SignalR | Latest | WebSocket communication |
| AI | Semantic Kernel | Latest | LLM orchestration |

## Appendix C: Reference Documents

- **Constitution**: `.specify/memory/constitution.md` (v1.1.0)
- **React Analysis**: `REACT_PROJECT_ANALYSIS.md`
- **GitHub Issues Guide**: `.github/instructions/github-issues.md`
- **GitHub PR Guide**: `.github/instructions/github-pr.md`
- **GitHub Labels**: `.github/instructions/github-labels.md`
- **i18n Guide**: `.github/instructions/i18n-docs.md`

---

**Document Version**: 1.0.0  
**Last Updated**: 2025-11-17  
**Next Review**: 2025-12-01  
**Maintained By**: Project Team
