# Phase 1: Data Model Design

**Feature**: Initial Project Setup (001-initial-setup)  
**Date**: 2025-11-17  
**Status**: Complete

## Overview

This document defines the foundational data models for the Universo Platformo CSharp project structure. Since this is the initial setup phase, we focus on meta-models that describe the project organization rather than domain entities.

---

## Project Configuration Models

### 1. PackageMetadata

Represents metadata for each package in the monorepo.

```csharp
namespace UniversoPlatformo.Core.Metadata;

/// <summary>
/// Metadata describing a package in the monorepo.
/// </summary>
public record PackageMetadata
{
    /// <summary>
    /// Unique package identifier (e.g., "clusters-srv").
    /// </summary>
    public required string PackageId { get; init; }
    
    /// <summary>
    /// Package type: frt (frontend), srv (server), or common (shared).
    /// </summary>
    public required PackageType Type { get; init; }
    
    /// <summary>
    /// Domain this package belongs to (e.g., "clusters", "metaverses").
    /// </summary>
    public required string Domain { get; init; }
    
    /// <summary>
    /// Implementation variant (typically "base" for primary implementation).
    /// </summary>
    public string Variant { get; init; } = "base";
    
    /// <summary>
    /// Package version following semantic versioning.
    /// </summary>
    public required string Version { get; init; }
    
    /// <summary>
    /// Package dependencies (other package IDs).
    /// </summary>
    public IReadOnlyList<string> Dependencies { get; init; } = [];
    
    /// <summary>
    /// Brief description of package purpose.
    /// </summary>
    public string? Description { get; init; }
}

/// <summary>
/// Package type classification.
/// </summary>
public enum PackageType
{
    /// <summary>Frontend package (Blazor WebAssembly).</summary>
    Frontend,
    
    /// <summary>Server/backend package (ASP.NET Core).</summary>
    Server,
    
    /// <summary>Shared package (contracts, models, utilities).</summary>
    Common
}
```

**Rationale**: This model enables tooling to understand the monorepo structure, validate dependencies, and generate documentation.

---

## Configuration Models

### 2. DatabaseConfiguration

Configuration for database connection and provider selection.

```csharp
namespace UniversoPlatformo.Core.Configuration;

/// <summary>
/// Database configuration supporting multiple providers.
/// </summary>
public record DatabaseConfiguration
{
    /// <summary>
    /// Database provider type.
    /// </summary>
    public required DatabaseProvider Provider { get; init; }
    
    /// <summary>
    /// Connection string or configuration reference.
    /// </summary>
    public required string ConnectionString { get; init; }
    
    /// <summary>
    /// Whether to run migrations on startup.
    /// </summary>
    public bool AutoMigrate { get; init; } = false;
    
    /// <summary>
    /// Maximum connection pool size.
    /// </summary>
    public int MaxPoolSize { get; init; } = 100;
    
    /// <summary>
    /// Command timeout in seconds.
    /// </summary>
    public int CommandTimeout { get; init; } = 30;
}

/// <summary>
/// Supported database providers.
/// </summary>
public enum DatabaseProvider
{
    /// <summary>Supabase REST API.</summary>
    Supabase,
    
    /// <summary>PostgreSQL via Entity Framework Core.</summary>
    PostgreSQL,
    
    /// <summary>SQL Server via Entity Framework Core.</summary>
    SqlServer,
    
    /// <summary>SQLite for testing/development.</summary>
    SQLite
}
```

**Rationale**: Abstracts database provider selection, enabling easy switching between Supabase and direct database connections.

---

### 3. SupabaseConfiguration

Specific configuration for Supabase API access.

```csharp
namespace UniversoPlatformo.Core.Configuration;

/// <summary>
/// Configuration for Supabase API integration.
/// </summary>
public record SupabaseConfiguration
{
    /// <summary>
    /// Supabase project URL.
    /// </summary>
    public required string Url { get; init; }
    
    /// <summary>
    /// Supabase anonymous/public key.
    /// </summary>
    public required string AnonKey { get; init; }
    
    /// <summary>
    /// Optional service role key for server-side operations.
    /// </summary>
    public string? ServiceRoleKey { get; init; }
    
    /// <summary>
    /// JWT secret for token validation.
    /// </summary>
    public required string JwtSecret { get; init; }
    
    /// <summary>
    /// Whether to use realtime subscriptions.
    /// </summary>
    public bool EnableRealtime { get; init; } = false;
}
```

**Rationale**: Encapsulates Supabase-specific configuration, keeping it separate from general database configuration.

---

## Base Entity Pattern

### 4. BaseEntity

Abstract base class for all domain entities.

```csharp
namespace UniversoPlatformo.Core.Models;

/// <summary>
/// Base class for all entities with common fields.
/// </summary>
public abstract record BaseEntity
{
    /// <summary>
    /// Unique identifier (UUID).
    /// </summary>
    public required Guid Id { get; init; }
    
    /// <summary>
    /// Entity creation timestamp (UTC).
    /// </summary>
    public required DateTimeOffset CreatedAt { get; init; }
    
    /// <summary>
    /// Last update timestamp (UTC).
    /// </summary>
    public DateTimeOffset? UpdatedAt { get; init; }
    
    /// <summary>
    /// User ID who created this entity.
    /// </summary>
    public Guid? CreatedBy { get; init; }
    
    /// <summary>
    /// User ID who last updated this entity.
    /// </summary>
    public Guid? UpdatedBy { get; init; }
}
```

**Rationale**: Provides consistent audit fields across all entities, supporting the constitution's three-entity domain pattern.

---

### 5. ThreeEntityPattern Interfaces

Generic interfaces for the three-entity hierarchical pattern.

```csharp
namespace UniversoPlatformo.Core.Models;

/// <summary>
/// Top-level container entity (e.g., Cluster, Metaverse, Unik).
/// </summary>
public interface IContainerEntity
{
    Guid Id { get; }
    string Name { get; }
    string? Description { get; }
    IReadOnlyList<Guid> GroupIds { get; }
}

/// <summary>
/// Mid-level grouping entity (e.g., Domain, Section, Space).
/// </summary>
public interface IGroupEntity
{
    Guid Id { get; }
    string Name { get; }
    Guid ContainerId { get; }
    IReadOnlyList<Guid> ItemIds { get; }
}

/// <summary>
/// Bottom-level item entity (e.g., Resource, Entity, Node).
/// </summary>
public interface IItemEntity
{
    Guid Id { get; }
    string Name { get; }
    Guid GroupId { get; }
}
```

**Rationale**: Defines the three-entity pattern from constitution principle VIII, enabling consistent implementation across domains.

---

## Repository Abstraction

### 6. IRepository<T>

Generic repository interface for data access.

```csharp
namespace UniversoPlatformo.Core.Repositories;

/// <summary>
/// Generic repository interface for entity CRUD operations.
/// </summary>
/// <typeparam name="T">Entity type inheriting from BaseEntity.</typeparam>
public interface IRepository<T> where T : BaseEntity
{
    /// <summary>
    /// Get entity by ID.
    /// </summary>
    Task<T?> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Get all entities with optional filtering.
    /// </summary>
    Task<IReadOnlyList<T>> GetAllAsync(
        Expression<Func<T, bool>>? predicate = null,
        CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Create new entity.
    /// </summary>
    Task<T> CreateAsync(T entity, CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Update existing entity.
    /// </summary>
    Task<T> UpdateAsync(T entity, CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Delete entity by ID.
    /// </summary>
    Task<bool> DeleteAsync(Guid id, CancellationToken cancellationToken = default);
    
    /// <summary>
    /// Check if entity exists.
    /// </summary>
    Task<bool> ExistsAsync(Guid id, CancellationToken cancellationToken = default);
}
```

**Rationale**: Provides consistent data access API across all repositories, enabling easy switching between Supabase and EF Core implementations.

---

## Validation Models

### 7. ValidationResult

Represents validation outcome for entities.

```csharp
namespace UniversoPlatformo.Core.Validation;

/// <summary>
/// Result of entity validation.
/// </summary>
public record ValidationResult
{
    /// <summary>
    /// Whether validation passed.
    /// </summary>
    public required bool IsValid { get; init; }
    
    /// <summary>
    /// Collection of validation errors.
    /// </summary>
    public IReadOnlyList<ValidationError> Errors { get; init; } = [];
    
    /// <summary>
    /// Create a successful validation result.
    /// </summary>
    public static ValidationResult Success() => new() { IsValid = true };
    
    /// <summary>
    /// Create a failed validation result with errors.
    /// </summary>
    public static ValidationResult Failure(params ValidationError[] errors) => 
        new() { IsValid = false, Errors = errors };
}

/// <summary>
/// Individual validation error.
/// </summary>
public record ValidationError
{
    /// <summary>
    /// Property name that failed validation.
    /// </summary>
    public required string PropertyName { get; init; }
    
    /// <summary>
    /// Error message.
    /// </summary>
    public required string ErrorMessage { get; init; }
    
    /// <summary>
    /// Error code for internationalization.
    /// </summary>
    public string? ErrorCode { get; init; }
}
```

**Rationale**: Standardized validation result pattern used throughout the application, supporting both client and server-side validation.

---

## API Response Models

### 8. ApiResponse<T>

Standard API response wrapper.

```csharp
namespace UniversoPlatformo.Core.Api;

/// <summary>
/// Standard API response wrapper.
/// </summary>
/// <typeparam name="T">Response data type.</typeparam>
public record ApiResponse<T>
{
    /// <summary>
    /// Whether the request was successful.
    /// </summary>
    public required bool Success { get; init; }
    
    /// <summary>
    /// Response data (null on failure).
    /// </summary>
    public T? Data { get; init; }
    
    /// <summary>
    /// Error message (null on success).
    /// </summary>
    public string? ErrorMessage { get; init; }
    
    /// <summary>
    /// Error code for client handling.
    /// </summary>
    public string? ErrorCode { get; init; }
    
    /// <summary>
    /// Additional metadata (e.g., pagination info).
    /// </summary>
    public Dictionary<string, object>? Metadata { get; init; }
    
    /// <summary>
    /// Create a successful response.
    /// </summary>
    public static ApiResponse<T> Ok(T data, Dictionary<string, object>? metadata = null) =>
        new() { Success = true, Data = data, Metadata = metadata };
    
    /// <summary>
    /// Create an error response.
    /// </summary>
    public static ApiResponse<T> Error(string message, string? code = null) =>
        new() { Success = false, ErrorMessage = message, ErrorCode = code };
}
```

**Rationale**: Consistent API response format across all endpoints, simplifying client-side error handling.

---

## Pagination Models

### 9. PagedResult<T>

Paginated collection response.

```csharp
namespace UniversoPlatformo.Core.Api;

/// <summary>
/// Paginated collection of items.
/// </summary>
/// <typeparam name="T">Item type.</typeparam>
public record PagedResult<T>
{
    /// <summary>
    /// Items in current page.
    /// </summary>
    public required IReadOnlyList<T> Items { get; init; }
    
    /// <summary>
    /// Current page number (1-based).
    /// </summary>
    public required int Page { get; init; }
    
    /// <summary>
    /// Items per page.
    /// </summary>
    public required int PageSize { get; init; }
    
    /// <summary>
    /// Total number of items across all pages.
    /// </summary>
    public required int TotalCount { get; init; }
    
    /// <summary>
    /// Total number of pages.
    /// </summary>
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);
    
    /// <summary>
    /// Whether there is a next page.
    /// </summary>
    public bool HasNextPage => Page < TotalPages;
    
    /// <summary>
    /// Whether there is a previous page.
    /// </summary>
    public bool HasPreviousPage => Page > 1;
}
```

**Rationale**: Standard pagination pattern for list endpoints, supporting consistent UI implementation.

---

## Model Summary

| Model | Purpose | Package Location |
|-------|---------|------------------|
| PackageMetadata | Monorepo package description | Core/Common |
| DatabaseConfiguration | Database provider config | Core/Common |
| SupabaseConfiguration | Supabase-specific config | Core/Common |
| BaseEntity | Base class for domain entities | Core/Common |
| IContainerEntity | Top-level entity interface | Core/Common |
| IGroupEntity | Mid-level entity interface | Core/Common |
| IItemEntity | Bottom-level entity interface | Core/Common |
| IRepository<T> | Generic repository interface | Core/Common |
| ValidationResult | Validation outcome | Core/Common |
| ApiResponse<T> | Standard API response | Core/Common |
| PagedResult<T> | Paginated collection | Core/Common |

**Implementation Note**: All these models should be placed in a `shared-common` package under `packages/shared-common/base/` to be shared across all feature packages.

---

## Database Schema (Initial Setup)

For the initial setup phase, no database tables are created yet. Schema design will occur during feature implementation (e.g., Clusters feature will define Clusters, Domains, Resources tables).

However, we establish conventions:

### Naming Conventions
- **Tables**: PascalCase singular (e.g., `Cluster`, `Domain`, `Resource`)
- **Columns**: PascalCase (e.g., `Id`, `CreatedAt`, `UpdatedAt`)
- **Foreign Keys**: `{Entity}Id` (e.g., `ClusterId`, `DomainId`)
- **Junction Tables**: `{Entity1}{Entity2}` (e.g., `UserCluster`)

### Standard Columns
All tables must include:
- `Id` (UUID, primary key)
- `CreatedAt` (timestamp with timezone, not null)
- `UpdatedAt` (timestamp with timezone, nullable)
- `CreatedBy` (UUID, nullable, foreign key to Users)
- `UpdatedBy` (UUID, nullable, foreign key to Users)

---

## Next Steps

1. **Phase 1 Continuation**: Create API contracts in `contracts/` directory
2. **Phase 1 Completion**: Generate quickstart.md documentation
3. **Phase 2**: Break down implementation into tasks using `/speckit.tasks` command

**Phase 1 Status**: Data model design complete. Ready for API contracts definition.
