# Quickstart Guide: Initial Project Setup

**Feature**: 001-initial-setup  
**Audience**: Developers setting up local development environment  
**Time Required**: ~30 minutes

## Overview

This guide walks you through setting up the Universo Platformo CSharp development environment from scratch. By the end, you'll have a working monorepo with the ability to build, test, and run the platform locally.

---

## Prerequisites

### Required Software

1. **.NET 8.0 SDK or later**
   ```bash
   # Check version
   dotnet --version
   # Should output: 8.0.x or higher
   ```
   Download: https://dotnet.microsoft.com/download

2. **Git**
   ```bash
   git --version
   # Should output: 2.x or higher
   ```
   Download: https://git-scm.com/downloads

3. **IDE (Choose One)**
   - **Visual Studio 2022** (Windows/Mac) - Recommended for Windows
   - **JetBrains Rider** (Cross-platform) - Recommended for Linux/Mac
   - **Visual Studio Code** with C# extension (Cross-platform)

4. **Node.js 18+ and npm** (for documentation tooling)
   ```bash
   node --version  # Should be 18.x or higher
   npm --version
   ```
   Download: https://nodejs.org/

### Optional Tools

- **Docker Desktop** - For containerized Supabase local development
- **PostgreSQL 14+** - For local database (alternative to Supabase)
- **Postman or Insomnia** - For API testing

---

## Clone Repository

```bash
# Clone the repository
git clone https://github.com/teknokomo/universo-platformo-csharp.git
cd universo-platformo-csharp

# Check current branch
git branch --show-current
```

---

## Initial Setup

### 1. Restore .NET Dependencies

```bash
# Restore NuGet packages
dotnet restore

# Should output: "Restore succeeded"
```

### 2. Build Solution

```bash
# Build entire solution
dotnet build

# Should output: "Build succeeded. 0 Warning(s). 0 Error(s)."
```

### 3. Run Tests

```bash
# Run all tests
dotnet test

# Should output test results with all passing
```

---

## Project Structure

After setup, your directory structure looks like this:

```
universo-platformo-csharp/
├── .github/                  # GitHub Actions and templates
├── .specify/                 # Specification framework
├── packages/                 # Feature packages (empty initially)
│   └── .gitkeep
├── specs/                    # Feature specifications
│   └── 001-initial-setup/
├── src/                      # Legacy code (to be migrated)
├── .editorconfig            # Code style rules
├── .gitignore               # Git ignore patterns
├── Directory.Build.props    # Shared build configuration
├── UniversoPlatformo.sln    # Solution file
├── README.md                # English documentation
├── README-RU.md             # Russian documentation
└── LICENSE.md
```

---

## Development Workflow

### Creating a New Feature Package

1. **Create package directories**
   ```bash
   # Example: Creating "clusters" feature
   mkdir -p packages/clusters-srv/base
   mkdir -p packages/clusters-frt/base
   mkdir -p packages/clusters-common/base
   ```

2. **Create .csproj files**
   ```bash
   cd packages/clusters-srv/base
   dotnet new webapi -n UniversoPlatformo.Clusters.Server
   
   cd ../../clusters-frt/base
   dotnet new blazorwasm -n UniversoPlatformo.Clusters.Frontend
   
   cd ../../clusters-common/base
   dotnet new classlib -n UniversoPlatformo.Clusters.Common
   ```

3. **Add to solution**
   ```bash
   cd ../../../  # Back to root
   dotnet sln add packages/clusters-srv/base/UniversoPlatformo.Clusters.Server.csproj
   dotnet sln add packages/clusters-frt/base/UniversoPlatformo.Clusters.Frontend.csproj
   dotnet sln add packages/clusters-common/base/UniversoPlatformo.Clusters.Common.csproj
   ```

4. **Add package references**
   ```bash
   cd packages/clusters-srv/base
   dotnet add reference ../../clusters-common/base/UniversoPlatformo.Clusters.Common.csproj
   
   cd ../../clusters-frt/base
   dotnet add reference ../../clusters-common/base/UniversoPlatformo.Clusters.Common.csproj
   ```

### Running Backend Package

```bash
cd packages/[feature]-srv/base
dotnet run

# Server starts on https://localhost:5001 (or configured port)
```

### Running Frontend Package

```bash
cd packages/[feature]-frt/base
dotnet run

# Blazor app starts on https://localhost:5002 (or configured port)
```

### Running Tests

```bash
# Run all tests
dotnet test

# Run tests for specific package
cd packages/[feature]-srv/base
dotnet test

# Run with coverage
dotnet test /p:CollectCoverage=true /p:CoverageFormat=opencover
```

---

## Configuration

### Supabase Configuration

Create `appsettings.Development.json` in your backend package:

```json
{
  "Supabase": {
    "Url": "https://your-project.supabase.co",
    "AnonKey": "your-anon-key",
    "JwtSecret": "your-jwt-secret"
  },
  "Database": {
    "Provider": "Supabase",
    "ConnectionString": "configured-via-supabase"
  }
}
```

**Security Note**: Never commit `appsettings.Development.json` with real credentials. Use user secrets:

```bash
cd packages/[feature]-srv/base
dotnet user-secrets init
dotnet user-secrets set "Supabase:Url" "https://your-project.supabase.co"
dotnet user-secrets set "Supabase:AnonKey" "your-anon-key"
dotnet user-secrets set "Supabase:JwtSecret" "your-jwt-secret"
```

### Environment Variables

Alternative to user secrets, use environment variables:

```bash
export SUPABASE_URL="https://your-project.supabase.co"
export SUPABASE_ANON_KEY="your-anon-key"
export SUPABASE_JWT_SECRET="your-jwt-secret"
```

---

## IDE Setup

### Visual Studio 2022

1. Open `UniversoPlatformo.sln`
2. Set startup project: Right-click project → "Set as Startup Project"
3. Press F5 to run with debugging

### JetBrains Rider

1. Open `UniversoPlatformo.sln`
2. Rider will auto-detect run configurations
3. Use Run/Debug from toolbar

### Visual Studio Code

1. Install C# extension (`ms-dotnettools.csharp`)
2. Open folder in VS Code
3. Press F5 - VS Code will generate launch configurations
4. Select ".NET Core Launch (web)" configuration

---

## Code Style

Project uses `.editorconfig` for consistent code style.

**Key Rules**:
- Indent: 4 spaces
- Line endings: LF (Unix-style)
- Charset: UTF-8
- Nullable reference types: Enabled
- Use `var` for obvious types
- Follow C# naming conventions (PascalCase for public, camelCase for private)

**Format Code**:
```bash
# Format entire solution
dotnet format

# Format specific project
cd packages/[feature]-srv/base
dotnet format
```

---

## Common Tasks

### Add NuGet Package

```bash
cd packages/[feature]-srv/base
dotnet add package PackageName

# Example: Add MudBlazor to frontend
cd packages/[feature]-frt/base
dotnet add package MudBlazor
```

### Update All Packages

```bash
# From repository root
dotnet list package --outdated
dotnet tool update --global dotnet-outdated-tool
dotnet outdated --upgrade
```

### Generate Database Migrations (EF Core)

```bash
cd packages/[feature]-srv/base

# Add migration
dotnet ef migrations add InitialCreate

# Update database
dotnet ef database update

# Generate SQL script
dotnet ef migrations script > migration.sql
```

### Run Linter

```bash
# Install dotnet-format tool (once)
dotnet tool install -g dotnet-format

# Run linter
dotnet format --verify-no-changes
```

---

## Troubleshooting

### Build Errors

**Error**: "The SDK 'Microsoft.NET.Sdk.Web' specified could not be found"
```bash
# Solution: Update .NET SDK
dotnet --list-sdks
# Ensure 8.0.x is installed
```

**Error**: "Project reference could not be resolved"
```bash
# Solution: Restore packages
dotnet restore
dotnet build
```

### Runtime Errors

**Error**: "Unable to connect to Supabase"
```bash
# Check configuration
dotnet user-secrets list

# Verify Supabase URL is accessible
curl https://your-project.supabase.co/rest/v1/
```

**Error**: "Port already in use"
```bash
# Find process using port
# Windows: netstat -ano | findstr :5001
# Linux/Mac: lsof -i :5001

# Change port in launchSettings.json or kill process
```

### Test Failures

```bash
# Run tests with verbose output
dotnet test --logger "console;verbosity=detailed"

# Run single test
dotnet test --filter "FullyQualifiedName~YourTestName"
```

---

## Next Steps

After completing initial setup:

1. **Read Documentation**
   - [README.md](../../../README.md) - Project overview
   - [CONTRIBUTING.md](../../../CONTRIBUTING.md) - Contribution guidelines
   - [Constitution](../../memory/constitution.md) - Core principles

2. **Create GitHub Issue**
   - Follow [github-issues.md](../../../.github/instructions/github-issues.md)
   - Use appropriate labels from [github-labels.md](../../../.github/instructions/github-labels.md)

3. **Implement First Feature**
   - Start with "Clusters" feature (three-entity pattern example)
   - Follow specification process in `.specify/`

4. **Join Community**
   - Review existing issues and PRs
   - Ask questions in discussions

---

## Additional Resources

- **.NET Documentation**: https://learn.microsoft.com/en-us/dotnet/
- **Blazor Documentation**: https://learn.microsoft.com/en-us/aspnet/core/blazor/
- **MudBlazor Components**: https://mudblazor.com/
- **Supabase Docs**: https://supabase.com/docs
- **Entity Framework Core**: https://learn.microsoft.com/en-us/ef/core/

---

## Getting Help

**Questions?**
- Check existing issues: https://github.com/teknokomo/universo-platformo-csharp/issues
- Create new issue with `question` label
- Include error messages, logs, and steps to reproduce

**Bug Reports**
- Use `bug` label
- Provide minimal reproduction
- Include environment details (OS, .NET version, IDE)

**Feature Requests**
- Use `enhancement` label
- Explain use case and motivation
- Check if similar request exists

---

**Last Updated**: 2025-11-17  
**Maintainers**: @teknokomo team  
**Status**: ✅ Complete
