# Implementation Plan: Initial Project Setup

**Branch**: `001-initial-setup` | **Date**: 2025-11-17 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `.specify/specs/001-initial-setup/spec.md`

## Summary

Set up the foundational structure for Universo Platformo CSharp using Blazor WebAssembly (frontend) and ASP.NET Core (backend). This implementation establishes the monorepo structure with .NET Solution management, Clean/Onion Architecture, MudBlazor UI components, FluentValidation for data validation, hybrid caching strategy, built-in rate limiting, and comprehensive testing with xUnit and Testcontainers. All architectural decisions are based on 2024-2025 best practices research.

## Technical Context

**Language/Version**: C# .NET 8.0 or later (latest LTS version)
**Architecture Pattern**: Clean/Onion Architecture with layered approach
**Primary Dependencies**:
- **Frontend**: Blazor WebAssembly, MudBlazor (Material Design components)
- **Backend**: ASP.NET Core Web API, FluentValidation
- **Database**: Supabase with Repository Pattern + EF Core abstraction layer
- **Caching**: IMemoryCache (local) + IDistributedCache/Redis (distributed)
- **Testing**: xUnit with Testcontainers for real dependencies
**Storage**: Supabase (initial), architecture supports PostgreSQL/SQL Server via abstraction  
**Authentication**: Supabase JWT validation with ASP.NET Core JwtBearer middleware
**Validation**: FluentValidation with automatic registration and pipeline integration
**Error Handling**: IExceptionHandler (ASP.NET Core 8+) with ProblemDetails responses
**Rate Limiting**: Built-in ASP.NET Core middleware with fixed window/token bucket algorithms
**Target Platform**: Web (Blazor WASM client), cross-platform backend (.NET)
**Project Type**: Monorepo web application (Blazor frontend + ASP.NET backend)  
**Performance Goals**: <200ms API response time, 60fps UI rendering, <3s initial load
**Constraints**: Bilingual docs required (EN/RU), package-based architecture, database abstraction, minimal JavaScript
**Scale/Scope**: Multi-tenant ready, designed for 10k+ concurrent users with horizontal scaling
**Monorepo Management**: Single .sln file with Directory.Build.props for shared configuration

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Verify compliance with `.specify/memory/constitution.md` (Version 1.3.0):

- [x] **Monorepo Package Architecture (NON-NEGOTIABLE)**: ✅ Feature organized in `packages/` with proper naming (`-frt`, `-srv`, `-common`) and `base/` structure. CRITICAL: No feature functionality outside packages/
- [x] **Frontend/Backend Separation**: ✅ Clear separation into `-frt` (Blazor WASM) and `-srv` (ASP.NET Core) packages
- [x] **Base Implementation Pattern**: ✅ Using `base/` directory for primary Supabase implementation
- [x] **Bilingual Documentation**: ✅ English + Russian versions planned (README.md + README-RU.md with identical structure)
- [x] **Independent Package Testability**: ✅ Each package has its own Tests/ directory with xUnit and Testcontainers
- [x] **GitHub Workflow Integration**: ✅ Issue/PR/Labels following `.github/instructions/` guidelines
- [x] **Multi-Database Preparedness**: ✅ Repository Pattern with EF Core abstraction layer, not Supabase-specific
- [x] **Three-Entity Domain Pattern**: ✅ Will apply to Clusters, Metaverses, and other hierarchical domains
- [x] **Error Handling Architecture**: ✅ IExceptionHandler with structured ProblemDetails responses
- [x] **Validation Strategy**: ✅ FluentValidation with centralized validator classes
- [x] **Caching Strategy**: ✅ Hybrid approach (IMemoryCache + Redis IDistributedCache)
- [x] **API Security & Rate Limiting**: ✅ Built-in ASP.NET Core rate limiting middleware
- [x] **Async Initialization Pattern**: ✅ IHostedService for startup tasks planned
- [x] **Template System Architecture**: ✅ Extensible package-based template system planned

**Status**: ✅ All constitution principles satisfied. No violations to justify.

**CRITICAL VALIDATION**: 
- ✅ `src/packages/` directory MUST be created in Phase 1 before any feature work
- ✅ All domain features (Clusters, Metaverses, Auth, etc.) MUST go in packages/
- ✅ Only infrastructure libraries (Types, Utils, I18n) allowed in src/shared/
- ✅ No feature functionality outside packages/ directory

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# Universo Platformo CSharp - Monorepo Structure

⚠️ CRITICAL: ALL feature functionality MUST be in src/packages/ (Constitution Principle I - NON-NEGOTIABLE)

/
├── .github/
│   ├── workflows/           # CI/CD pipelines
│   └── instructions/        # GitHub workflow guidelines
├── .specify/
│   ├── memory/              # Constitution and memory bank
│   ├── scripts/             # Workflow scripts
│   └── templates/           # Document templates
├── src/
│   ├── packages/            # ⚠️ MANDATORY: ALL feature packages go here
│   │   ├── auth-srv/        # Authentication backend
│   │   │   └── base/
│   │   │       ├── Controllers/
│   │   │       ├── Services/
│   │   │       ├── Repositories/
│   │   │       ├── Validators/
│   │   │       ├── Exceptions/
│   │   │       └── Tests/
│   │   ├── auth-frt/        # Authentication frontend
│   │   │   └── base/
│   │   │       ├── Components/
│   │   │       ├── Pages/
│   │   │       └── Tests/
│   │   ├── clusters-srv/    # Clusters backend (Three-Entity Pattern)
│   │   │   └── base/
│   │   ├── clusters-frt/    # Clusters frontend
│   │   │   └── base/
│   │   ├── metaverses-srv/  # Metaverses backend
│   │   │   └── base/
│   │   ├── metaverses-frt/  # Metaverses frontend
│   │   │   └── base/
│   │   └── [feature]-srv/   # Additional feature packages
│   │       └── base/
│   │           ├── Controllers/     # API endpoints
│   │           ├── Services/        # Business logic
│   │           ├── Models/          # Data models
│   │           ├── Repositories/    # Data access (Repository Pattern)
│   │           ├── Validators/      # FluentValidation validators
│   │           ├── Exceptions/      # Custom exceptions
│   │           └── Tests/           # xUnit + Testcontainers
│   ├── shared/              # ⚠️ ONLY for cross-cutting infrastructure
│   │   ├── Universo.Types/  # Common types and interfaces
│   │   ├── Universo.Utils/  # Utility functions
│   │   ├── Universo.I18n/   # Internationalization
│   │   └── Universo.Common/ # Error handling, validation, caching
│   ├── Universo.sln         # Single solution file
│   ├── Directory.Build.props    # Shared build configuration
│   └── Directory.Packages.props # Centralized package versions
├── specs/                   # Feature specifications
├── tests/                   # Integration tests
├── .editorconfig            # Code style rules
├── .gitignore
├── README.md
├── README-RU.md
└── LICENSE.md
```

**Structure Decision**: 
- **⚠️ NON-NEGOTIABLE**: ALL features MUST be in `src/packages/` (NOT in shared/)
- **Monorepo**: Single .NET solution (.sln) with Directory.Build.props for shared configuration
- **Clean Architecture**: Domain → Application → Infrastructure → Presentation layers
- **Package Organization**: Features split into `-frt` (Blazor), `-srv` (ASP.NET), `-common` (shared contracts)
- **Base Pattern**: Each package has `base/` directory for primary Supabase implementation
- **Testing**: Each package has Tests/ directory with xUnit and Testcontainers
- **Infrastructure**: Added Validators/ and Exceptions/ directories per research best practices
- **No circular dependencies**: Clear one-way dependency flow
- **Independent testability**: Each package can be built, tested, and deployed independently

## Complexity Tracking

**Status**: ✅ No constitution violations identified.

All architectural decisions align with the constitution principles:
- Monorepo package architecture properly structured
- Frontend/backend clearly separated
- Base implementation pattern used consistently
- Bilingual documentation planned
- Independent package testability ensured
- GitHub workflow integration followed
- Multi-database preparedness via abstraction layers
- Error handling, validation, caching, and rate limiting aligned with constitution requirements

No additional complexity or justifications needed.
