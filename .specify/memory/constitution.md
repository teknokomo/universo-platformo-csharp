<!--
SYNC IMPACT REPORT - Constitution Update
Version: 0.1.0 → 1.0.0 → 1.1.0 (React Project Analysis Integration)
Date: 2025-11-16 (v1.0.0), 2025-11-16 (v1.1.0)

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

### I. Monorepo Package Architecture

All functionality MUST be organized as packages in the `packages/` directory following this structure:
- When a feature requires both frontend and backend: separate into `packages/[feature]-frt` and `packages/[feature]-srv`
- Each package MUST contain a `base/` directory as the root implementation folder
- Package naming convention: lowercase with hyphens (e.g., `clusters-frt`, `clusters-srv`)
- Examples: `packages/clusters-frt/base/`, `packages/clusters-srv/base/`

**Rationale**: This architecture enables future multi-implementation scenarios where one feature might have multiple database implementations or different frontend frameworks, all organized under their respective package with variant-specific subdirectories alongside `base/`.

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

**Rationale**: Standardized GitHub workflows ensure traceability, proper documentation, and consistency across the project. These standards align with the reference React implementation and support effective collaboration.

### VII. Multi-Database Preparedness

Architecture MUST support multiple database systems:
- Initial implementation focuses on Supabase
- All database access MUST go through repository/service abstractions
- Data models MUST be database-agnostic where possible
- Connection management MUST support configuration-based switching
- Migration strategy MUST be planned for adding PostgreSQL, SQL Server, etc.

**Rationale**: While Supabase provides rapid initial development, the platform must support enterprise deployments with various DBMS requirements. Early architectural decisions prevent costly refactoring later.

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

**Version**: 1.0.0 | **Ratified**: 2025-11-16 | **Last Amended**: 2025-11-16
