# Architectural Updates Needed

**Date**: 2025-11-17  
**Based On**: Deep Architectural Comparison Analysis  
**Status**: Action Items Identified

## Overview

This document lists specific updates needed to align the C# implementation plans with architectural patterns identified in the React source project. These updates should be made before beginning Phase 1 implementation.

## Critical Updates (Must Complete Before Phase 1)

### 1. Constitution Updates

**File**: `.specify/memory/constitution.md`

**New Principles to Add**:

#### XI. Error Handling Architecture
All packages MUST implement centralized error handling:
- Global exception middleware for ASP.NET Core backends
- Structured error responses with consistent format
- Error logging with severity levels
- Blazor error boundaries for frontend
- Custom exception types for domain errors
- Health check endpoints for system status

**Rationale**: The React implementation demonstrates robust error handling through Express middleware and React error boundaries. This pattern prevents inconsistent error responses and improves debugging.

#### XII. Validation Strategy
All data input MUST be validated at API boundaries:
- FluentValidation for request DTOs
- Model state validation in controllers
- Custom validation attributes for domain rules
- Validation errors returned in standardized format
- Validation at both client (Blazor) and server (ASP.NET)

**Rationale**: React's Zod schema validation ensures data integrity. C# equivalent using FluentValidation provides type-safe validation with reusable rules.

#### XIII. Caching Strategy
Performance-critical data MUST use appropriate caching:
- Memory cache for frequently accessed reference data
- Distributed cache (Redis) for session and user data
- Cache invalidation strategy documented per feature
- TTL (Time To Live) configured per data type
- Cache-aside pattern for database queries

**Rationale**: React's Redis integration shows the importance of caching for scalability. C# implementation needs explicit caching strategy from day one.

#### XIV. API Security & Rate Limiting
All public APIs MUST implement rate limiting:
- IP-based rate limiting for anonymous endpoints
- User-based rate limiting for authenticated endpoints
- Configurable limits per endpoint category
- Rate limit headers in responses (X-RateLimit-*)
- Graceful degradation when limits exceeded

**Rationale**: React's express-rate-limit middleware protects against abuse. Enterprise deployments require this from the start.

### 2. Implementation Roadmap Updates

**File**: `IMPLEMENTATION_ROADMAP.md`

**Phase 1 Additions**:

Add new section **1.3 Cross-Cutting Infrastructure (Week 3-4)**:

#### Error Handling Infrastructure
**Tasks**:
- Create `Universo.Common` package
- Implement global exception middleware
- Define standard error response DTOs
- Create custom exception hierarchy
- Add Blazor error boundary components
- Configure structured logging (Serilog)

**Deliverables**:
- `GlobalExceptionMiddleware.cs`
- `ErrorResponse.cs` and related DTOs
- Custom exception types (ValidationException, NotFoundException, etc.)
- Error boundary components
- Logging configuration

**Acceptance Criteria**:
- All unhandled exceptions caught and logged
- Consistent error JSON structure across all endpoints
- HTTP status codes correctly assigned
- Sensitive information never exposed in production errors

#### Validation Pipeline
**Tasks**:
- Install FluentValidation packages
- Create validation extension methods
- Implement validator for each DTO
- Configure automatic validation in ASP.NET pipeline
- Add client-side validation helpers for Blazor

**Deliverables**:
- Base validator classes
- Validator for each domain package
- Validation middleware configuration
- Blazor validation components

**Acceptance Criteria**:
- Validation executes before controller actions
- Validation errors returned in standard format
- 100% DTO coverage with validators
- Client and server validation consistent

#### Caching Infrastructure
**Tasks**:
- Configure Memory Cache
- Set up Redis distributed cache
- Create cache service abstraction
- Implement cache-aside pattern helpers
- Document cache TTL strategy

**Deliverables**:
- `ICacheService` interface
- Redis configuration
- Cache helper extensions
- TTL configuration documentation

**Acceptance Criteria**:
- Both memory and distributed cache working
- Cache keys follow naming convention
- Invalidation strategy documented
- Performance tests show caching benefit

#### Rate Limiting
**Tasks**:
- Install AspNetCoreRateLimit package
- Configure IP rate limiting
- Configure authenticated user rate limiting
- Set limits for each endpoint category
- Add rate limit response headers

**Deliverables**:
- Rate limit configuration
- Custom rate limit policies
- Rate limit middleware setup

**Acceptance Criteria**:
- Rate limits enforced on all public APIs
- Appropriate HTTP 429 responses
- Rate limit headers included
- Different limits for anonymous vs authenticated

**Phase 2 Additions**:

Add new section **API Versioning Strategy**:

#### API Versioning
**Tasks**:
- Choose versioning approach (URL-based recommended)
- Configure ASP.NET API versioning
- Create v1 API namespace
- Document deprecation policy
- Set up version discovery endpoint

**Deliverables**:
- API versioning configuration
- V1 controllers namespace
- Deprecation policy document
- API version discovery endpoint

**Acceptance Criteria**:
- All endpoints versioned
- Old versions marked deprecated with sunset date
- Version documented in Swagger
- Clients can discover available versions

### 3. Specification Template Updates

**File**: `.specify/templates/spec.md` (if exists, or create)

**Add New Sections**:

#### Error Handling Requirements
For each feature specification, add:
```markdown
### Error Handling
List expected error scenarios and responses:
- **Scenario**: [What can go wrong]
- **Exception Type**: [Custom exception to throw]
- **HTTP Status**: [Status code]
- **Error Message**: [User-friendly message]
- **Logging**: [What to log, at what level]
```

#### Validation Requirements
For each feature specification, add:
```markdown
### Validation Rules
For each DTO/input:
- **Field**: [Field name]
- **Rules**: [Required, MaxLength(255), Range, etc.]
- **Error Message**: [Validation error message]
- **Custom Logic**: [Any custom validation needed]
```

#### Performance Requirements
For each feature specification, add:
```markdown
### Performance Considerations
- **Expected Load**: [Requests per second]
- **Caching Strategy**: [What to cache, TTL]
- **Database Indexes**: [Required indexes]
- **Rate Limits**: [Endpoint-specific limits]
- **Response Time Target**: [Max acceptable latency]
```

### 4. Package Structure Updates

**All Backend Packages** (`packages/*-srv/base/`):

Add these standard directories to src/:
```
src/
├── Controllers/          # ASP.NET Core controllers
├── Services/             # Business logic
├── Repositories/         # Data access
├── Models/               # Domain models
├── Entities/             # Database entities
├── DTOs/                 # Data transfer objects
├── Validators/           # FluentValidation validators
├── Exceptions/           # Custom exceptions
├── Mapping/              # AutoMapper profiles (optional)
├── Extensions/           # Extension methods
└── Configuration/        # Configuration classes
```

**All Frontend Packages** (`packages/*-frt/base/`):

Add these standard directories to src/:
```
src/
├── Pages/                # Blazor pages
├── Components/           # Blazor components
│   ├── Common/          # Reusable components
│   └── [Feature]/       # Feature-specific components
├── Services/             # Frontend services
├── State/                # Fluxor state management
│   ├── [Feature]State.cs
│   ├── [Feature]Actions.cs
│   ├── [Feature]Reducers.cs
│   └── [Feature]Effects.cs
├── Models/               # Frontend models
├── Validators/           # Client-side validation
└── wwwroot/              # Static assets
```

## Important Updates (Should Complete During Phase 1)

### 5. Logging Strategy

**Create New Document**: `docs/logging-strategy.md`

**Content**:
- Structured logging with Serilog
- Log levels and when to use them
- Sensitive data redaction
- Log correlation IDs
- Integration with Application Insights or similar
- Log retention policy

### 6. Monitoring Strategy

**Create New Document**: `docs/monitoring-strategy.md`

**Content**:
- Health check endpoints
- Performance metrics to track
- Application Insights configuration
- Custom metrics definition
- Alerting strategy
- Dashboard requirements

### 7. Background Jobs Strategy

**Create New Document**: `docs/background-jobs-strategy.md`

**Content**:
- Choose framework (Hangfire vs Quartz.NET)
- Job scheduling patterns
- Job retry and failure handling
- Job monitoring and logging
- Long-running task management

## Optional Updates (Can Defer to Later Phases)

### 8. Feature Flags

**Create New Document**: `docs/feature-flags-strategy.md`

**Content**:
- Feature flag framework selection
- Flag naming conventions
- Progressive rollout strategy
- A/B testing support
- Feature flag cleanup process

### 9. API Documentation Standards

**Update Document**: `CONTRIBUTING.md`

**Add Section**: API Documentation
- XML documentation comment requirements
- Swagger/OpenAPI generation setup
- API example requirements
- Endpoint description standards

### 10. Performance Testing

**Create New Document**: `docs/performance-testing-strategy.md`

**Content**:
- Load testing tool selection (NBomber recommended)
- Performance test scenarios
- Acceptance criteria
- CI/CD integration

## Implementation Priority

### Priority 1: Must Have Before Phase 1 Development
1. ✅ Constitution updates (new principles XI-XIV)
2. ✅ Error handling infrastructure
3. ✅ Validation pipeline
4. ✅ Package structure standardization

### Priority 2: Must Have Before Phase 1 Completion
5. ✅ Caching infrastructure
6. ✅ Rate limiting
7. ✅ Logging strategy
8. ✅ Monitoring strategy

### Priority 3: Nice to Have for Phase 1
9. ⚠️ API versioning (can start in Phase 2)
10. ⚠️ Background jobs (needed for specific features)

### Priority 4: Future Phases
11. ⚠️ Feature flags (Phase 3+)
12. ⚠️ Performance testing (Phase 2-3)

## Action Items Summary

### Immediate Actions (This Week)
- [ ] Update constitution with 4 new principles
- [ ] Update implementation roadmap Phase 1 with new sections
- [ ] Create specification template with new sections
- [ ] Document standard package structure

### Short-Term Actions (Next 2 Weeks)
- [ ] Implement error handling infrastructure
- [ ] Implement validation pipeline
- [ ] Set up caching infrastructure
- [ ] Configure rate limiting

### Medium-Term Actions (Phase 1)
- [ ] Create logging strategy document
- [ ] Create monitoring strategy document
- [ ] Create background jobs strategy document
- [ ] Implement API versioning

### Long-Term Actions (Phase 2+)
- [ ] Create feature flags strategy document
- [ ] Create performance testing strategy document
- [ ] Implement advanced monitoring
- [ ] Set up load testing infrastructure

## Review Checkpoints

### Checkpoint 1: Before Phase 1 Starts
Verify:
- ✅ Constitution updated and ratified
- ✅ Roadmap updated with infrastructure tasks
- ✅ Package structure documented
- ✅ Specification templates updated

### Checkpoint 2: Mid-Phase 1
Verify:
- ✅ Error handling working across all packages
- ✅ Validation pipeline enforced
- ✅ Caching infrastructure operational
- ✅ Rate limiting configured

### Checkpoint 3: End of Phase 1
Verify:
- ✅ All infrastructure patterns implemented
- ✅ Documentation complete
- ✅ Tests passing
- ✅ Constitution compliance verified

## Success Metrics

After implementing these updates, we should achieve:

1. **Consistency**: All packages follow same structure and patterns
2. **Robustness**: Error handling prevents crashes and data corruption
3. **Security**: Rate limiting and validation protect against attacks
4. **Performance**: Caching reduces database load and improves response times
5. **Maintainability**: Clear patterns make onboarding and development easier
6. **Observability**: Logging and monitoring enable quick issue resolution

## Questions to Resolve

1. **Caching**: Redis vs other distributed cache providers?
2. **Logging**: Application Insights vs Seq vs ELK stack?
3. **Background Jobs**: Hangfire vs Quartz.NET?
4. **API Versioning**: URL-based vs header-based?
5. **Feature Flags**: LaunchDarkly vs custom solution vs none?

These questions should be answered in Phase 0 research or early Phase 1.

---

**Document Version**: 1.0  
**Last Updated**: 2025-11-17  
**Owner**: Architecture Team  
**Next Review**: Before Phase 1 implementation begins
