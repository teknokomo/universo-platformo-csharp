# Research Task: Find Optimal ORM for Blazor WASM + Supabase

## Project Context

**Current Stack:**
- **Frontend:** Blazor WebAssembly (C# .NET 9)
- **Database:** Supabase PostgreSQL (hosted at pleeyslewsialvplxdpg.supabase.co)
- **Current Auth:** supabase-csharp SDK (v0.16.2) for authentication
- **Architecture:** Fully client-side application (no backend server)

**Initial Migration Source:**
- TypeORM migration file (`.backup/1766351182000-CreateMetahubsSchema.ts`)
- Complex schema with:
  - Custom schema `metahubs` (not default `public`)
  - JSONB columns for i18n (VersionedLocalizedContent pattern)
  - ENUMs (attribute_data_type, publication_access_mode, publication_schema_status)
  - 5 tables with complex relationships (metahubs, metahubs_branches, metahubs_users, publications, publication_versions)
  - System fields pattern (_upl_* platform-level, _mhb_* metahub-level)
  - Row Level Security (RLS) policies
  - 22+ indexes (including GIN for JSONB, partial unique indexes)

**Problem Statement:**

We attempted to use Entity Framework Core for ORM functionality, but discovered a fundamental incompatibility:
- EF Core requires direct TCP/IP connection to PostgreSQL (Npgsql driver)
- Blazor WebAssembly runs entirely in the browser (client-side)
- Browser security (CORS, sandboxing) prevents direct database connections
- Our connection attempts fail with "Tenant or user not found" or firewall/socket errors

**Failed Approaches:**
1. EF Core with Npgsql - cannot connect from browser
2. Supabase REST API with RPC functions - works but no ORM-like migration tooling
3. Manual SQL migrations - works but defeats the purpose of using ORM

## Research Requirements

**Primary Goal:**
Find an ORM or ORM-like solution that:
1. ✅ Works with Blazor WebAssembly (client-side, browser-based)
2. ✅ Connects to Supabase PostgreSQL
3. ✅ Supports schema migrations (ideally with code-first approach)
4. ✅ Handles JSONB columns elegantly
5. ✅ Supports PostgreSQL-specific features (ENUMs, partial indexes, RLS)
6. ✅ Provides type-safe query building (LINQ-like or similar)

**Secondary Goals:**
- Migration generation from C# models (like TypeORM does from TypeScript decorators)
- Support for applying migrations programmatically or via CLI
- Good documentation and active maintenance
- Compatible with .NET 9 and modern C#

**Constraints:**
- Must work without requiring a separate backend API server
- Must be compatible with Supabase's authentication and security model
- Ideally should work with existing supabase-csharp SDK
- Budget is not a constraint - commercial solutions are acceptable

## Research Areas

Please research and evaluate:

1. **Alternative .NET ORMs:**
   - Dapper (micro-ORM) + migration tools?
   - ServiceStack.OrmLite
   - Marten (document DB approach for PostgreSQL)
   - Any other modern .NET ORMs that work with Supabase

2. **Supabase-specific solutions:**
   - Does supabase-csharp SDK have migration capabilities we missed?
   - Are there community extensions for postgrest-csharp that add ORM features?
   - Can Supabase Studio's migration features be automated?

3. **Hybrid approaches:**
   - Could we use EF Core for migration generation only (design-time), then execute via Supabase SDK?
   - GraphQL-based solutions (Hasura-style) with C# clients?
   - Code generators that produce type-safe clients from PostgreSQL schema?

4. **Architecture alternatives:**
   - Should we reconsider using Blazor Server instead of WASM?
   - Minimal ASP.NET Core API backend just for migrations?
   - Serverless functions (Azure Functions, AWS Lambda) for migration execution?

## Expected Output

Please provide:

1. **Recommended Solution:** 
   - Name and brief description
   - Why it fits our requirements
   - What compromises/trade-offs it involves

2. **Implementation Approach:**
   - High-level steps to integrate with our project
   - How migrations would be created and applied
   - Code examples or references if available

3. **Alternative Options:**
   - Second-best choice with pros/cons
   - Why you didn't recommend it as primary

4. **Migration Path:**
   - How to convert our existing TypeORM migration to the chosen solution
   - Whether manual SQL execution is unavoidable and why

## Success Criteria

The ideal solution would allow us to:
```csharp
// Define entity
public class Metahub : BaseEntity 
{
    public Guid Id { get; set; }
    public JsonDocument Name { get; set; } // JSONB
    public string Codename { get; set; }
    // ... other fields
}

// Generate migration from model changes
// $ some-cli-tool migration add CreateMetahubs

// Apply migration to Supabase
// $ some-cli-tool migration apply

// Query data type-safely
var metahubs = await context.Metahubs
    .Where(m => m.Codename == "example")
    .ToListAsync();
```

**Note:** We understand that some manual steps might be necessary. The key is minimizing SQL copypasta and maximizing type safety and maintainability.

---

## Additional Context

**Why TypeORM worked in original project:**
- Node.js backend could connect directly to PostgreSQL
- TypeORM ran server-side
- Migrations applied during deployment

**Why we can't just use EF Core:**
- Blazor WASM has no server process
- Browser cannot make raw TCP connections
- All database access must go through Supabase REST API or similar HTTP-based interface

**Current working approach (unsatisfactory):**
- Define entities in C# for type safety
- Write raw SQL for schema changes
- Use supabase-csharp SDK for CRUD operations
- Missing: automatic migration generation, schema sync validation

## Your Task

Search the internet, GitHub, NuGet, Stack Overflow, and any other relevant sources. Think deeply about the architectural constraints. Consider both mainstream and creative solutions. Prioritize practicality over theoretical purity.

**Focus on:** Real-world examples of .NET + Supabase + migrations, or similar scenarios (Blazor + remote PostgreSQL, WASM + ORM patterns, etc.)
