# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: C# .NET 8 or later  
**Primary Dependencies**: Blazor WebAssembly, ASP.NET Core, Supabase SDK (or abstraction layer)  
**Storage**: Supabase (initial), architecture supports PostgreSQL/SQL Server via abstraction  
**Testing**: xUnit or NUnit with integration test support  
**Target Platform**: Web (Blazor WASM), cross-platform backend (.NET)
**Project Type**: Web application (Blazor frontend + ASP.NET backend)  
**Performance Goals**: [domain-specific, e.g., <200ms API response, 60fps UI or NEEDS CLARIFICATION]  
**Constraints**: Bilingual docs required (EN/RU), package-based architecture, database abstraction  
**Scale/Scope**: [domain-specific, e.g., multi-tenant, 10k+ users or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Verify compliance with `.specify/memory/constitution.md`:

- [ ] **Monorepo Package Architecture**: Feature organized in `packages/` with proper naming and `base/` structure
- [ ] **Frontend/Backend Separation**: Clear separation into `-frt` and `-srv` packages if both needed
- [ ] **Base Implementation Pattern**: Using `base/` directory for primary implementation
- [ ] **Bilingual Documentation**: English + Russian versions planned (README.md + README-RU.md)
- [ ] **Independent Package Testability**: Each package can be tested independently
- [ ] **GitHub Workflow Integration**: Issue/PR/Labels following `.github/instructions/` guidelines
- [ ] **Multi-Database Preparedness**: Database access abstracted, not Supabase-specific

Any violations MUST be justified in Complexity Tracking section below.

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
# Option: Web application (Blazor WebAssembly + ASP.NET Core)
# Default structure for Universo Platformo CSharp

packages/
├── [feature]-srv/           # Backend package
│   └── base/                # Base implementation (Supabase initially)
│       ├── Controllers/     # API controllers
│       ├── Services/        # Business logic
│       ├── Models/          # Data models
│       ├── Repositories/    # Data access abstraction
│       └── Tests/           # Package-specific tests
│
├── [feature]-frt/           # Frontend package
│   └── base/                # Base implementation
│       ├── Components/      # Blazor components
│       ├── Pages/           # Blazor pages
│       ├── Services/        # Frontend services (API clients)
│       └── Tests/           # Component tests
│
└── [feature]-common/        # Shared contracts (if needed)
    └── base/
        ├── Contracts/       # API contracts/DTOs
        └── Models/          # Shared models
```

**Structure Decision**: Following Universo Platformo CSharp monorepo package architecture as defined in the constitution. Features requiring both frontend and backend are split into `-frt` and `-srv` packages under `packages/` directory. Each package contains a `base/` directory for the primary implementation. Shared contracts may be placed in `-common` packages when needed. This structure supports independent package development, testing, and future multi-implementation scenarios.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
