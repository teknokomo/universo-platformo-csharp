---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Universo Platformo CSharp**: `packages/[feature]-srv/base/`, `packages/[feature]-frt/base/`
- Backend code: `packages/[feature]-srv/base/Controllers/`, `packages/[feature]-srv/base/Services/`, etc.
- Frontend code: `packages/[feature]-frt/base/Components/`, `packages/[feature]-frt/base/Pages/`, etc.
- Shared contracts: `packages/[feature]-common/base/Contracts/` (if needed)
- Tests: `packages/[feature]-srv/base/Tests/`, `packages/[feature]-frt/base/Tests/`
- Documentation: Create both `packages/[feature]-srv/README.md` and `packages/[feature]-srv/README-RU.md`

<!-- 
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.
  
  The /speckit.tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/
  
  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment
  
  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create package structure in `packages/[feature]-srv/base/` and `packages/[feature]-frt/base/`
- [ ] T002 Initialize .NET solution and projects for backend and frontend packages
- [ ] T003 [P] Configure EditorConfig and .NET formatting rules
- [ ] T004 [P] Create bilingual README.md and README-RU.md files in package roots
- [ ] T005 Setup database abstraction layer (repository pattern) in backend package

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks (adjust based on your project):

- [ ] T006 Setup Supabase connection and database abstractions in `packages/[feature]-srv/base/Repositories/`
- [ ] T007 [P] Implement ASP.NET Identity with Supabase integration
- [ ] T008 [P] Setup API routing and middleware in backend package Controllers
- [ ] T009 Create base models/entities in `packages/[feature]-srv/base/Models/`
- [ ] T010 Configure error handling and logging infrastructure
- [ ] T011 Setup environment configuration management (.NET Configuration)
- [ ] T012 [P] Create bilingual API documentation (Swagger with EN/RU descriptions)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 1 (OPTIONAL - only if tests requested) ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T013 [P] [US1] Contract test for [endpoint] in `packages/[feature]-srv/base/Tests/ContractTests/[Name]Tests.cs`
- [ ] T014 [P] [US1] Integration test for [user journey] in `packages/[feature]-srv/base/Tests/IntegrationTests/[Name]Tests.cs`
- [ ] T015 [P] [US1] Component test for [UI component] in `packages/[feature]-frt/base/Tests/[Component]Tests.cs`

### Implementation for User Story 1

- [ ] T016 [P] [US1] Create [Entity1] model in `packages/[feature]-srv/base/Models/[Entity1].cs`
- [ ] T017 [P] [US1] Create [Entity2] model in `packages/[feature]-srv/base/Models/[Entity2].cs`
- [ ] T018 [US1] Implement [Repository] in `packages/[feature]-srv/base/Repositories/[Entity]Repository.cs` (depends on T016, T017)
- [ ] T019 [US1] Implement [Service] in `packages/[feature]-srv/base/Services/[Service].cs` (depends on T018)
- [ ] T020 [US1] Implement [Controller/API endpoint] in `packages/[feature]-srv/base/Controllers/[Controller].cs`
- [ ] T021 [US1] Create Blazor component in `packages/[feature]-frt/base/Components/[Component].razor`
- [ ] T022 [US1] Create Blazor page in `packages/[feature]-frt/base/Pages/[Page].razor`
- [ ] T023 [US1] Add validation and error handling
- [ ] T024 [US1] Update package README.md and README-RU.md with usage examples

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2 (OPTIONAL - only if tests requested) ⚠️

- [ ] T018 [P] [US2] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T019 [P] [US2] Integration test for [user journey] in tests/integration/test_[name].py

### Implementation for User Story 2

- [ ] T020 [P] [US2] Create [Entity] model in src/models/[entity].py
- [ ] T021 [US2] Implement [Service] in src/services/[service].py
- [ ] T022 [US2] Implement [endpoint/feature] in src/[location]/[file].py
- [ ] T023 [US2] Integrate with User Story 1 components (if needed)

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3 (OPTIONAL - only if tests requested) ⚠️

- [ ] T024 [P] [US3] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T025 [P] [US3] Integration test for [user journey] in tests/integration/test_[name].py

### Implementation for User Story 3

- [ ] T026 [P] [US3] Create [Entity] model in src/models/[entity].py
- [ ] T027 [US3] Implement [Service] in src/services/[service].py
- [ ] T028 [US3] Implement [endpoint/feature] in src/[location]/[file].py

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Update bilingual documentation (README.md and README-RU.md) for all affected packages
- [ ] TXXX Code cleanup and refactoring across packages
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX [P] Additional unit tests (if requested) in package Tests/ directories
- [ ] TXXX Security hardening and vulnerability scanning
- [ ] TXXX Verify all packages can be built and tested independently
- [ ] TXXX Verify database abstraction layer is properly implemented
- [ ] TXXX Create GitHub Issue for this feature (if not already done) per `github-issues.md`
- [ ] TXXX Update memory bank with architecture decisions

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together (if tests requested):
Task: "Contract test for [endpoint] in tests/contract/test_[name].py"
Task: "Integration test for [user journey] in tests/integration/test_[name].py"

# Launch all models for User Story 1 together:
Task: "Create [Entity1] model in src/models/[entity1].py"
Task: "Create [Entity2] model in src/models/[entity2].py"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
