<!--
SYNC IMPACT REPORT - Constitution Update
Version: 0.1.0 → 1.0.0 → 1.1.0 → 1.2.0 → 1.3.0 (Modular Architecture Enforcement)
Date: 2025-11-16 (v1.0.0), 2025-11-16 (v1.1.0), 2025-11-17 (v1.2.0), 2025-11-17 (v1.3.0)

Changes in v1.3.0:
- STRENGTHENED Principle I (Monorepo Package Architecture) to NON-NEGOTIABLE status
- Added explicit PROHIBITED and MANDATORY constraints for packages/ directory
- Clarified what is permitted outside packages/ directory
- Added EXCEPTION clause for shared/ infrastructure libraries
- Enhanced rationale explaining future repository separation requirement
- This change addresses critical need to prevent non-modular implementations

Enhanced Principle in v1.3.0:
1. Monorepo Package Architecture - NOW MARKED AS NON-NEGOTIABLE with explicit constraints

Impact on Implementation:
- ALL feature implementations MUST verify packages/ directory structure FIRST
- Code reviews MUST verify no feature logic outside packages/ (except shared/ infrastructure)
- Planning documents MUST explicitly show packages/ structure before implementation
- Gate checks MUST fail if functionality bypasses packages/ structure
- Template updates needed to emphasize mandatory nature

Templates Requiring Updates:
⚠️ All specification templates - Add packages/ structure validation checklist
⚠️ IMPLEMENTATION_ROADMAP.md - Emphasize packages/ creation as Phase 0/1 requirement
⚠️ ARCHITECTURE.md - Add section on what can/cannot exist outside packages/
⚠️ Code review checklist - Add packages/ structure verification

Changes in v1.2.0:
- Added 4 new core principles based on deep architectural comparison with React project
- Focused on production-readiness patterns: error handling, validation, caching, rate limiting
- All principles based on proven patterns from React implementation
- Established security and performance foundations

Principles Added in v1.2.0:
11. Error Handling Architecture - Centralized exception handling and structured errors
12. Validation Strategy - FluentValidation for data integrity
13. Caching Strategy - Memory and distributed caching for performance
14. API Security & Rate Limiting - Rate limiting for abuse protection

Impact on Implementation:
- Phase 1 roadmap must include error handling infrastructure
- Phase 1 roadmap must include validation pipeline
- Phase 1 roadmap must include caching infrastructure
- Phase 1 roadmap must include rate limiting setup
- Package structure updated to include Validators/, Exceptions/ directories
- Specification templates updated with error handling, validation, and performance sections

Templates Requiring Updates:
⚠️ IMPLEMENTATION_ROADMAP.md - Add Phase 1 infrastructure tasks
⚠️ Package structure documentation - Add standard directories
⚠️ Specification templates - Add new sections
✅ DEEP_ARCHITECTURAL_COMPARISON.md - Created with detailed analysis
✅ ARCHITECTURAL_UPDATES_NEEDED.md - Created with action items

Changes in v1.1.0:
- Added 3 new core principles based on React project architectural analysis
- Enhanced existing principles with React-proven patterns
- Updated Multi-Database Preparedness with specific EF Core guidance
- Expanded GitHub Workflow Integration with bilingual requirements
- Added comprehensive React project comparison and analysis

Principles Added in v1.1.0:
8. Three-Entity Domain Pattern - Hierarchical domain model for consistency
9. Template System Architecture - Extensible template packaging strategy
10. Async Initialization Pattern - Startup sequence and race condition prevention

Enhanced Principles:
- Principle VI: Added bilingual spoiler tag requirements for Issues/PRs
- Principle VII: Added Entity Framework Core and migration strategy details

Templates Requiring Updates:
✅ All templates verified for consistency
✅ New patterns documented in REACT_PROJECT_ANALYSIS.md

Changes in v1.0.0:
- Created initial constitution for Universo Platformo CSharp
- Established 7 core principles for C#/Blazor/ASP.NET development
- Defined monorepo package structure standards
- Established bilingual documentation requirements
- Set GitHub workflow integration standards

Original Principles Added in v1.0.0:
1. Monorepo Package Architecture - Defines package structure with -frt/-srv separation
2. Frontend/Backend Separation - Blazor WebAssembly frontend, ASP.NET backend separation
3. Base Implementation Pattern - Multi-DBMS support through base/ directory pattern
4. Bilingual Documentation - English/Russian documentation requirement
5. Independent Package Testability - Each package must be independently testable
6. GitHub Workflow Integration - Issue/PR/Label standards compliance
7. Multi-Database Preparedness - Supabase first, architecture for future DBMS support
-->

# Universo Platformo CSharp Constitution

## Core Principles

### I. Monorepo Package Architecture (NON-NEGOTIABLE)

**CRITICAL**: All functionality (except shared startup/build files) MUST be organized as packages in the `packages/` directory following this structure:
- When a feature requires both frontend and backend: separate into `packages/[feature]-frt` and `packages/[feature]-srv`
- Each package MUST contain a `base/` directory as the root implementation folder
- Package naming convention: lowercase with hyphens (e.g., `clusters-frt`, `clusters-srv`)
- Examples: `packages/clusters-frt/base/`, `packages/clusters-srv/base/`
- **PROHIBITED**: Implementing feature functionality outside of `packages/` directory
- **PROHIBITED**: Monolithic implementations that mix frontend and backend in single package (except for shared infrastructure libraries)
- **MANDATORY**: All new features MUST create appropriate package(s) in `packages/` before implementation

**Rationale**: This architecture is NON-NEGOTIABLE because it enables future migration of individual packages to separate repositories. Packages will gradually move to independent repos as the project matures. Any feature not in `packages/` will block this critical architectural evolution.

**Permitted Outside `packages/` Directory**:
- `shared/` - Only for truly cross-cutting concerns used by multiple packages (e.g., Universo.Types, Universo.Utils, Universo.I18n)
- Root solution files (`.sln`, `Directory.Build.props`, `Directory.Packages.props`)
- Configuration files (`.gitignore`, `.editorconfig`, `global.json`)
- Documentation (root `README.md`, `CONTRIBUTING.md`, `LICENSE.md`, etc.)
- Build/deployment scripts
- `.github/` workflows and templates
- `.specify/` memory and templates
- `specs/` feature specifications

**EXCEPTION**: The `shared/` directory is ONLY for infrastructure libraries that provide common types, utilities, and services consumed by multiple packages. Shared libraries MUST NOT contain feature-specific logic. If functionality is feature-specific, it MUST go in a package.

### II. Frontend/Backend Separation

Frontend and backend MUST be strictly separated:
- **Frontend**: Blazor WebAssembly components in `-frt` packages
- **Backend**: ASP.NET Core services and APIs in `-srv` packages
- Frontend packages MUST NOT contain business logic that belongs in backend
- Backend packages MUST expose RESTful APIs or gRPC services for frontend consumption
- Shared models/contracts MAY exist in separate `-common` packages when needed

**Rationale**: Clear separation enables independent scaling, deployment flexibility, and allows different teams to work on frontend and backend simultaneously without conflicts.

### III. Base Implementation Pattern

Each package MUST use the `base/` directory pattern:
- The `base/` directory contains the primary implementation
- Future alternative implementations (e.g., different DBMS) will be added as sibling directories to `base/`
- Example: `packages/clusters-srv/base/` (Supabase), future: `packages/clusters-srv/postgresql/`
- All packages MUST be designed with abstraction layers to support multiple implementations

**Rationale**: Prepares the codebase for multi-database support and technology stack variations without requiring architectural refactoring later. Supabase is the initial focus, but the architecture must not be Supabase-specific.

### IV. Bilingual Documentation (NON-NEGOTIABLE)

All documentation MUST be provided in English and Russian:
- Primary file in English (e.g., `README.md`)
- Russian version with `-RU` suffix (e.g., `README-RU.md`)
- Russian version MUST be an exact copy in structure, sections, and line count
- Update English first, then create/update Russian version
- All GitHub Issues and PRs MUST include Russian translation in `<details><summary>In Russian</summary>` spoilers

**Rationale**: The project serves both English and Russian-speaking communities. Bilingual documentation ensures accessibility and maintains consistency with the reference React implementation standards.

### V. Independent Package Testability

Each package MUST be independently testable:
- Packages can be built, tested, and deployed independently
- Each package MUST have its own test suite
- Integration tests MUST verify contracts between packages
- No circular dependencies between packages allowed
- Mock/stub external dependencies for unit testing

**Rationale**: Independent testability enables parallel development, faster feedback loops, easier debugging, and supports the incremental development approach required by the project's phased rollout strategy.

### VI. GitHub Workflow Integration

All development MUST follow GitHub workflow standards:
- Issues MUST be created before implementation using `.github/instructions/github-issues.md` template
- PRs MUST follow `.github/instructions/github-pr.md` format
- Labels MUST be applied according to `.github/instructions/github-labels.md`
- Bilingual content in Issues/PRs MUST use exact spoiler format: `<summary>In Russian</summary>`
- PR titles MUST start with issue number: `GH{issue_number} {title}`
- Russian translation MUST be complete, not just a summary
- Russian and English versions MUST have identical structure and line count
- Update both language versions simultaneously

**Rationale**: Standardized GitHub workflows ensure traceability, proper documentation, and consistency across the project. These standards align with the reference React implementation and support effective collaboration. Complete bilingual documentation ensures accessibility for both English and Russian-speaking communities.

### VII. Multi-Database Preparedness

Architecture MUST support multiple database systems:
- Initial implementation focuses on Supabase
- All database access MUST go through repository/service abstractions
- Data models MUST be database-agnostic where possible
- Connection management MUST support configuration-based switching
- Migration strategy MUST be planned for adding PostgreSQL, SQL Server, etc.
- Use Entity Framework Core with Npgsql provider for PostgreSQL
- Each domain package SHOULD have its own DbContext or share a common context
- Implement Code-First migrations per domain package
- DbContext MUST use scoped lifetime in ASP.NET Core

**Rationale**: While Supabase provides rapid initial development, the platform must support enterprise deployments with various DBMS requirements. Early architectural decisions prevent costly refactoring later. Entity Framework Core provides the abstraction layer needed for multi-database support.

### VIII. Three-Entity Domain Pattern

Domain models SHOULD follow the three-entity hierarchical pattern where applicable:
- **Top-level container entity** (e.g., Cluster, Metaverse, Unik/Workspace)
- **Mid-level grouping entity** (e.g., Domain, Section, Space/Canvas)
- **Bottom-level item entity** (e.g., Resource, Entity, Node/Component)
- Create generic base classes for CRUD operations
- Maintain consistent API design across domains
- Reuse UI components with different entity names
- Apply pattern only where hierarchical organization is natural

**Rationale**: The React reference implementation demonstrates that consistency across domains reduces cognitive load, enables significant code reuse, and accelerates development of new domain areas. This pattern has been successfully applied to Clusters, Metaverses, and Uniks domains in the React version.

### IX. Template System Architecture

Template packages MUST follow a consistent structure:
- Self-contained implementations with all dependencies
- Support for UPDL node integration
- Technology-specific builders implementing common interfaces
- Export capabilities for target platforms (AR.js, PlayCanvas, Unity, etc.)
- Integration with publication system
- Independent versioning and deployment

**Rationale**: The React project's template system (template-quiz, template-mmoomm) demonstrates the value of modular, technology-specific implementations that can be dynamically loaded based on user needs. Templates enable platform extensibility without modifying core code.

### X. Async Initialization Pattern

Backend services MUST implement asynchronous initialization:
- Database connections MUST be established before route registration
- Use IHostedService for startup tasks (database migrations, cache warming)
- Implement health checks to verify system readiness
- Prevent race conditions during startup
- Handle initialization failures gracefully with proper error messages
- Log initialization progress for debugging

**Rationale**: The React reference implementation's async route initialization pattern prevents common startup issues, ensures system stability during deployment and scaling, and provides clear diagnostics when initialization fails. This is critical for enterprise deployments.

## Technology Stack Standards

### Primary Technologies
- **Language**: C# (.NET 8 or later)
- **Frontend**: Blazor WebAssembly
- **Backend**: ASP.NET Core
- **Database**: Supabase (initial), architecture for PostgreSQL, SQL Server, etc.
- **UI Components**: Material Design equivalent for Blazor (MudBlazor or similar)
- **Package Management**: .NET workspaces/solution structure (C# equivalent to PNPM workspaces)
- **Authentication**: ASP.NET Identity with Supabase connector (C# equivalent to Passport.js)

### Development Tools
- **Version Control**: Git with GitHub
- **Build System**: .NET CLI / MSBuild
- **Testing**: xUnit or NUnit for unit/integration tests
- **Code Style**: Standard C# conventions with EditorConfig
- **Documentation**: Markdown files, bilingual (EN/RU)

### Constraints
- Follow C#/.NET best practices and idioms
- Do not replicate known issues from the React implementation
- Avoid creating documentation in `docs/` folder (will be separate repository)
- Do not create AI agent configuration files unless explicitly requested
- Keep dependencies minimal and well-justified

## Development Workflow

### Feature Implementation Process

1. **Specification Phase**:
   - Create GitHub Issue following `github-issues.md` guidelines
   - Apply appropriate labels from `github-labels.md`
   - Define feature requirements and acceptance criteria
   - Include English and Russian descriptions

2. **Planning Phase**:
   - Create specification documents in `.specify/` following templates
   - Define package structure (which packages: -frt, -srv, -common)
   - Identify database abstraction requirements
   - Plan bilingual documentation approach

3. **Implementation Phase**:
   - Create feature branch from main
   - Implement in order: backend services → frontend components
   - Write tests for each package independently
   - Update English README, then Russian README-RU
   - Follow base/ directory structure for all packages

4. **Review Phase**:
   - Create PR following `github-pr.md` format
   - Include bilingual PR description
   - Verify constitution compliance
   - Pass all tests and code review
   - Ensure documentation completeness

5. **Integration Phase**:
   - Merge to main after approval
   - Update memory bank and project documentation
   - Close linked Issue automatically

### Quality Gates

Before merging any PR, verify:
- ✅ All tests pass (unit + integration)
- ✅ Code follows C# conventions
- ✅ Bilingual documentation is complete and identical in structure
- ✅ Packages are independently buildable
- ✅ No circular dependencies introduced
- ✅ Database access is properly abstracted
- ✅ GitHub Issue/PR guidelines followed
- ✅ Constitution principles not violated

## Reference Projects

### Primary Reference
- **universo-platformo-react**: https://github.com/teknokomo/universo-platformo-react
- Use as conceptual guide, not direct code port
- Analyze structure, replicate good patterns, avoid known issues
- Monitor for new features to implement in C# version

### Learning from Reference
- **Do replicate**: Package structure philosophy, feature organization, multi-user patterns
- **Do adapt**: C# idioms, Blazor patterns, ASP.NET best practices
- **Don't replicate**: Legacy Flowise code, poorly implemented features, docs/ folder structure
- **Stay synchronized**: Monitor React repo for new features to implement

## Governance

### Constitution Authority
- This constitution supersedes all other practices and guidelines
- When conflicts arise, constitution principles take precedence
- All PRs and code reviews MUST verify constitution compliance
- Complexity or deviations MUST be explicitly justified in documentation

### Amendment Process
- Amendments require documented justification
- Breaking changes require MAJOR version increment
- New principles/sections require MINOR version increment
- Clarifications and typo fixes require PATCH version increment
- All amendments MUST update the Sync Impact Report
- Template files MUST be updated to reflect constitution changes

### Compliance Verification
- Every PR MUST include a constitution compliance checklist
- Reviewers MUST verify adherence to all principles
- Automated checks SHOULD be implemented where possible
- Violations MUST be documented and justified or corrected

### Living Document
- Constitution evolves with project needs
- Regular reviews scheduled quarterly
- Community feedback incorporated through Issues
- All changes tracked with version history and Sync Impact Report

### XI. Error Handling Architecture

All packages MUST implement centralized error handling:
- Global exception middleware for ASP.NET Core backends
- Structured error responses with consistent format (ErrorResponse DTO)
- Error logging with severity levels (Critical, Error, Warning, Information)
- Blazor error boundaries for frontend graceful degradation
- Custom exception types for domain errors (ValidationException, NotFoundException, etc.)
- Health check endpoints for system status verification
- Sensitive information MUST NOT be exposed in production error responses

**Rationale**: The React reference implementation demonstrates robust error handling through Express middleware and React error boundaries. Centralized error handling prevents inconsistent error responses, improves debugging, and ensures security by preventing information leakage. This pattern is critical for production deployments and enterprise requirements.

### XII. Validation Strategy

All data input MUST be validated at API boundaries:
- FluentValidation for request DTOs with comprehensive rule coverage
- Model state validation automatically enforced in controllers
- Custom validation attributes for complex domain rules
- Validation errors returned in standardized format (consistent with ErrorResponse)
- Validation at both client (Blazor forms) and server (ASP.NET controllers)
- Validation rules centralized in validator classes for reusability
- Database constraints aligned with validation rules

**Rationale**: React's Zod schema validation ensures data integrity at compile time and runtime. C# equivalent using FluentValidation provides type-safe validation with reusable, testable rules. Consistent validation prevents data corruption and improves user experience.

### XIII. Caching Strategy

Performance-critical data MUST use appropriate caching:
- Memory cache (IMemoryCache) for frequently accessed reference data
- Distributed cache (Redis via IDistributedCache) for session and user data
- Cache invalidation strategy documented per feature
- TTL (Time To Live) configured appropriately per data type
- Cache-aside pattern for database queries
- Cache keys follow consistent naming convention: `{package}:{entity}:{id}`
- Cache hit/miss metrics tracked for optimization

**Rationale**: React's Redis integration demonstrates the importance of caching for scalability and performance. Without explicit caching strategy, the platform will suffer from database bottlenecks and poor response times. C# implementation needs caching strategy from day one to support multi-tenant architecture.

### XIV. API Security & Rate Limiting

All public APIs MUST implement rate limiting:
- IP-based rate limiting for anonymous endpoints (e.g., 100 requests per 15 minutes)
- User-based rate limiting for authenticated endpoints (e.g., 1000 requests per hour)
- Configurable limits per endpoint category (public, authenticated, admin)
- Rate limit headers in responses (X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset)
- Graceful degradation when limits exceeded (HTTP 429 with Retry-After header)
- Admin endpoints exempt from rate limiting
- Rate limiting configuration in appsettings.json

**Rationale**: React's express-rate-limit middleware protects against abuse, DoS attacks, and resource exhaustion. Enterprise deployments require this protection from the start. Rate limiting also enables fair usage policies and prevents single users from monopolizing resources.

**Version**: 1.3.0 | **Ratified**: 2025-11-17 | **Last Amended**: 2025-11-17
