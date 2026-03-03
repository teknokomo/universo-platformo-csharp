# API Host - Backend Service

**Package**: `api-host-srv/base`  
**Type**: Backend Service (ASP.NET Core Web API)  
**Version**: 0.1.0-alpha  
**Status**: In Development

## Overview

The API Host is the main entry point for the Universo Platformo backend. It aggregates and hosts all feature packages (-srv packages), providing a unified API surface for the frontend application.

## Purpose

- **Composition**: Aggregates all backend feature packages into a single deployable application
- **Configuration**: Centralized configuration for authentication, caching, rate limiting, and CORS
- **Documentation**: Provides Swagger/OpenAPI documentation for all endpoints
- **Middleware**: Configures cross-cutting concerns (logging, error handling, security)
- **Hosting**: Production-ready ASP.NET Core host with health checks and monitoring

## Architecture

This package follows the **Application Host Pattern** from Constitution Principle I:

```
api-host-srv/base/
├── Program.cs                    # Main entry point
├── appsettings.json              # Base configuration
├── appsettings.Development.json  # Development overrides
├── appsettings.Production.json   # Production overrides
└── README.md                     # This file
```

## Features

### Current Implementation

- ✅ **Serilog Logging**: Structured logging with console and file sinks
- ✅ **Swagger/OpenAPI**: Auto-generated API documentation
- ✅ **CORS Support**: Configurable cross-origin resource sharing
- ✅ **Health Checks**: Basic health endpoint at `/health`
- ✅ **Memory Caching**: IMemoryCache for local caching
- ✅ **Rate Limiting**: Global rate limiting with fixed window algorithm
- ✅ **Controllers**: MVC controller support

### Planned Features

- ⏳ **Service Registration**: Auto-registration of all -srv package services (T142.4)
- ⏳ **JWT Authentication**: Supabase JWT validation (T142.8)
- ⏳ **Error Handling**: Global exception handler with ProblemDetails (T142.5)
- ⏳ **Distributed Caching**: Redis support (T142.12)
- ⏳ **Distributed Rate Limiting**: Redis-backed rate limiting (T142.13)
- ⏳ **Package Discovery**: Dynamic controller and service discovery

## Configuration

### Environment Variables (Production)

Required environment variables for production deployment:

```bash
# Database
DB_HOST=your-db-host
DB_PORT=5432
DB_NAME=universo_platformo
DB_USER=your-db-user
DB_PASSWORD=your-db-password

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-key
SUPABASE_JWT_SECRET=your-jwt-secret

# JWT
JWT_ISSUER=https://your-project.supabase.co/auth/v1

# Frontend
FRONTEND_URL=https://your-frontend-domain.com

# Redis (optional, for distributed caching)
REDIS_CONNECTION_STRING=your-redis-host:6379

# Hosting
ALLOWED_HOSTS=your-api-domain.com
```

### Configuration Sections

#### Supabase

```json
{
  "Supabase": {
    "Url": "https://your-project.supabase.co",
    "Key": "your-anon-key",
    "JwtSecret": "your-jwt-secret"
  }
}
```

#### CORS

```json
{
  "Cors": {
    "AllowedOrigins": ["http://localhost:5173"],
    "AllowCredentials": true,
    "AllowedMethods": ["GET", "POST", "PUT", "DELETE"],
    "AllowedHeaders": ["*"]
  }
}
```

#### Rate Limiting

```json
{
  "RateLimiting": {
    "EnableGlobalRateLimit": true,
    "GlobalRateLimit": {
      "PermitLimit": 100,
      "WindowInMinutes": 1
    }
  }
}
```

#### Caching

```json
{
  "Caching": {
    "DefaultExpirationMinutes": 15,
    "UseDistributedCache": false,
    "MemoryCacheOptions": {
      "SizeLimit": 1024
    }
  }
}
```

## Running Locally

### Prerequisites

- .NET 9.0 SDK or later
- PostgreSQL (if using database)
- Redis (optional, for distributed caching)
- Supabase account (for authentication)

### Development Mode

```bash
# From repository root
cd src/packages/api-host-srv/base

# Run the API
dotnet run

# Or with watch mode (auto-reload)
dotnet watch run
```

The API will start on:
- HTTP: http://localhost:5000
- HTTPS: https://localhost:5001

Swagger UI available at: http://localhost:5000

### Building

```bash
# Debug build
dotnet build

# Release build
dotnet build -c Release

# Publish for deployment
dotnet publish -c Release -o ./publish
```

## Endpoints

### Built-in Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Health check endpoint |
| GET | `/api/hello` | Test endpoint |
| GET | `/swagger` | Swagger UI |
| GET | `/swagger/v1/swagger.json` | OpenAPI specification |

### Feature Package Endpoints

Feature packages will register their own controllers:

- `/api/auth/*` - Authentication (auth-srv)
- `/api/clusters/*` - Clusters management (clusters-srv)
- `/api/metaverses/*` - Metaverses management (metaverses-srv)
- `/api/uniks/*` - Uniks/workspaces management (uniks-srv)
- `/api/spaces/*` - Spaces/canvases management (spaces-srv)
- `/api/profile/*` - User profile (profile-srv)
- `/api/organizations/*` - Organizations (organizations-srv)
- `/api/storage/*` - File storage (storages-srv)
- `/api/publish/*` - Publishing system (publish-srv)

## Dependencies

### NuGet Packages

- `Microsoft.AspNetCore.Authentication.JwtBearer` - JWT authentication
- `Microsoft.Extensions.Configuration.Json` - JSON configuration
- `Serilog.AspNetCore` - Logging framework
- `Swashbuckle.AspNetCore` - Swagger/OpenAPI

### Project References

- `Universo.Types` - Shared types and interfaces
- `Universo.Utils` - Utility functions
- `Universo.I18n` - Internationalization

## Logging

Logs are written to:

- **Console**: Structured output with colors (development)
- **File**: `logs/api-host-YYYYMMDD.log` (rotating daily)

Log levels:
- Development: Debug
- Production: Warning

## Security

### Current Security Features

- ✅ HTTPS redirection (production only)
- ✅ CORS with configurable origins
- ✅ Rate limiting by IP address
- ✅ Health checks without authentication

### Planned Security Features

- ⏳ JWT token validation
- ⏳ Role-based authorization
- ⏳ API key authentication for service-to-service
- ⏳ Request logging and audit trail

## Monitoring

### Health Checks

The `/health` endpoint provides basic health status. Future enhancements will include:

- Database connectivity
- Redis connectivity
- Supabase availability
- Memory usage
- Disk space

### Metrics

Planned metrics integration:
- Request duration
- Request count by endpoint
- Error rates
- Cache hit/miss rates

## Deployment

### Docker

```dockerfile
# Example Dockerfile (to be created)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "api-host-srv.dll"]
```

### Azure App Service

The API can be deployed to Azure App Service:

```bash
az webapp up --name universo-api --resource-group universo-rg --runtime "DOTNETCORE:9.0"
```

### Kubernetes

Example deployment configuration (to be created in deployment/).

## Testing

```bash
# Run unit tests
dotnet test

# Run with coverage
dotnet test --collect:"XPlat Code Coverage"
```

## Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   # Change port in appsettings.json or use:
   dotnet run --urls "http://localhost:5001"
   ```

2. **CORS errors**
   - Check `Cors.AllowedOrigins` in appsettings.json
   - Ensure frontend URL is included
   - Verify `AllowCredentials` is set correctly

3. **JWT validation fails**
   - Verify `Supabase.JwtSecret` matches Supabase project
   - Check `Jwt.Issuer` matches Supabase auth URL
   - Ensure token is sent in `Authorization: Bearer <token>` header

## Contributing

See root [CONTRIBUTING.md](../../../../CONTRIBUTING.md) for development workflow.

## License

Licensed under the Omsk Open License. See root [LICENSE.md](../../../../LICENSE.md).

## Related Documentation

- [Architecture Overview](../../../../ARCHITECTURE.md)
- [Setup Guide](../../../../SETUP.md)
- [Russian Documentation](./README-RU.md)
- [Tasks List](../../../../.specify/specs/001-initial-setup/tasks.md)

## Contact

- VK: https://vk.com/vladimirlevadnij
- Telegram: https://t.me/Vladimir_Levadnij
- Email: universo.pro@yandex.com
- Website: https://universo.pro
