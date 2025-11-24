# Tasks: Initial Project Setup

**Feature ID**: 001-initial-setup  
**Input**: Design documents from `.specify/specs/001-initial-setup/`  
**Prerequisites**: plan.md (✅), spec.md (✅), research.md (✅), data-model.md (✅), contracts/ (✅)

**Tests**: Tests are NOT explicitly requested in the feature specification. Focus on infrastructure setup and validation through build/compilation.

**Organization**: Tasks are grouped by functional requirement areas (treated as user stories) to enable independent implementation and validation.

## Format: `- [ ] [TaskID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story/requirement this task belongs to (US1, US2, US3, US4, US5)
- All paths are absolute from repository root
- Each task includes exact file paths

## Path Conventions

- **Monorepo structure**: `src/packages/[feature]-srv/base/`, `src/packages/[feature]-frt/base/`
- **Backend code**: `src/packages/[feature]-srv/base/Controllers/`, `src/packages/[feature]-srv/base/Services/`, etc.
- **Frontend code**: `src/packages/[feature]-frt/base/Components/`, `src/packages/[feature]-frt/base/Pages/`, etc.
- **Shared contracts**: `src/packages/[feature]-common/base/Contracts/` (if needed)
- **Shared infrastructure**: `src/shared/Universo.[Module]/` (only for cross-cutting concerns)
- **Tests**: Each package has its own `Tests/` directory
- **Documentation**: Bilingual README.md and README-RU.md in package roots and repository root

---

## Phase 1: Setup (Project Initialization)

**Purpose**: Create foundational repository structure and basic configuration files

**⚠️ CRITICAL**: The `src/packages/` directory MUST be created in this phase (Constitution Principle I - NON-NEGOTIABLE)

- [ ] T001 Create `src/packages/` directory (MANDATORY - Constitution requirement)
- [ ] T002 Create `src/shared/` directory for infrastructure libraries
- [ ] T003 [P] Create .gitignore file for .NET projects in repository root
- [ ] T004 [P] Create .editorconfig file in repository root with C# formatting rules
- [ ] T005 [P] Create global.json file specifying .NET SDK version (8.0+)
- [ ] T006 Create Universo.sln solution file in `src/` directory
- [ ] T007 [P] Create Directory.Build.props in `src/` for shared build configuration
- [ ] T008 [P] Create Directory.Packages.props in `src/` for centralized package versions

**Checkpoint**: Basic repository structure created with packages/ directory ready for features

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core shared infrastructure that MUST be complete before ANY user story implementation

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Shared Infrastructure Libraries

- [ ] T009 Create `src/shared/Universo.Types/` project (.csproj) for common types and interfaces
- [ ] T010 Create `src/shared/Universo.Utils/` project (.csproj) for utility functions
- [ ] T011 Create `src/shared/Universo.I18n/` project (.csproj) for internationalization
- [ ] T012 Create `src/shared/Universo.Common/` project (.csproj) for error handling, validation, caching

### Core Types and Interfaces (from data-model.md)

- [ ] T013 [P] Implement BaseEntity record in `src/shared/Universo.Types/Models/BaseEntity.cs`
- [ ] T014 [P] Implement IContainerEntity interface in `src/shared/Universo.Types/Models/IContainerEntity.cs`
- [ ] T015 [P] Implement IGroupEntity interface in `src/shared/Universo.Types/Models/IGroupEntity.cs`
- [ ] T016 [P] Implement IItemEntity interface in `src/shared/Universo.Types/Models/IItemEntity.cs`
- [ ] T017 [P] Implement IRepository<T> interface in `src/shared/Universo.Types/Repositories/IRepository.cs`
- [ ] T018 [P] Implement PackageMetadata record in `src/shared/Universo.Types/Metadata/PackageMetadata.cs`
- [ ] T019 [P] Implement DatabaseConfiguration record in `src/shared/Universo.Types/Configuration/DatabaseConfiguration.cs`
- [ ] T020 [P] Implement SupabaseConfiguration record in `src/shared/Universo.Types/Configuration/SupabaseConfiguration.cs`

### Common API Models

- [ ] T021 [P] Implement ApiResponse<T> record in `src/shared/Universo.Types/Api/ApiResponse.cs`
- [ ] T022 [P] Implement PagedResult<T> record in `src/shared/Universo.Types/Api/PagedResult.cs`
- [ ] T023 [P] Implement ValidationResult record in `src/shared/Universo.Types/Validation/ValidationResult.cs`
- [ ] T024 [P] Implement ValidationError record in `src/shared/Universo.Types/Validation/ValidationError.cs`

### Error Handling Infrastructure (Constitution Principle XI)

- [ ] T025 Implement IExceptionHandler base in `src/shared/Universo.Common/Exceptions/GlobalExceptionHandler.cs`
- [ ] T026 [P] Create custom exception types in `src/shared/Universo.Common/Exceptions/` (ResourceNotFoundException, ValidationException, etc.)
- [ ] T027 Configure ProblemDetails responses in `src/shared/Universo.Common/Exceptions/ProblemDetailsFactory.cs`

### Validation Infrastructure (Constitution Principle XII)

- [ ] T028 Add FluentValidation NuGet package to Directory.Packages.props
- [ ] T029 Create abstract validator base class in `src/shared/Universo.Common/Validation/BaseValidator.cs`
- [ ] T030 Implement validation pipeline integration in `src/shared/Universo.Common/Validation/ValidationBehavior.cs`

### Caching Infrastructure (Constitution Principle XIII)

- [ ] T031 [P] Implement IMemoryCache wrapper in `src/shared/Universo.Common/Caching/MemoryCacheService.cs`
- [ ] T032 [P] Implement IDistributedCache abstraction in `src/shared/Universo.Common/Caching/DistributedCacheService.cs`
- [ ] T033 Create caching configuration in `src/shared/Universo.Common/Caching/CacheConfiguration.cs`

### Rate Limiting Infrastructure (Constitution Principle XIV)

- [ ] T034 Configure rate limiting middleware in `src/shared/Universo.Common/RateLimiting/RateLimitConfiguration.cs`
- [ ] T035 [P] Implement fixed window rate limiter in `src/shared/Universo.Common/RateLimiting/FixedWindowRateLimiter.cs`
- [ ] T036 [P] Implement token bucket rate limiter in `src/shared/Universo.Common/RateLimiting/TokenBucketRateLimiter.cs`

### Build and Add Projects to Solution

- [ ] T037 Add all shared projects to Universo.sln using `dotnet sln add`
- [ ] T038 Configure project references between shared libraries (Types → Common, etc.)
- [ ] T039 Build entire solution with `dotnet build` to verify foundation
- [ ] T040 Create unit tests for shared infrastructure in each shared project's Tests/ directory

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Repository Structure Setup (Priority: P1) 🎯 MVP Component

**Goal**: Establish the mandatory package-based architecture with proper naming conventions and directory structure

**Independent Test**: Verify `src/packages/` directory exists and sample package structure can be created successfully

**Functional Requirement**: Repository Structure (Requirement 1 from spec.md)

### Implementation for User Story 1

- [ ] T041 [P] [US1] Create example package structure `src/packages/example-srv/base/` with standard directories
- [ ] T042 [P] [US1] Create example package structure `src/packages/example-frt/base/` with standard directories
- [ ] T043 [US1] Create example-srv.csproj in `src/packages/example-srv/base/` as template for server packages
- [ ] T044 [US1] Create example-frt.csproj in `src/packages/example-frt/base/` as template for frontend packages
- [ ] T045 [US1] Add standard directories to example-srv: Controllers/, Services/, Models/, Repositories/, Validators/, Exceptions/, Tests/
- [ ] T046 [US1] Add standard directories to example-frt: Components/, Pages/, Services/, Tests/
- [ ] T047 [US1] Document package structure conventions in `ARCHITECTURE.md` (English)
- [ ] T048 [US1] Document package naming conventions and directory layout
- [ ] T049 [US1] Add example packages to Universo.sln for validation
- [ ] T050 [US1] Build solution to verify package structure is valid
- [ ] T051 [US1] Remove example packages after structure validation (they're templates only)

**Checkpoint**: Package structure established and validated - ready for real feature packages

---

## Phase 4: User Story 2 - Documentation Framework (Priority: P1) 🎯 MVP Component

**Goal**: Create comprehensive bilingual documentation explaining project purpose, architecture, and setup

**Independent Test**: Documentation can be read and followed by new developer to clone and build project

**Functional Requirement**: Documentation Framework (Requirement 2 from spec.md)

### Implementation for User Story 2

- [ ] T052 [P] [US2] Update root README.md with improved project description, tech stack, and architecture overview
- [ ] T053 [US2] Create exact Russian copy README-RU.md matching README.md structure line-by-line
- [ ] T054 [P] [US2] Create CONTRIBUTING.md with development workflow (English)
- [ ] T055 [US2] Create CONTRIBUTING-RU.md with development workflow (Russian)
- [ ] T056 [P] [US2] Update ARCHITECTURE.md with detailed package structure documentation (English)
- [ ] T057 [US2] Create ARCHITECTURE-RU.md with detailed package structure documentation (Russian)
- [ ] T058 [P] [US2] Create SETUP.md with step-by-step environment setup (English)
- [ ] T059 [US2] Create SETUP-RU.md with step-by-step environment setup (Russian)
- [ ] T060 [P] [US2] Document package naming conventions in a dedicated PACKAGE_CONVENTIONS.md (English)
- [ ] T061 [US2] Create PACKAGE_CONVENTIONS-RU.md (Russian)
- [ ] T062 [P] [US2] Create CODE_STYLE.md documenting C# coding standards (English)
- [ ] T063 [US2] Create CODE_STYLE-RU.md documenting C# coding standards (Russian)
- [ ] T064 [US2] Verify all documentation files have proper bilingual pairs
- [ ] T065 [US2] Verify line counts match between EN and RU versions

**Checkpoint**: Complete bilingual documentation exists for new developers

---

## Phase 5: User Story 3 - GitHub Integration (Priority: P2)

**Goal**: Set up GitHub issue labels, templates, and workflows per constitution requirements

**Independent Test**: GitHub issues can be created following templates with proper labels

**Functional Requirement**: GitHub Integration (Requirement 3 from spec.md)

### Implementation for User Story 3

- [ ] T066 [P] [US3] Review `.github/instructions/github-labels.md` to understand label requirements
- [ ] T067 [P] [US3] Review `.github/instructions/github-issues.md` to understand issue workflow
- [ ] T068 [P] [US3] Review `.github/instructions/github-pr.md` to understand PR workflow
- [ ] T069 [US3] Create `.github/ISSUE_TEMPLATE/bug_report.md` with bilingual sections
- [ ] T070 [US3] Create `.github/ISSUE_TEMPLATE/feature_request.md` with bilingual sections
- [ ] T071 [US3] Create `.github/ISSUE_TEMPLATE/enhancement.md` with bilingual sections
- [ ] T072 [US3] Create `.github/PULL_REQUEST_TEMPLATE.md` with bilingual sections
- [ ] T073 [P] [US3] Document required GitHub labels in `.github/labels.yml` for automated creation
- [ ] T074 [P] [US3] Create GitHub workflow `.github/workflows/build.yml` for CI builds
- [ ] T075 [P] [US3] Create GitHub workflow `.github/workflows/test.yml` for automated testing
- [ ] T076 [US3] Document issue creation process in `.github/CONTRIBUTING_GITHUB.md` (English)
- [ ] T077 [US3] Create `.github/CONTRIBUTING_GITHUB-RU.md` (Russian)
- [ ] T078 [US3] Verify bilingual spoiler format for Russian translations in templates

**Checkpoint**: GitHub integration complete with proper workflow templates

---

## Phase 6: User Story 4 - Build System Configuration (Priority: P1) 🎯 MVP Component

**Goal**: Configure comprehensive .NET build system with monorepo support, testing, and quality tools

**Independent Test**: Run `dotnet build` and `dotnet test` successfully on entire solution

**Functional Requirement**: Build System (Requirement 4 from spec.md)

### Implementation for User Story 4

- [ ] T079 [P] [US4] Configure NuGet package sources in `NuGet.config` (include Supabase, MudBlazor sources)
- [ ] T080 [P] [US4] Add core NuGet packages to Directory.Packages.props (MudBlazor, Supabase, xUnit, FluentValidation)
- [ ] T081 [P] [US4] Configure C# language version and nullable reference types in Directory.Build.props
- [ ] T082 [P] [US4] Set up code analysis rules in Directory.Build.props (StyleCop, analyzers)
- [ ] T083 [P] [US4] Configure test settings in Directory.Build.props for xUnit
- [ ] T084 [US4] Create shared test utilities project `src/shared/Universo.Testing/` for Testcontainers helpers
- [ ] T085 [US4] Add Testcontainers NuGet packages to Directory.Packages.props
- [ ] T086 [US4] Create sample unit test in `src/shared/Universo.Types/Tests/BaseEntityTests.cs`
- [ ] T087 [US4] Build entire solution with `dotnet build --no-incremental` to verify all configurations
- [ ] T088 [US4] Run all tests with `dotnet test` to verify test infrastructure
- [ ] T089 [P] [US4] Create build script `scripts/build.sh` for Linux/Mac
- [ ] T090 [P] [US4] Create build script `scripts/build.ps1` for Windows PowerShell
- [ ] T091 [P] [US4] Create test script `scripts/test.sh` for running all tests
- [ ] T092 [P] [US4] Create test script `scripts/test.ps1` for running all tests
- [ ] T093 [US4] Document build and test commands in CONTRIBUTING.md

**Checkpoint**: Complete build system ready for continuous integration

---

## Phase 7: User Story 5 - Database Abstraction Layer (Priority: P1) 🎯 MVP Component

**Goal**: Implement repository pattern with Supabase integration and EF Core readiness

**Independent Test**: Can instantiate repository implementation and perform CRUD operations against Supabase

**Functional Requirement**: Database Abstraction Layer (Requirement 5 from spec.md)

### Implementation for User Story 5

- [ ] T094 [P] [US5] Add Supabase .NET client NuGet packages to Directory.Packages.props
- [ ] T095 [P] [US5] Add Entity Framework Core NuGet packages to Directory.Packages.props
- [ ] T096 [US5] Create `src/shared/Universo.Data/` project for data access abstractions
- [ ] T097 [US5] Implement abstract RepositoryBase<T> class in `src/shared/Universo.Data/Repositories/RepositoryBase.cs`
- [ ] T098 [P] [US5] Implement SupabaseRepository<T> in `src/shared/Universo.Data/Repositories/Supabase/SupabaseRepository.cs`
- [ ] T099 [US5] Create ISupabaseClient interface in `src/shared/Universo.Data/Supabase/ISupabaseClient.cs`
- [ ] T100 [US5] Implement SupabaseClientWrapper in `src/shared/Universo.Data/Supabase/SupabaseClientWrapper.cs`
- [ ] T101 [P] [US5] Create DbContext base class in `src/shared/Universo.Data/EntityFramework/UniversoDbContext.cs`
- [ ] T102 [P] [US5] Implement EF Core repository base in `src/shared/Universo.Data/Repositories/EntityFramework/EfRepository.cs`
- [ ] T103 [US5] Create database configuration extensions in `src/shared/Universo.Data/Configuration/DatabaseServiceExtensions.cs`
- [ ] T104 [P] [US5] Implement migration strategy interface in `src/shared/Universo.Data/Migrations/IMigrationRunner.cs`
- [ ] T105 [P] [US5] Create database health check in `src/shared/Universo.Data/HealthChecks/DatabaseHealthCheck.cs`
- [ ] T106 [US5] Document database abstraction approach in `DATABASE.md` (English)
- [ ] T107 [US5] Create `DATABASE-RU.md` (Russian)
- [ ] T108 [US5] Add Universo.Data project to solution and build
- [ ] T109 [US5] Create unit tests for repository implementations in `src/shared/Universo.Data/Tests/`
- [ ] T110 [US5] Create integration tests with Testcontainers PostgreSQL in `src/shared/Universo.Data/Tests/Integration/`

**Checkpoint**: Database abstraction layer complete and tested

---

## Phase 8: Health Check API Package (Infrastructure Validation)

**Goal**: Create first real package with health check endpoints per API contracts

**Independent Test**: Health check endpoints return proper responses

**Reference**: contracts/api-contracts.md health endpoints

### Implementation

- [ ] T111 Create `src/packages/health-srv/base/` package structure
- [ ] T112 Create health-srv.csproj in `src/packages/health-srv/base/`
- [ ] T113 Add standard server package directories to health-srv
- [ ] T114 [P] Implement HealthController in `src/packages/health-srv/base/Controllers/HealthController.cs`
- [ ] T115 [P] Implement /health endpoint returning system health status
- [ ] T116 [P] Implement /health/ready endpoint for readiness probe
- [ ] T117 [P] Implement /health/live endpoint for liveness probe
- [ ] T118 [P] Implement ConfigController in `src/packages/health-srv/base/Controllers/ConfigController.cs`
- [ ] T119 [P] Implement /config/features endpoint returning feature flags
- [ ] T120 [P] Implement /config/version endpoint returning version info
- [ ] T121 Create health check service in `src/packages/health-srv/base/Services/HealthCheckService.cs`
- [ ] T122 Integrate database health check from Universo.Data
- [ ] T123 Integrate cache health check
- [ ] T124 Create Package README.md for health-srv (English)
- [ ] T125 Create Package README-RU.md for health-srv (Russian)
- [ ] T126 Add health-srv to solution and build
- [ ] T127 Create unit tests for health endpoints in `src/packages/health-srv/base/Tests/`
- [ ] T128 Create integration tests for health endpoints

**Checkpoint**: First functional package demonstrating complete pattern

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements and verification across all deliverables

- [ ] T129 [P] Verify all shared projects build independently
- [ ] T130 [P] Verify all documentation has bilingual pairs with matching structure
- [ ] T131 [P] Run code formatting on entire solution with `dotnet format`
- [ ] T132 [P] Run static analysis and fix warnings
- [ ] T133 Verify no constitution violations in implemented structure
- [ ] T134 [P] Update root README.md with links to all documentation
- [ ] T135 [P] Update root README-RU.md with links to all documentation
- [ ] T136 Create quickstart video script documentation
- [ ] T137 [P] Verify package interdependencies are one-way only
- [ ] T138 [P] Verify each package can be tested independently
- [ ] T139 Document architecture decisions in `.specify/memory/` (if needed)
- [ ] T140 Create GitHub Issue for next feature following `.github/instructions/github-issues.md`
- [ ] T141 Final full solution build and test run
- [ ] T142 Tag release v0.1.0-alpha

**Checkpoint**: Initial setup complete and ready for feature development

---

## Dependencies & Execution Order

### Phase Dependencies

```
Phase 1 (Setup)
    ↓
Phase 2 (Foundational) ← BLOCKS all user stories
    ↓
    ├→ Phase 3 (US1: Repository Structure) [P1] 🎯 MVP
    ├→ Phase 4 (US2: Documentation) [P1] 🎯 MVP
    ├→ Phase 6 (US4: Build System) [P1] 🎯 MVP
    ├→ Phase 7 (US5: Database Abstraction) [P1] 🎯 MVP
    └→ Phase 5 (US3: GitHub Integration) [P2]
         ↓
Phase 8 (Health Check Package - Validation)
    ↓
Phase 9 (Polish)
```

### User Story Dependencies

- **Phase 1 (Setup)**: No dependencies - starts immediately
- **Phase 2 (Foundational)**: Depends on Setup completion - **BLOCKS all user stories**
- **US1 (Repository Structure) [P1]**: Depends on Foundational - Can run in parallel with US2, US4, US5
- **US2 (Documentation) [P1]**: Depends on Foundational - Can run in parallel with US1, US4, US5
- **US3 (GitHub Integration) [P2]**: Depends on Foundational - Can run in parallel with other stories but lower priority
- **US4 (Build System) [P1]**: Depends on Foundational - Can run in parallel with US1, US2, US5
- **US5 (Database Abstraction) [P1]**: Depends on Foundational - Can run in parallel with US1, US2, US4
- **Phase 8 (Health Check)**: Depends on all P1 stories being complete
- **Phase 9 (Polish)**: Depends on all phases being complete

### Within Each Phase

**Phase 2 (Foundational)**:
- All shared library projects can be created in parallel (T009-T012)
- All interface/model implementations marked [P] can run in parallel (T013-T024)
- Error handling, validation, caching, rate limiting can be developed in parallel

**Phase 3 (US1)**:
- Server and frontend example packages can be created in parallel (T041-T042)
- Directory structures can be set up in parallel
- Documentation happens after structure is validated

**Phase 4 (US2)**:
- All English documentation files marked [P] can be created in parallel
- Russian versions must follow their English counterparts sequentially
- Line count verification is final step

**Phase 5 (US3)**:
- Issue templates can be created in parallel
- Workflows can be created in parallel
- Final verification is sequential

**Phase 6 (US4)**:
- Configuration files marked [P] can be created in parallel
- Build and test scripts can be created in parallel
- Final build verification is sequential

**Phase 7 (US5)**:
- Supabase and EF Core implementations can be developed in parallel
- Health checks and migrations can be developed in parallel
- Integration testing is final step

### Parallel Opportunities

**Maximum Parallelism After Foundational Phase**:
```bash
# After Phase 2 completes, these can ALL run in parallel:
Developer A: Phase 3 (US1 - Repository Structure)
Developer B: Phase 4 (US2 - Documentation)  
Developer C: Phase 6 (US4 - Build System)
Developer D: Phase 7 (US5 - Database Abstraction)
Developer E: Phase 5 (US3 - GitHub Integration)
```

**Within Phase 2 (Foundational), these can run in parallel**:
```bash
# Core types and interfaces (all [P] marked):
Task T013-T024: All shared types and interfaces
Task T026: Custom exception types
Task T031-T032: Caching service implementations
Task T035-T036: Rate limiter implementations
```

---

## Parallel Example: Phase 2 (Foundational)

Launch together after shared projects created:

```bash
# All these can be developed simultaneously:
Task T013: BaseEntity record
Task T014: IContainerEntity interface  
Task T015: IGroupEntity interface
Task T016: IItemEntity interface
Task T017: IRepository<T> interface
Task T018: PackageMetadata record
Task T019: DatabaseConfiguration record
Task T020: SupabaseConfiguration record
Task T021: ApiResponse<T> record
Task T022: PagedResult<T> record
Task T023: ValidationResult record
Task T024: ValidationError record
```

---

## Implementation Strategy

### MVP First (Minimum Viable Product)

**MVP = Phases 1, 2, 3, 4, 6, 7 (all P1 stories)**

1. Complete Phase 1: Setup (T001-T008)
2. Complete Phase 2: Foundational (T009-T040) - **CRITICAL BLOCKER**
3. Complete Phase 3: US1 - Repository Structure (T041-T051) [P1]
4. Complete Phase 4: US2 - Documentation (T052-T065) [P1]
5. Complete Phase 6: US4 - Build System (T079-T093) [P1]
6. Complete Phase 7: US5 - Database Abstraction (T094-T110) [P1]
7. **VALIDATE**: Can new developer clone, build, and understand project?
8. **Optional**: Phase 5 (US3 - GitHub Integration) [P2]
9. **Optional**: Phase 8 (Health Check Package as validation)
10. Complete Phase 9: Polish

### Incremental Delivery Checkpoints

1. **Checkpoint 1**: Phase 1 complete → Basic structure exists
2. **Checkpoint 2**: Phase 2 complete → Foundation ready, can start features
3. **Checkpoint 3**: US1 complete → Package architecture validated
4. **Checkpoint 4**: US2 complete → Documentation ready for new developers
5. **Checkpoint 5**: US4 complete → Build system fully operational
6. **Checkpoint 6**: US5 complete → Database layer ready for features
7. **Checkpoint 7**: US3 complete → GitHub integration ready
8. **Checkpoint 8**: Phase 8 complete → First functional package exists
9. **Checkpoint 9**: All complete → Ready for feature development (Clusters, Metaverses, etc.)

### Parallel Team Strategy

**With 5 developers after Phase 2**:
```
Foundation Team (2 devs): Phase 1 + Phase 2 together
    ↓ BLOCKER RELEASED
Dev A: Phase 3 (US1 - Repository Structure)
Dev B: Phase 4 (US2 - Documentation)
Dev C: Phase 6 (US4 - Build System)
Dev D: Phase 7 (US5 - Database Abstraction)
Dev E: Phase 5 (US3 - GitHub Integration)
    ↓ ALL CONVERGE
All Devs: Phase 8 validation + Phase 9 polish together
```

**With 2 developers**:
```
Both: Phase 1 + Phase 2 together
Dev A: Phase 3 (US1) → Phase 6 (US4)
Dev B: Phase 4 (US2) → Phase 7 (US5)
Both: Phase 5 (US3)
Both: Phase 8 + Phase 9
```

**Solo developer (sequential by priority)**:
```
1. Phase 1 (Setup)
2. Phase 2 (Foundational) ← Critical path
3. Phase 3 (US1 - Repository Structure) [P1]
4. Phase 4 (US2 - Documentation) [P1]
5. Phase 6 (US4 - Build System) [P1]
6. Phase 7 (US5 - Database Abstraction) [P1]
7. Phase 5 (US3 - GitHub Integration) [P2]
8. Phase 8 (Health Check Package)
9. Phase 9 (Polish)
```

---

## Task Summary

**Total Tasks**: 142

**Breakdown by Phase**:
- Phase 1 (Setup): 8 tasks
- Phase 2 (Foundational): 32 tasks (includes infrastructure for all 4 new constitution principles)
- Phase 3 (US1 - Repository Structure): 11 tasks [P1]
- Phase 4 (US2 - Documentation): 14 tasks [P1]
- Phase 5 (US3 - GitHub Integration): 13 tasks [P2]
- Phase 6 (US4 - Build System): 15 tasks [P1]
- Phase 7 (US5 - Database Abstraction): 17 tasks [P1]
- Phase 8 (Health Check Package): 18 tasks
- Phase 9 (Polish): 14 tasks

**Parallelizable Tasks**: 76 tasks marked with [P]

**MVP Scope** (P1 priorities): Phases 1, 2, 3, 4, 6, 7 = 97 tasks

**Constitution Compliance**:
- ✅ Monorepo Package Architecture (Principle I) - Phase 3 (US1)
- ✅ Frontend/Backend Separation (Principle II) - Phase 3 (US1)
- ✅ Base Implementation Pattern (Principle III) - Phase 3 (US1)
- ✅ Bilingual Documentation (Principle IV) - Phase 4 (US2)
- ✅ Independent Package Testability (Principle V) - Phase 6 (US4)
- ✅ GitHub Workflow Integration (Principle VI) - Phase 5 (US3)
- ✅ Multi-Database Preparedness (Principle VII) - Phase 7 (US5)
- ✅ Three-Entity Domain Pattern (Principle VIII) - Phase 2 (interfaces)
- ✅ Template System Architecture (Principle IX) - Phase 3 (example packages)
- ✅ Async Initialization Pattern (Principle X) - Phase 2 (IHostedService ready)
- ✅ Error Handling Architecture (Principle XI) - Phase 2 (T025-T027)
- ✅ Validation Strategy (Principle XII) - Phase 2 (T028-T030)
- ✅ Caching Strategy (Principle XIII) - Phase 2 (T031-T033)
- ✅ API Security & Rate Limiting (Principle XIV) - Phase 2 (T034-T036)

---

## Notes

- **[P] marker**: Tasks can run in parallel (different files, no blocking dependencies)
- **[Story] label**: Maps task to specific user story for traceability (US1-US5)
- **MVP indicators**: 🎯 marks phases critical for minimum viable product
- **Constitution alignment**: All 14 constitution principles addressed in task breakdown
- **Tests**: Not explicitly requested, focus on build verification and infrastructure validation
- **Bilingual requirement**: Every English documentation file has matching Russian version
- **Package structure**: ALL tasks maintain package-based architecture (Principle I - NON-NEGOTIABLE)
- **Independent testability**: Each package and shared library can be built/tested independently
- **Technology choices**: Based on research.md findings (Clean Architecture, MudBlazor, FluentValidation, xUnit, Testcontainers)

---

## Success Validation

Upon completion of all tasks:

✅ Repository has `src/packages/` directory structure (Constitution compliant)  
✅ All documentation is bilingual with matching structure  
✅ Solution builds with `dotnet build` successfully  
✅ All tests pass with `dotnet test`  
✅ GitHub labels and templates exist  
✅ Database abstraction layer is implementation-agnostic  
✅ New developer can clone and build following documentation  
✅ Example package demonstrates complete pattern  
✅ Health check endpoints validate infrastructure  
✅ No constitution principle violations  
✅ Ready for feature development (Clusters, Metaverses, Auth, etc.)

---

**End of Tasks Document**
