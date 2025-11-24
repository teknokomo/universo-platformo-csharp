# Feature Specification: Initial Project Setup

**Feature ID**: 001-initial-setup  
**Priority**: Critical  
**Status**: Planning  
**Created**: 2025-11-17

## Overview

Set up the foundational structure for Universo Platformo CSharp, a C#/.NET implementation of the Universo Platformo platform using Blazor WebAssembly for frontend and ASP.NET Core for backend. This initial setup establishes the monorepo structure, build system, documentation framework, and GitHub workflow integration following the constitution principles.

## Background

Universo Platformo is being created in multiple technology stack implementations. The React version (https://github.com/teknokomo/universo-platformo-react) serves as the conceptual reference. This C# implementation will:

1. Use Blazor WebAssembly (frontend) and ASP.NET Core (backend) instead of React/Express
2. Follow C# best practices and idioms rather than directly porting React code
3. Implement the same conceptual architecture: monorepo with package-based structure
4. Support bilingual documentation (English/Russian) as required
5. Use Supabase initially with architecture for multi-database support
6. Avoid replicating known issues from the React version

## Requirements

### Functional Requirements

1. **Repository Structure**
   - Create `packages/` directory for all feature packages
   - Establish naming convention: `[feature]-frt`, `[feature]-srv`, `[feature]-common`
   - Each package must contain `base/` directory for primary implementation
   - Create `.sln` solution file for .NET workspace management
   - Set up .gitignore for C#/.NET projects

2. **Documentation Framework**
   - Create root README.md (English) and README-RU.md (Russian)
   - Document project goals, architecture, and getting started guide
   - Create CONTRIBUTING.md with development workflow
   - Document package structure and naming conventions
   - All documentation must be bilingual with identical structure

3. **GitHub Integration**
   - Create issue labels according to `.github/instructions/github-labels.md`
   - Document issue creation workflow per `.github/instructions/github-issues.md`
   - Document PR workflow per `.github/instructions/github-pr.md`
   - Set up issue templates for consistent formatting
   - Ensure bilingual spoiler format for Russian translations

4. **Build System**
   - Configure .NET solution for monorepo structure
   - Set up Directory.Build.props for shared build configuration
   - Configure NuGet package management
   - Establish testing framework (xUnit or NUnit)
   - Create basic CI/CD workflow for builds and tests

5. **Database Abstraction Layer**
   - Design repository pattern for database access
   - Create interfaces for Supabase connectivity
   - Plan Entity Framework Core integration
   - Establish migration strategy
   - Document database abstraction approach

### Non-Functional Requirements

1. **Constitution Compliance**
   - All 10 core principles must be satisfied
   - Package structure must support future multi-implementation
   - Database access must be abstracted
   - Documentation must be bilingual with identical structure
   - No circular dependencies between packages

2. **Code Quality**
   - Follow C# coding conventions
   - Use EditorConfig for consistent code style
   - Implement nullable reference types
   - Use modern C# language features (.NET 8+)
   - Include XML documentation comments for public APIs

3. **Testability**
   - Each package must be independently testable
   - Mock external dependencies in unit tests
   - Integration tests verify package contracts
   - Test coverage reporting configured

## Technical Approach

### Technology Stack

- **Language**: C# .NET 8.0 or later
- **Frontend**: Blazor WebAssembly
- **Backend**: ASP.NET Core Web API
- **Database**: Supabase (via REST API and/or .NET SDK)
- **UI Framework**: MudBlazor (Material Design for Blazor)
- **Authentication**: ASP.NET Identity with Supabase integration
- **Testing**: xUnit with Moq for mocking
- **Build**: .NET CLI / MSBuild
- **Package Management**: NuGet with .NET workspaces

### Architecture Decisions

1. **Monorepo with .NET Solution**
   - Single .sln file at root
   - Each package is a separate .csproj
   - Shared configuration via Directory.Build.props
   - Package references between projects

2. **Frontend/Backend Separation**
   - Blazor WASM apps in `-frt` packages
   - ASP.NET Core APIs in `-srv` packages
   - Shared DTOs/contracts in `-common` packages
   - Clear API boundaries

3. **Database Abstraction**
   - Repository pattern for data access
   - Interfaces separate from implementations
   - Supabase client wrapped in repository
   - EF Core ready for future PostgreSQL direct access

4. **Authentication Strategy**
   - ASP.NET Identity as primary auth system
   - Supabase Auth SDK integration
   - JWT tokens for API authentication
   - Role-based authorization

## Success Criteria

1. Repository structure matches constitution requirements
2. All documentation is bilingual with identical structure
3. Solution builds successfully with `dotnet build`
4. GitHub labels and issue templates created
5. Basic README files explain project purpose and setup
6. No violations of constitution principles (or all justified)
7. Project can be cloned and built by new developers

## Out of Scope

1. Implementation of actual features (Clusters, Metaverses, etc.)
2. Complete authentication implementation
3. UI component library setup beyond basic structure
4. Full database schema and migrations
5. CI/CD pipeline implementation
6. Documentation website (docs/ folder - will be separate repo)
7. AI agent configuration files (created by user as needed)

## Future Considerations

1. Monitor React reference implementation for new features
2. Plan for future DBMS support (PostgreSQL, SQL Server)
3. Consider GraphQL API alongside REST
4. Plan for internationalization beyond Russian/English
5. Consider microservices architecture for scaling

## Dependencies

- .NET 8.0 SDK
- Supabase project and credentials
- GitHub repository with appropriate permissions
- MudBlazor NuGet packages
- Supabase .NET client library (if available)

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Supabase .NET SDK limitations | High | Design abstraction layer to allow direct PostgreSQL access |
| Blazor WASM performance concerns | Medium | Use lazy loading, virtualization, and WebAssembly AOT |
| Monorepo build complexity | Medium | Use Directory.Build.props and proper project structure |
| Bilingual documentation maintenance | Medium | Create templates and clear process for simultaneous updates |
| Package interdependencies | High | Enforce one-way dependencies, no circular references |

## References

- [Universo Platformo React](https://github.com/teknokomo/universo-platformo-react)
- [Constitution](../../memory/constitution.md)
- [GitHub Issue Guidelines](../../../.github/instructions/github-issues.md)
- [GitHub PR Guidelines](../../../.github/instructions/github-pr.md)
- [GitHub Labels](../../../.github/instructions/github-labels.md)
- [Blazor Documentation](https://learn.microsoft.com/en-us/aspnet/core/blazor/)
- [MudBlazor](https://mudblazor.com/)
