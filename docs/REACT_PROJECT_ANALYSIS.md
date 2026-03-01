# Universo Platformo React - Architectural Analysis for C# Implementation

**Date**: 2025-11-16  
**Purpose**: Deep analysis of the React source project to identify architectural patterns and concepts for C# implementation  
**Source**: https://github.com/teknokomo/universo-platformo-react

## Executive Summary

This document provides a comprehensive analysis of the Universo Platformo React project architecture, identifying key patterns, concepts, and best practices that should be adapted for the C# implementation. The React project is built on Flowise AI 2.2.8 with extensive custom packages following a monorepo structure.

## Core Architecture Patterns

### 1. Monorepo Package Organization

**React Implementation:**
- **Package Manager**: PNPM with workspace configuration (`pnpm-workspace.yaml`)
- **Total Packages**: 37 packages in the `packages/` directory
- **Package Structure**: All packages follow the `base/` directory pattern for future multi-implementation support
- **Build System**: Mix of tsdown (modern, 26 packages) and legacy tsc+gulp (2 packages)
- **Workspace Catalog**: Centralized dependency version management in `pnpm-workspace.yaml`

**C# Adaptation Requirements:**
- Use .NET solution/workspace structure as C# equivalent to PNPM workspaces
- Implement NuGet package management with centralized version control (Directory.Build.props)
- Consider using dotnet-tools.json for tool versioning
- Maintain the `base/` directory pattern in each package for consistency

### 2. Frontend/Backend Package Separation Pattern

**React Implementation:**
The project uses a clear naming convention for package separation:

**Frontend Packages** (suffix: `-frt`):
- `analytics-frt` - Quiz analytics UI
- `auth-frt` - Authentication UI primitives
- `clusters-frt` - Cluster management UI
- `metaverses-frt` - Metaverse management UI
- `profile-frt` - User profile UI
- `publish-frt` - Publication system UI
- `space-builder-frt` - Space builder UI (prompt-to-flow)
- `spaces-frt` - Spaces/Canvases UI
- `uniks-frt` - Workspace management UI

**Backend Packages** (suffix: `-srv`):
- `auth-srv` - Passport.js + Supabase authentication
- `clusters-srv` - Cluster management API
- `metaverses-srv` - Metaverse management API
- `profile-srv` - User profile API
- `publish-srv` - Publication system API
- `space-builder-srv` - Space builder API
- `spaces-srv` - Spaces domain API
- `uniks-srv` - Workspace management API
- `multiplayer-colyseus-srv` - Colyseus multiplayer server

**C# Adaptation:**
- Maintain the `-frt`/`-srv` suffix convention
- Frontend: Blazor WebAssembly components in `packages/*-frt/`
- Backend: ASP.NET Core services in `packages/*-srv/`
- Each package should be independently deployable

### 3. Three-Entity Pattern (Core Domain Model)

**Identified Pattern:**
Multiple domain areas follow a consistent three-entity hierarchical structure:

**Clusters Domain** (Primary Example):
1. **Clusters** (Top-level container)
2. **Domains** (Mid-level grouping)
3. **Resources** (Bottom-level items)

**Metaverses Domain** (Same Pattern):
1. **Metaverses** (Top-level container)
2. **Sections** (Mid-level grouping)
3. **Entities** (Bottom-level items)

**Uniks Domain** (Workspace Pattern):
1. **Uniks** (Workspaces - top-level)
2. **Spaces/Canvases** (Projects within workspace)
3. **Nodes/Components** (Elements within spaces)

**Pattern Benefits:**
- Consistent API design across domains
- Reusable UI components with different entity names
- Predictable database schema design
- Easy to replicate for new domains

**C# Implementation Notes:**
- Create generic base classes for the three-entity pattern
- Use C# generics for type-safe implementations
- Implement shared CRUD operations as base repository classes
- Create abstract base controllers for ASP.NET

### 4. Shared Infrastructure Packages

**React Implementation:**
The project includes several shared packages used across frontend and backend:

**Type System:**
- `universo-types` - Shared TypeScript interfaces and types
- Contains UPDL interfaces, platform types
- Dual build: CJS + ESM + Types

**Utilities:**
- `universo-utils` - Shared utility functions
- UPDLProcessor for flow data conversion
- Template-agnostic processing

**API Client:**
- `universo-api-client` - Type-safe API clients
- Axios-based HTTP communication
- Request/response type definitions

**Internationalization:**
- `universo-i18n` - Centralized i18next instance
- Shared translation management
- Namespace support for modular translations

**REST Documentation:**
- `universo-rest-docs` - OpenAPI/Swagger specs
- Interactive API documentation

**C# Adaptation:**
- `Universo.Types` - Shared C# interfaces, DTOs, contracts
- `Universo.Utils` - Common utility classes
- `Universo.ApiClient` - Typed HttpClient wrappers
- `Universo.I18n` - Resource-based localization
- Use Swashbuckle for REST documentation

### 5. UI Component Library Architecture

**React Implementation:**

**Core MUI Template:**
- `flowise-template-mui` - Extracted MUI components (unbundled source pattern)
- Large build output: 17MB CJS, 5.2MB ESM, 5KB types
- Components: Layout, Dialogs, Forms, Cards, Pagination
- Theme configurations and customizations

**Universo MUI Template:**
- `universo-template-mui` - Platform-specific MUI implementation
- Reusable layout components
- Consistent theme configurations

**Chat Components:**
- `flowise-chatmessage` - 7 reusable chat components
- Streaming, audio recording, file upload support
- Eliminated ~7692 lines of duplication

**State Management:**
- `flowise-store` - Shared Redux store
- Centralized state management
- Redux Toolkit integration

**C# Adaptation:**
- Use MudBlazor (Material Design for Blazor) or similar
- Create `Universo.Components` package for shared Blazor components
- Implement Blazor layouts and themes
- Use Blazor state management (Fluxor or similar for Redux pattern)
- Create reusable Razor class libraries

### 6. Authentication Architecture

**React Implementation:**

**Frontend (`auth-frt`):**
- LoginForm, SessionGuard components
- React hooks for authentication state
- Session-based authentication UI
- Integration with Supabase auth

**Backend (`auth-srv`):**
- Passport.js strategies (local, JWT)
- Supabase session management
- Session middleware for Express
- Login, logout, session validation routes

**C# Adaptation:**
- Frontend: Blazor authentication components
- Use AuthenticationStateProvider in Blazor
- Backend: ASP.NET Core Identity
- Implement Supabase connector for Identity
- JWT bearer authentication middleware
- Session management with distributed cache (Redis)

### 7. Template System Architecture

**React Implementation:**

**Template Registry Pattern:**
The project uses specialized template packages for different technologies:

**Quiz Template (`template-quiz`):**
- AR.js Integration for educational quizzes
- Multi-scene quiz support
- Lead collection forms
- Points system and scoring
- Modular architecture with separate handlers

**MMOOMM Template (`template-mmoomm`):**
- PlayCanvas space MMO implementation
- 3D space simulation with physics
- Industrial mining, entity system
- Multiplayer support with Colyseus
- Advanced quaternion-based controls

**Template Characteristics:**
- Self-contained implementations
- Dual build system (CJS + ESM + Types)
- UPDL node integration
- Technology-specific builders

**C# Adaptation:**
- Create `Universo.Templates.Quiz` package
- Create `Universo.Templates.Mmoomm` package
- Use strategy pattern for template selection
- Implement template registry with dependency injection
- Support for future templates (Unity, Unreal, etc.)

### 8. UPDL (Universal Platform Description Language)

**React Implementation:**

**UPDL Package (`updl`):**
- 7 core high-level nodes for universal 3D/AR/VR scene description
- Legacy nodes (Object, Camera, Light) for backward compatibility
- Node definitions with icons and metadata
- TypeScript interfaces for type safety
- Pure Flowise integration

**UPDL Interfaces:**
- `UPDLInterfaces.ts` - Complete ecosystem definitions
- `Interface.UPDL.ts` - Simplified integration interfaces
- Flow, graph, and node property definitions

**UPDL Processor:**
- Located in `universo-utils`
- Converts flow data to UPDL structures
- Multi-scene support
- Template-agnostic processing

**C# Adaptation:**
- Create `Universo.Updl` package with node definitions
- Implement C# interfaces for UPDL types
- Create UPDL processor service
- Support for visual node editor integration
- JSON serialization for UPDL structures

### 9. Publication and Export System

**React Implementation:**

**Publish Frontend (`publish-frt`):**
- Client-side UPDL processing
- Template registry system
- Dynamic template package loading
- Shared type system integration
- Supabase integration for persistence
- Multi-technology support (AR.js, PlayCanvas)

**Publish Backend (`publish-srv`):**
- Workspace package architecture
- Raw data provider (serves flowData)
- Delegates UPDL processing to frontend
- Source of truth for types
- Asynchronous route initialization

**Publication Flow:**
```
Flowise Editor → UPDL Nodes → Publish Frontend → Template Builder → Public URL
                                     ↓
                              Publish Backend (Data Provider)
```

**C# Adaptation:**
- Frontend: Blazor WebAssembly publication UI
- Backend: ASP.NET Core publication API
- Implement UPDL processor on backend for security
- Consider server-side rendering for published content
- Azure/AWS storage for published assets
- CDN integration for public URLs

### 10. Multiplayer Infrastructure

**React Implementation:**

**Colyseus Server (`multiplayer-colyseus-srv`):**
- Room implementations for MMO experiences
- State synchronization
- Player connection management
- Entity replication (ships, asteroids, projectiles)
- Integration with template-mmoomm

**C# Adaptation:**
- Consider SignalR for real-time communication
- Alternative: Port Colyseus concepts to C#
- Implement room/lobby system
- Use ASP.NET Core for WebSocket management
- State synchronization with message packs
- Integration with Unity/Unreal for multiplayer

### 11. Database Architecture

**React Implementation:**

**ORM**: TypeORM 0.3.20+
**Database**: PostgreSQL (via Supabase)
**Entity Management**:
- Each domain package has its own entities
- Migration files per package
- Entity registration system
- Nested route mounting (e.g., `/:unikId` prefix)

**Security**:
- SQL functions with `SECURITY DEFINER`
- Row-level security policies
- Supabase integration for auth

**Example Entity Structure** (from packages):
```
packages/uniks-srv/base/
  └── src/
      └── database/
          ├── entities/
          │   ├── Unik.ts
          │   └── UserUnik.ts
          └── migrations/
              └── *.ts
```

**C# Adaptation:**
- Entity Framework Core as primary ORM
- PostgreSQL provider (Npgsql.EntityFrameworkCore.PostgreSQL)
- Support for Supabase with Supabase C# client
- One DbContext per domain package or shared context
- Code-first migrations per package
- Repository pattern with generic base
- Use ASP.NET Core Identity for user management
- Implement row-level security via EF query filters

### 12. Build System Evolution

**React Implementation:**

**Modern Build (tsdown - 26 packages):**
- Rolldown + Oxc based bundler
- Dual output: CJS + ESM + Types
- Faster build times
- Automatic asset handling
- Simplified configuration

**Packages using tsdown:**
- All shared infrastructure (`universo-types`, `universo-utils`, `universo-api-client`)
- All frontend domain packages (`*-frt`)
- Authentication packages
- Template packages
- UPDL package

**Legacy Build (tsc + gulp - 2 packages):**
- `profile-frt` - Has gulpfile.ts for asset copying
- `publish-frt` - Has gulpfile.ts for asset copying
- Slower build process
- Manual asset handling
- More complex configuration

**C# Adaptation:**
- Use standard .NET SDK build system (MSBuild)
- Leverage dotnet CLI for builds
- Consider using Cake or NUKE for complex build orchestration
- Implement watch mode for development (`dotnet watch`)
- Use MSBuild targets for custom build steps
- NuGet packaging for shared libraries

### 13. Internationalization Strategy

**React Implementation:**

**Centralized i18n:**
- `universo-i18n` package with shared i18next instance
- Translation files organized by namespace
- Language detection and switching
- Support for English and Russian

**Per-Package i18n:**
- Each package has its own `i18n/` directory
- Translation resources loaded on demand
- Namespace isolation prevents conflicts

**Bilingual Documentation:**
- All READMEs in English and Russian
- Format: `README.md` (English) + `README-RU.md` (Russian)
- Identical structure and line count
- GitHub Issues/PRs include Russian in spoiler tags

**C# Adaptation:**
- Use .NET Resource (`.resx`) files
- Create `Universo.I18n` package with shared resources
- Implement `IStringLocalizer<T>` pattern
- Support for English (en) and Russian (ru) cultures
- Blazor localization middleware
- Maintain bilingual documentation (README.md / README-RU.md)

### 14. Space Builder (Prompt-to-Flow AI)

**React Implementation:**

**Frontend (`space-builder-frt`):**
- MUI dialog + FAB for prompt input
- Model selection from Credentials
- Test mode support
- Append/Replace modes on canvas
- i18n integration

**Backend (`space-builder-srv`):**
- Endpoints: `/health`, `/config`, `/generate`
- Meta-prompt → LLM call → RAW JSON extraction
- Credential resolution integrated with platform
- Zod-based validation
- Server-side normalization

**Flow:**
```
User Prompt → Space Builder Dialog → API Call → LLM Processing
     ↓
Meta-prompt Construction → Provider Call → JSON Extraction
     ↓
Validation → Normalization → UPDL Graph → Canvas
```

**C# Adaptation:**
- Blazor dialog component for prompt input
- ASP.NET Core API endpoints
- Integration with OpenAI SDK or similar
- Use FluentValidation or Data Annotations for validation
- JSON schema validation
- Integration with Semantic Kernel (Microsoft's LLM framework)

### 15. Async Route Initialization Pattern

**React Implementation:**

**Problem Addressed:**
Prevents race conditions when routes depend on database connections or other async resources.

**Implementation** (from multiple `-srv` packages):
```typescript
// Async route factory
export const createRoutes = async (app: Express, db: Connection) => {
    // Database-dependent route setup
    app.get('/api/v1/resource', async (req, res) => {
        // Use db connection
    });
};

// Server initialization
const db = await establishConnection();
await createRoutes(app, db);
app.listen(port);
```

**Packages Using This Pattern:**
- `profile-srv` - Asynchronous route initialization
- `publish-srv` - Wait for DB connection before routes
- `space-builder-srv` - Async initialization

**C# Adaptation:**
- Use ASP.NET Core hosted services for initialization
- Implement `IHostedService` for database setup
- Use health checks to verify readiness
- Leverage dependency injection container
- Consider using `IStartupFilter` for route configuration
```csharp
public class DatabaseInitializer : IHostedService
{
    public async Task StartAsync(CancellationToken cancellationToken)
    {
        await EnsureDatabase();
        await RunMigrations();
    }
}
```

### 16. Node-Based Visual Editor Integration

**React Implementation:**

**Core Editor:**
- React Flow for node-based canvas
- Custom node types for UPDL
- Drag-and-drop interface
- Connection validation
- State persistence

**UPDL Node Integration:**
- Each UPDL node type has:
  - Icon (SVG assets)
  - Input/output definitions
  - Property schema
  - Validation rules
  - Display component

**Node Properties:**
- Dynamic property panels
- Type-specific editors
- Real-time validation
- Default values

**C# Adaptation:**
- Consider Blazor Diagram library (Blazor.Diagrams)
- Custom Blazor components for nodes
- SignalR for real-time collaboration
- Server-side validation of connections
- Property editor system with Blazor forms

### 17. Error Handling and Validation

**React Implementation:**

**Validation Libraries:**
- Zod for schema validation (especially in space-builder-srv)
- React Hook Form for frontend form validation
- TypeScript for compile-time type checking

**Error Handling:**
- `http-errors` package for standardized HTTP errors
- Centralized error handling middleware
- Type-safe error responses

**C# Adaptation:**
- FluentValidation for validation rules
- Data Annotations for simple validations
- Problem Details (RFC 7807) for error responses
- Custom exception filters in ASP.NET Core
- Middleware for global exception handling

### 18. Testing Infrastructure

**React Implementation:**

**Testing Tools:**
- Vitest for unit testing
- Testing Library (React)
- Happy DOM for DOM testing
- Jest DOM for assertions

**Test Organization:**
- Tests co-located with source code
- Integration tests for API endpoints
- Component tests for UI

**C# Adaptation:**
- xUnit or NUnit for unit testing
- Integration tests with WebApplicationFactory
- Blazor component testing with bUnit
- Moq or NSubstitute for mocking
- SpecFlow for BDD if needed

### 19. CI/CD and Deployment

**React Implementation:**

**Build Tools:**
- Turborepo for monorepo builds
- PNPM for dependency management
- Docker support (Dockerfile present)

**Environment Configuration:**
- `.env` files for secrets
- Separate configs for frontend/backend
- Supabase configuration management

**C# Adaptation:**
- Azure DevOps or GitHub Actions for CI/CD
- Docker multi-stage builds for deployment
- Azure App Configuration or environment variables
- Separate appsettings.json per environment
- User secrets for local development

### 20. Rate Limiting and Security

**React Implementation:**

**Rate Limiting:**
- `express-rate-limit` package
- `rate-limit-redis` for distributed limiting
- `ioredis` for Redis connection
- `async-mutex` for concurrency control

**Security Measures:**
- Passport.js authentication
- Supabase row-level security
- CORS configuration
- SQL injection prevention via ORM

**C# Adaptation:**
- ASP.NET Core rate limiting middleware (built-in .NET 7+)
- Redis-based distributed caching
- CORS policies configuration
- ASP.NET Core Data Protection
- SQL injection prevention via Entity Framework
- OWASP security headers middleware

## Key Differences and Adaptation Strategies

### JavaScript/TypeScript → C#

| React Aspect | C# Equivalent | Adaptation Notes |
|--------------|---------------|------------------|
| PNPM workspaces | .NET Solution | Use solution-level Directory.Build.props |
| TypeScript | C# with nullable reference types | Leverage C# type safety |
| Express.js | ASP.NET Core | Controllers, minimal APIs, middleware |
| React | Blazor WebAssembly | Component-based UI |
| TypeORM | Entity Framework Core | Code-first or DB-first approach |
| i18next | .NET Resources | `IStringLocalizer<T>` pattern |
| Passport.js | ASP.NET Identity | Built-in authentication framework |
| Redux | Fluxor or MediatR | State management in Blazor |
| Axios | HttpClient | Typed HttpClient with DI |
| Zod | FluentValidation | Fluent validation rules |

### Package Naming Conventions

**Consistency Requirement:**
Maintain the same naming patterns from React to C# for cross-project clarity:

| Pattern | React Example | C# Equivalent |
|---------|---------------|---------------|
| Frontend | `@universo/clusters-frt` | `Universo.Clusters.Frt` |
| Backend | `@universo/clusters-srv` | `Universo.Clusters.Srv` |
| Shared | `@universo/types` | `Universo.Types` |
| Templates | `@universo/template-quiz` | `Universo.Template.Quiz` |

## Missing Implementations in React (To Avoid in C#)

### 1. Legacy Flowise Code
**Issue**: React project still contains Flowise legacy code not fully refactored.
**Packages Affected**: `flowise-*` packages scheduled for removal
**C# Strategy**: Start fresh without legacy code; implement only needed functionality.

### 2. Documentation in `docs/` Folder
**Issue**: React project has docs in repository (will be moved to separate repo).
**C# Strategy**: Don't create `docs/` folder; keep documentation external or in wiki.

### 3. Inconsistent Build Systems
**Issue**: Mix of tsdown and gulp builds causing maintenance overhead.
**C# Strategy**: Use consistent .NET build system across all packages.

### 4. Some AI Agent Configuration Files
**Issue**: AI agent configs created automatically; users should create manually.
**C# Strategy**: Don't auto-generate AI config files unless explicitly requested.

## Recommended Implementation Order for C#

### Phase 1: Foundation (Current Sprint)
1. **Project Setup**
   - Initialize .NET solution structure
   - Configure NuGet packages and versioning
   - Set up Directory.Build.props for shared configuration
   - Create base README files (EN + RU)
   - Configure GitHub labels, issues, PR templates

2. **Shared Infrastructure**
   - `Universo.Types` - Core DTOs, interfaces, contracts
   - `Universo.Utils` - Common utilities
   - `Universo.I18n` - Localization resources
   - `Universo.Components` - Shared Blazor components (MudBlazor)

3. **Authentication System**
   - `Universo.Auth.Srv` - ASP.NET Identity + Supabase
   - `Universo.Auth.Frt` - Blazor authentication components
   - Session management
   - JWT bearer tokens

### Phase 2: Core Domain Implementation
4. **Clusters Domain** (Three-Entity Pattern Reference)
   - `Universo.Clusters.Srv` - Backend API
   - `Universo.Clusters.Frt` - Blazor UI
   - Implement full CRUD for Clusters → Domains → Resources
   - Database migrations
   - Unit and integration tests

5. **Uniks (Workspaces)**
   - `Universo.Uniks.Srv` - Workspace management API
   - `Universo.Uniks.Frt` - Workspace UI
   - User-workspace associations

6. **Profile Management**
   - `Universo.Profile.Srv` - User profile API
   - `Universo.Profile.Frt` - Profile UI
   - Email/password updates
   - Security functions

### Phase 3: Advanced Features
7. **Metaverses Domain**
   - Replicate three-entity pattern
   - Metaverses → Sections → Entities

8. **Spaces and Canvases**
   - `Universo.Spaces.Srv` - Canvas management API
   - `Universo.Spaces.Frt` - Visual canvas editor (Blazor Diagrams)
   - Node-based editor integration

9. **UPDL System**
   - `Universo.Updl` - UPDL node definitions
   - UPDL processor
   - Node validation system

10. **Space Builder (AI)**
    - `Universo.SpaceBuilder.Srv` - Prompt-to-flow API
    - `Universo.SpaceBuilder.Frt` - Prompt UI
    - Integration with Azure OpenAI or Semantic Kernel

### Phase 4: Templates and Publishing
11. **Template System**
    - `Universo.Template.Quiz` - AR.js quiz template
    - `Universo.Template.Mmoomm` - PlayCanvas MMO template
    - Template registry

12. **Publication System**
    - `Universo.Publish.Srv` - Publication API
    - `Universo.Publish.Frt` - Publication UI
    - Export to various formats
    - Public URL generation

13. **Multiplayer Infrastructure**
    - `Universo.Multiplayer.Srv` - SignalR multiplayer
    - Room/lobby system
    - State synchronization

### Phase 5: Remaining Domains
14. **Analytics**
    - Quiz analytics dashboard
    - Data visualization

## Constitution Updates Required

Based on the React project analysis, the following additions/updates are recommended for the constitution:

### New Principles to Add:

#### VIII. Template System Architecture
Template packages MUST follow a consistent structure:
- Self-contained implementations with all dependencies
- Support for UPDL node integration
- Technology-specific builders implementing common interfaces
- Dual output formats where applicable
- Integration with publication system

**Rationale**: The React project's template system demonstrates the value of modular, technology-specific implementations that can be dynamically loaded based on user needs.

#### IX. Async Initialization Pattern
Backend services MUST implement asynchronous initialization:
- Database connections established before route registration
- Use hosted services for startup tasks
- Health checks to verify system readiness
- No race conditions during startup
- Graceful handling of initialization failures

**Rationale**: Prevents common startup issues and ensures system stability during deployment and scaling.

#### X. Three-Entity Domain Pattern
Domain models SHOULD follow the three-entity hierarchical pattern where applicable:
- Top-level container entity (e.g., Cluster, Metaverse, Unik)
- Mid-level grouping entity (e.g., Domain, Section, Space)
- Bottom-level item entity (e.g., Resource, Entity, Node)
- Generic base classes for CRUD operations
- Consistent API design across domains
- Reusable UI components

**Rationale**: Consistency across domains reduces cognitive load, enables code reuse, and accelerates development of new domain areas.

### Updates to Existing Principles:

#### Update to Principle VI (GitHub Workflow Integration):
Add:
- Issue creation MUST include bilingual spoiler tags: `<summary>In Russian</summary>`
- PR descriptions MUST include Russian translation in identical spoiler format
- All documentation updates MUST update both EN and RU versions simultaneously

#### Update to Principle VII (Multi-Database Preparedness):
Add:
- Initial focus: Supabase with Entity Framework Core and Npgsql provider
- Repository pattern MUST abstract all database operations
- Each domain package SHOULD have its own DbContext or share a common context
- Migration strategy: EF Core migrations per domain package
- Connection management: Scoped lifetime for DbContext in ASP.NET Core

## Technical Stack Recommendations for C# Implementation

Based on the React project's proven patterns, here are the recommended packages/libraries for the C# version:

### Core Framework
- **.NET 8** or later (LTS)
- **Blazor WebAssembly** (Frontend)
- **ASP.NET Core** (Backend)

### ORM and Database
- **Entity Framework Core 8** (Latest stable)
- **Npgsql.EntityFrameworkCore.PostgreSQL** (PostgreSQL provider)
- **supabase-csharp** (Supabase client)

### UI Framework
- **MudBlazor** (Material Design for Blazor)
- Alternative: **Radzen.Blazor** (Consider as fallback)
- **Blazor.Diagrams** (For node-based editor)

### Authentication
- **ASP.NET Core Identity**
- **Microsoft.AspNetCore.Authentication.JwtBearer**
- **Supabase integration** (Custom provider)

### State Management (Blazor)
- **Fluxor** (Redux pattern for Blazor)
- Alternative: **MediatR** (CQRS pattern)

### API Client
- **Refit** (Typed REST client)
- Alternative: **HttpClientFactory** with custom wrappers

### Validation
- **FluentValidation** (Primary)
- **DataAnnotations** (Simple cases)

### Testing
- **xUnit** (Unit testing framework)
- **bUnit** (Blazor component testing)
- **NSubstitute** or **Moq** (Mocking)
- **WebApplicationFactory** (Integration testing)

### Localization
- **.NET Resource System** (.resx files)
- **Microsoft.Extensions.Localization**

### Real-time Communication
- **SignalR** (WebSocket abstraction)
- Alternative: **DotNetty** (Low-level)

### AI Integration
- **Microsoft.SemanticKernel** (LLM orchestration)
- **Azure.AI.OpenAI** (OpenAI integration)

### Caching and Rate Limiting
- **Microsoft.Extensions.Caching.StackExchangeRedis**
- **AspNetCoreRateLimit** or built-in .NET 7+ rate limiting
- **StackExchange.Redis**

### Serialization
- **System.Text.Json** (Primary)
- **Newtonsoft.Json** (Fallback for compatibility)

### Build and Deployment
- **MSBuild** (Build system)
- **Docker** (Containerization)
- **GitHub Actions** or **Azure DevOps** (CI/CD)

## Conclusion

The React project provides a solid architectural foundation with clear patterns for:
1. **Monorepo structure** with package separation
2. **Three-entity domain model** for consistency
3. **Frontend/backend separation** with clear naming
4. **Template system** for extensibility
5. **UPDL** as a universal language for 3D/AR/VR
6. **Bilingual documentation** (EN/RU)
7. **Authentication** via Supabase
8. **Publication system** for sharing created content

The C# implementation should adapt these patterns while leveraging C#/.NET strengths:
- Type safety with nullable reference types
- Built-in dependency injection
- Entity Framework Core for data access
- Blazor for modern web UI
- ASP.NET Core for robust APIs

**Critical Success Factors:**
1. Maintain consistency with React project naming conventions
2. Implement the three-entity pattern from the start
3. Don't replicate React's legacy code issues
4. Follow the phased implementation order
5. Update constitution with new patterns discovered
6. Keep documentation bilingual (EN/RU) from day one
7. Test each package independently
8. Monitor React project for new features to port

**Next Steps:**
1. Update constitution with additional principles (VIII, IX, X)
2. Create detailed specifications for Phase 1 packages
3. Set up GitHub labels and issue templates
4. Begin implementation with shared infrastructure
5. Implement Clusters domain as reference implementation
