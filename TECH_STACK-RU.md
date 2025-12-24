# Определение технологического стека

**Версия документа**: 1.0  
**Последнее обновление**: 24 декабря 2025  
**Назначение**: Определить полный технологический стек для Universo Platformo C#

<details>
<summary>In English</summary>

# Technology Stack Definition

**Document Version**: 1.0  
**Last Updated**: December 24, 2025  
**Purpose**: Define the complete technology stack for Universo Platformo C#
</details>

---

## Краткое резюме / Executive Summary

Этот документ предоставляет исчерпывающее определение технологического стека для Universo Platformo C#, с акцентом на:

1. **Система сборки и управления пакетами** - Эквивалент C# для Vite + PNPM, используемых в версии React
2. **Система авторизации** - Эквивалент C# для Passport.js + Supabase, используемых в версии React

Этот стек оптимизирован для архитектуры монорепозитория с несколькими пакетами, обеспечивая эффективное время сборки, строгую типизацию и бесшовную интеграцию с Supabase для многопользовательской функциональности.

<details>
<summary>In English</summary>

This document provides a comprehensive definition of the technology stack for Universo Platformo C#, focusing on:

1. **Build System and Package Management** - The C# equivalent of Vite + PNPM used in the React version
2. **Authorization System** - The C# equivalent of Passport.js + Supabase used in the React version

This stack is optimized for a monorepo architecture with multiple packages, providing efficient build times, strong typing, and seamless integration with Supabase for multi-user functionality.
</details>

---

## Содержание / Table of Contents

1. [Система сборки и управления пакетами](#1-система-сборки-и-управления-пакетами--build-system-and-package-management)
2. [Система авторизации](#2-система-авторизации--authorization-system)
3. [Полное соответствие технологий](#3-полное-соответствие-технологий--complete-technology-mapping)
4. [Процесс разработки](#4-процесс-разработки--development-workflow)
5. [Развертывание в продакшн](#5-развертывание-в-продакшн--production-deployment)

---

## 1. Система сборки и управления пакетами / Build System and Package Management

### Постановка задачи / Problem Statement

**Версия React использует**:
- **Vite** - Быстрый инструмент сборки с горячей заменой модулей
- **PNPM** - Эффективный менеджер пакетов с поддержкой рабочих пространств для монорепозиториев

**Задача**: Найти эквиваленты C#/.NET, которые обеспечивают:
- ✅ Быструю инкрементальную сборку
- ✅ Поддержку монорепозитория с несколькими пакетами
- ✅ Централизованное управление зависимостями
- ✅ Сервер разработки с горячей перезагрузкой
- ✅ Оптимизированные продакшн-сборки

<details>
<summary>In English</summary>

### Problem Statement

**React Version Uses**:
- **Vite** - Fast build tool with hot module replacement
- **PNPM** - Efficient package manager with workspace support for monorepos

**Challenge**: Find C#/.NET equivalents that provide:
- ✅ Fast, incremental builds
- ✅ Monorepo support with multiple packages
- ✅ Centralized dependency management
- ✅ Development server with hot reload
- ✅ Production-optimized builds
</details>

---

### Решение: Нативная система сборки .NET / Solution: .NET Native Build System

C# реализация использует **нативную систему сборки .NET**, которая обеспечивает эквивалентную или превосходящую функциональность:

| Функция | React (Vite + PNPM) | C# (.NET Native) |
|---------|---------------------|------------------|
| **Инструмент сборки** | Vite | MSBuild |
| **Менеджер пакетов** | PNPM | NuGet |
| **Поддержка монорепозитория** | Рабочие пространства PNPM | Решение .NET (.sln) |
| **Управление зависимостями** | package.json | Directory.Packages.props |
| **Конфигурация сборки** | vite.config.ts | Directory.Build.props |
| **Горячая перезагрузка** | Vite HMR | dotnet watch |
| **Продакшн-сборка** | vite build | dotnet publish |
| **Кеш сборки** | Хранилище PNPM | Кеш NuGet |

<details>
<summary>In English</summary>

The C# implementation uses **.NET's native build system** which provides equivalent or superior functionality:

| Feature | React (Vite + PNPM) | C# (.NET Native) |
|---------|---------------------|------------------|
| **Build Tool** | Vite | MSBuild |
| **Package Manager** | PNPM | NuGet |
| **Monorepo Support** | PNPM Workspaces | .NET Solution (.sln) |
| **Dependency Management** | package.json | Directory.Packages.props |
| **Build Configuration** | vite.config.ts | Directory.Build.props |
| **Hot Reload** | Vite HMR | dotnet watch |
| **Production Build** | vite build | dotnet publish |
| **Build Cache** | PNPM store | NuGet cache |
</details>

---

### 1.1 MSBuild - Движок сборки / The Build Engine

**MSBuild** - это нативная платформа сборки .NET, эквивалент функциональности сборки Vite.

**Ключевые возможности**:
- ✅ Инкрементальная компиляция (пересобирает только измененные файлы)
- ✅ Параллельная сборка проектов
- ✅ Богатая экосистема плагинов через NuGet
- ✅ Кроссплатформенность (Windows, Linux, macOS)
- ✅ Интегрирован с .NET SDK

**Команды сборки**:

```bash
# Сборка для разработки (эквивалент: vite build --mode development)
dotnet build

# Продакшн-сборка с оптимизациями (эквивалент: vite build)
dotnet build -c Release

# Очистка артефактов сборки (эквивалент: rm -rf dist)
dotnet clean

# Восстановление зависимостей (эквивалент: pnpm install)
dotnet restore

# Режим наблюдения с горячей перезагрузкой (эквивалент: vite dev)
dotnet watch --project src/packages/api-host-srv/base

# Собрать конкретный проект
dotnet build src/packages/clusters-frt/base

# Собрать все решение
dotnet build src/Universo.sln
```

<details>
<summary>In English</summary>

**MSBuild** is .NET's native build platform, equivalent to Vite's build functionality.

**Key Features**:
- ✅ Incremental compilation (only rebuilds changed files)
- ✅ Parallel project builds
- ✅ Rich plugin ecosystem via NuGet
- ✅ Cross-platform (Windows, Linux, macOS)
- ✅ Integrated with .NET SDK

**Build Commands**:

```bash
# Development build (equivalent to: vite build --mode development)
dotnet build

# Production build with optimizations (equivalent to: vite build)
dotnet build -c Release

# Clean build artifacts (equivalent to: rm -rf dist)
dotnet clean

# Restore dependencies (equivalent to: pnpm install)
dotnet restore

# Watch mode with hot reload (equivalent to: vite dev)
dotnet watch --project src/packages/api-host-srv/base
```
</details>

---

### 1.2 NuGet - Управление пакетами / Package Management

**NuGet** - это менеджер пакетов .NET, эквивалент PNPM.

**Ключевые возможности**:
- ✅ Централизованный репозиторий пакетов (nuget.org)
- ✅ Кеширование пакетов для ускорения установки
- ✅ Управление версиями и разрешение конфликтов
- ✅ Поддержка приватных каналов пакетов
- ✅ Разрешение транзитивных зависимостей

**Команды управления пакетами**:

```bash
# Установить пакет (эквивалент: pnpm add <package>)
dotnet add package MudBlazor

# Установить конкретную версию (эквивалент: pnpm add <package>@<version>)
dotnet add package Supabase --version 0.15.0

# Удалить пакет (эквивалент: pnpm remove <package>)
dotnet remove package MudBlazor

# Список установленных пакетов
dotnet list package

# Обновить пакет до последней версии
dotnet add package MudBlazor --version "*-*"

# Восстановить все пакеты (эквивалент: pnpm install)
dotnet restore
```

<details>
<summary>In English</summary>

**NuGet** is .NET's package manager, equivalent to PNPM.

**Key Features**:
- ✅ Centralized package repository (nuget.org)
- ✅ Package caching for faster installs
- ✅ Version management and conflict resolution
- ✅ Support for private package feeds
- ✅ Transitive dependency resolution

**Package Management Commands**:

```bash
# Install package (equivalent to: pnpm add <package>)
dotnet add package MudBlazor

# Install specific version (equivalent to: pnpm add <package>@<version>)
dotnet add package Supabase --version 0.15.0

# Remove package (equivalent to: pnpm remove <package>)
dotnet remove package MudBlazor
```
</details>

---

### 1.3 Решение .NET - Структура монорепозитория / Monorepo Structure

**Решение .NET (.sln)** - это эквивалент рабочих пространств PNPM для управления несколькими проектами в монорепозитории.

**Структура**:

```
universo-platformo-csharp/
├── src/
│   ├── Universo.sln                     # Файл решения (корень рабочего пространства)
│   ├── Directory.Build.props            # Общие свойства сборки
│   ├── Directory.Packages.props         # Централизованные версии пакетов
│   ├── packages/                        # Функциональные пакеты
│   │   ├── clusters-frt/base/           # Пакет фронтенда
│   │   │   └── Universo.Clusters.Frontend.csproj
│   │   ├── clusters-srv/base/           # Пакет бэкенда
│   │   │   └── Universo.Clusters.Backend.csproj
│   │   ├── auth-frt/base/
│   │   │   └── Universo.Auth.Frontend.csproj
│   │   └── auth-srv/base/
│   │       └── Universo.Auth.Backend.csproj
│   └── shared/                          # Общие библиотеки
│       ├── Universo.Types/
│       │   └── Universo.Types.csproj
│       ├── Universo.Utils/
│       │   └── Universo.Utils.csproj
│       └── Universo.I18n/
│           └── Universo.I18n.csproj
└── tests/                               # Тестовые проекты
    └── Tests.sln
```

**Команды управления решением**:

```bash
# Создать новое решение (эквивалент: pnpm init)
dotnet new sln -n Universo -o src

# Добавить проект в решение (эквивалент: добавление в рабочее пространство pnpm)
dotnet sln src/Universo.sln add src/packages/clusters-frt/base/Universo.Clusters.Frontend.csproj

# Список проектов в решении
dotnet sln src/Universo.sln list

# Удалить проект из решения
dotnet sln src/Universo.sln remove src/packages/clusters-frt/base/Universo.Clusters.Frontend.csproj

# Собрать все решение
dotnet build src/Universo.sln

# Запустить все тесты в решении
dotnet test src/Universo.sln
```

<details>
<summary>In English</summary>

**.NET Solution (.sln)** is the equivalent of PNPM workspaces for managing multiple projects in a monorepo.

**Solution Management Commands**:

```bash
# Create new solution (equivalent to: pnpm init)
dotnet new sln -n Universo -o src

# Add project to solution (equivalent to: adding to pnpm workspace)
dotnet sln src/Universo.sln add src/packages/clusters-frt/base/Universo.Clusters.Frontend.csproj

# List projects in solution
dotnet sln src/Universo.sln list

# Build entire solution
dotnet build src/Universo.sln
```
</details>

---

### 1.4 Directory.Build.props - Общая конфигурация сборки / Shared Build Configuration

**Directory.Build.props** - это эквивалент общей конфигурации TypeScript (tsconfig.base.json) или общей конфигурации Vite.

**Назначение**:
- ✅ Определить общие свойства сборки для всех проектов
- ✅ Включить современные возможности C# (nullable типы, последняя версия языка)
- ✅ Настроить предупреждения и ошибки
- ✅ Настроить генерацию документации

**Пример конфигурации**:

```xml
<!-- src/Directory.Build.props -->
<Project>
  <PropertyGroup>
    <!-- Версия языка -->
    <LangVersion>latest</LangVersion>
    <TargetFramework>net9.0</TargetFramework>
    
    <!-- Nullable Reference Types -->
    <Nullable>enable</Nullable>
    
    <!-- Качество кода -->
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <WarningLevel>5</WarningLevel>
    
    <!-- Документация -->
    <GenerateDocumentationFile>true</GenerateDocumentationFile>
    <NoWarn>$(NoWarn);1591</NoWarn>
    
    <!-- Implicit Usings -->
    <ImplicitUsings>enable</ImplicitUsings>
    
    <!-- AOT компиляция для Blazor WASM (Продакшн) -->
    <RunAOTCompilation Condition="'$(Configuration)' == 'Release'">true</RunAOTCompilation>
    
    <!-- Информация о сборке -->
    <Company>Teknokomo</Company>
    <Product>Universo Platformo</Product>
    <Copyright>Copyright © 2025 Teknokomo</Copyright>
  </PropertyGroup>
</Project>
```

<details>
<summary>In English</summary>

**Directory.Build.props** is the equivalent of shared TypeScript configuration (tsconfig.base.json) or shared Vite config.

**Purpose**:
- ✅ Define common build properties for all projects
- ✅ Enable modern C# features (nullable types, latest language version)
- ✅ Configure warnings and errors
- ✅ Set up documentation generation
</details>

---

### 1.5 Directory.Packages.props - Централизованные версии пакетов / Centralized Package Versions

**Directory.Packages.props** - это эквивалент зависимостей рабочего пространства PNPM в package.json.

**Назначение**:
- ✅ Определить версии пакетов в одном месте
- ✅ Обеспечить согласованные версии во всех проектах
- ✅ Упростить обновление зависимостей
- ✅ Предотвратить конфликты версий

**Пример конфигурации**:

```xml
<!-- src/Directory.Packages.props -->
<Project>
  <PropertyGroup>
    <!-- Включить централизованное управление пакетами -->
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
  </PropertyGroup>
  
  <ItemGroup>
    <!-- Пакеты фронтенда (Blazor WebAssembly) -->
    <PackageVersion Include="Microsoft.AspNetCore.Components.WebAssembly" Version="9.0.0" />
    <PackageVersion Include="MudBlazor" Version="7.0.0" />
    <PackageVersion Include="Fluxor.Blazor.Web" Version="5.9.1" />
    
    <!-- Пакеты бэкенда (ASP.NET Core) -->
    <PackageVersion Include="Microsoft.AspNetCore.OpenApi" Version="9.0.0" />
    <PackageVersion Include="Microsoft.AspNetCore.Authentication.JwtBearer" Version="9.0.0" />
    
    <!-- База данных и ORM -->
    <PackageVersion Include="Supabase" Version="0.15.0" />
    <PackageVersion Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="9.0.0" />
    
    <!-- Аутентификация и безопасность -->
    <PackageVersion Include="System.IdentityModel.Tokens.Jwt" Version="7.0.3" />
    
    <!-- Валидация -->
    <PackageVersion Include="FluentValidation.AspNetCore" Version="11.3.0" />
    
    <!-- Тестирование -->
    <PackageVersion Include="xunit" Version="2.6.2" />
    <PackageVersion Include="Moq" Version="4.20.69" />
  </ItemGroup>
</Project>
```

**Использование в .csproj файлах**:

```xml
<!-- Версия не нужна - управляется централизованно -->
<ItemGroup>
  <PackageReference Include="MudBlazor" />
  <PackageReference Include="Supabase" />
</ItemGroup>
```

<details>
<summary>In English</summary>

**Directory.Packages.props** is the equivalent of PNPM workspace dependencies in package.json.

**Purpose**:
- ✅ Define package versions in one place
- ✅ Ensure consistent versions across all projects
- ✅ Simplify dependency updates
- ✅ Prevent version conflicts

**Usage in .csproj files**:

```xml
<!-- No version needed - managed centrally -->
<ItemGroup>
  <PackageReference Include="MudBlazor" />
  <PackageReference Include="Supabase" />
</ItemGroup>
```
</details>

---

### 1.6 Горячая перезагрузка - Опыт разработки / Hot Reload - Development Experience

**Горячая перезагрузка .NET** обеспечивает функциональность, эквивалентную HMR (горячей замене модулей) Vite.

**Возможности**:
- ✅ Автоматическая перезагрузка при изменении кода
- ✅ Сохраняет состояние приложения
- ✅ Работает с Blazor WebAssembly и ASP.NET Core
- ✅ Не требует ручного обновления браузера

**Использование**:

```bash
# Запустить с горячей перезагрузкой (эквивалент: pnpm dev или vite dev)
dotnet watch --project src/packages/api-host-srv/base

# Запустить с горячей перезагрузкой и конкретным окружением
dotnet watch --project src/packages/api-host-srv/base --environment Development

# Горячая перезагрузка для Blazor WASM (фронтенд)
dotnet watch --project src/packages/main-frt/base

# Принудительная пересборка при изменении файла
dotnet watch --project src/packages/api-host-srv/base --no-hot-reload
```

**Как это работает**:
1. Обнаружено изменение кода
2. Инкрементальная компиляция
3. Горячая замена сборки в запущенном процессе
4. UI обновляется автоматически (для Blazor)
5. API-эндпоинты обновляются автоматически (для ASP.NET)

<details>
<summary>In English</summary>

**.NET Hot Reload** provides functionality equivalent to Vite's HMR (Hot Module Replacement).

**Features**:
- ✅ Automatic reload on code changes
- ✅ Preserves application state
- ✅ Works with Blazor WebAssembly and ASP.NET Core
- ✅ No manual browser refresh needed

**Usage**:

```bash
# Start with hot reload (equivalent to: pnpm dev or vite dev)
dotnet watch --project src/packages/api-host-srv/base

# Hot reload for Blazor WASM (frontend)
dotnet watch --project src/packages/main-frt/base
```

**How It Works**:
1. Code change detected
2. Incremental compilation
3. Assembly hot-swapped in running process
4. UI updates automatically (for Blazor)
5. API endpoints updated automatically (for ASP.NET)
</details>

---

## 2. Система авторизации / Authorization System

### Постановка задачи / Problem Statement

**Версия React использует**:
- **Passport.js** - Middleware для аутентификации с паттерном стратегий
- **Supabase** - Backend-as-a-Service для управления пользователями и аутентификации
- **JWT** - Токенная аутентификация

**Задача**: Найти эквиваленты C#/.NET, которые обеспечивают:
- ✅ Аутентификацию на основе стратегий
- ✅ Обработку JWT токенов
- ✅ Интеграцию с Supabase
- ✅ Управление сеансами
- ✅ Управление доступом на основе ролей

<details>
<summary>In English</summary>

### Problem Statement

**React Version Uses**:
- **Passport.js** - Authentication middleware with strategy pattern
- **Supabase** - Backend-as-a-Service for user management and auth
- **JWT** - Token-based authentication

**Challenge**: Find C#/.NET equivalents that provide:
- ✅ Strategy-based authentication
- ✅ JWT token handling
- ✅ Integration with Supabase
- ✅ Session management
- ✅ Role-based access control
</details>

---

### Решение: ASP.NET Core Identity + Supabase / Solution: ASP.NET Core Identity + Supabase

C# реализация использует **ASP.NET Core Identity + JWT аутентификацию + Supabase** как эквивалент Passport.js.

| Функция | React (Passport.js) | C# (ASP.NET Core Identity) |
|---------|---------------------|----------------------------|
| **Фреймворк** | Passport.js | ASP.NET Core Identity |
| **Паттерн стратегий** | passport-local, passport-jwt | AuthenticationSchemes |
| **Тип токена** | JWT | JWT (то же самое) |
| **Хранение пользователей** | Supabase Auth | Supabase Auth |
| **Управление сеансами** | express-session | ASP.NET Core Session |
| **RBAC** | Ручная реализация | Встроенный Role Manager |
| **OAuth** | passport-google-oauth | Microsoft.AspNetCore.Authentication.Google |

<details>
<summary>In English</summary>

The C# implementation uses **ASP.NET Core Identity + JWT Authentication + Supabase** as the equivalent of Passport.js.

| Feature | React (Passport.js) | C# (ASP.NET Core Identity) |
|---------|---------------------|----------------------------|
| **Framework** | Passport.js | ASP.NET Core Identity |
| **Strategy Pattern** | passport-local, passport-jwt | AuthenticationSchemes |
| **Token Type** | JWT | JWT (same) |
| **User Storage** | Supabase Auth | Supabase Auth |
| **Session Management** | express-session | ASP.NET Core Session |
| **RBAC** | Manual implementation | Built-in Role Manager |
| **OAuth** | passport-google-oauth | Microsoft.AspNetCore.Authentication.Google |
</details>

---

### 2.1 ASP.NET Core Identity - Фреймворк аутентификации / Authentication Framework

**ASP.NET Core Identity** - это комплексная система членства, эквивалентная Passport.js.

**Ключевые возможности**:
- ✅ Управление пользователями (регистрация, вход, сброс пароля)
- ✅ Управление доступом на основе ролей (RBAC)
- ✅ Идентификация на основе claims
- ✅ Двухфакторная аутентификация (2FA)
- ✅ Внешние провайдеры аутентификации (Google, Facebook и др.)
- ✅ Хеширование паролей и безопасность
- ✅ Блокировка учетной записи при неудачных попытках

**Пакеты NuGet**:

```xml
<PackageReference Include="Microsoft.AspNetCore.Identity.EntityFrameworkCore" Version="9.0.0" />
<PackageReference Include="Microsoft.AspNetCore.Authentication.JwtBearer" Version="9.0.0" />
<PackageReference Include="System.IdentityModel.Tokens.Jwt" Version="7.0.3" />
```

<details>
<summary>In English</summary>

**ASP.NET Core Identity** is a comprehensive membership system equivalent to Passport.js.

**Key Features**:
- ✅ User management (registration, login, password reset)
- ✅ Role-based access control (RBAC)
- ✅ Claims-based identity
- ✅ Two-factor authentication (2FA)
- ✅ External authentication providers (Google, Facebook, etc.)
- ✅ Password hashing and security
- ✅ Account lockout on failed attempts
</details>

---

### 2.2 Конфигурация JWT Bearer аутентификации / JWT Bearer Authentication Configuration

**JWT (JSON Web Token)** аутентификация настраивается идентично версии React.

**Конфигурация в Program.cs**:

```csharp
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Добавить JWT аутентификацию
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    // Конфигурация JWT для Supabase
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        
        // Значения, специфичные для Supabase
        ValidIssuer = builder.Configuration["Supabase:JwtIssuer"],
        ValidAudience = builder.Configuration["Supabase:JwtAudience"],
        IssuerSigningKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(builder.Configuration["Supabase:JwtSecret"]!))
    };
});

// Добавить авторизацию
builder.Services.AddAuthorization(options =>
{
    // Определить политики (эквивалент стратегий Passport.js)
    options.AddPolicy("RequireAdminRole", policy =>
        policy.RequireRole("Admin"));
    
    options.AddPolicy("RequireAuthenticatedUser", policy =>
        policy.RequireAuthenticatedUser());
});

var app = builder.Build();

// Включить middleware для аутентификации и авторизации
app.UseAuthentication();
app.UseAuthorization();

app.Run();
```

**Конфигурация в appsettings.json**:

```json
{
  "Supabase": {
    "Url": "https://your-project.supabase.co",
    "AnonKey": "your-anon-key",
    "JwtSecret": "your-jwt-secret",
    "JwtIssuer": "https://your-project.supabase.co/auth/v1",
    "JwtAudience": "authenticated"
  }
}
```

<details>
<summary>In English</summary>

**JWT (JSON Web Token)** authentication is configured identically to the React version.

**Configuration in Program.cs**: Defines JWT Bearer authentication scheme with Supabase token validation parameters.

**Configuration in appsettings.json**: Contains Supabase connection parameters and JWT secrets.
</details>

---

### 2.3 Интеграция с Supabase / Supabase Integration

**Supabase C# SDK** предоставляет ту же функциональность, что и JavaScript SDK, используемый в версии React.

**Пакеты NuGet**:

```xml
<PackageReference Include="Supabase" Version="0.15.0" />
<PackageReference Include="supabase-csharp" Version="0.15.0" />
```

**Реализация сервиса аутентификации**:

```csharp
using Supabase;
using Supabase.Gotrue;

public interface IAuthService
{
    Task<Session?> SignInAsync(string email, string password);
    Task<Session?> SignUpAsync(string email, string password);
    Task SignOutAsync();
    Task<User?> GetCurrentUserAsync();
    Task<Session?> RefreshTokenAsync();
}

public class SupabaseAuthService : IAuthService
{
    private readonly Supabase.Client _client;
    private readonly ILogger<SupabaseAuthService> _logger;

    public SupabaseAuthService(
        Supabase.Client client,
        ILogger<SupabaseAuthService> logger)
    {
        _client = client;
        _logger = logger;
    }

    public async Task<Session?> SignInAsync(string email, string password)
    {
        try
        {
            var session = await _client.Auth.SignIn(email, password);
            
            if (session?.AccessToken != null)
            {
                _logger.LogInformation("Пользователь {Email} вошел успешно", email);
                return session;
            }
            
            _logger.LogWarning("Вход не удался для {Email}", email);
            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ошибка при входе для {Email}", email);
            throw;
        }
    }

    public async Task<Session?> SignUpAsync(string email, string password)
    {
        try
        {
            var session = await _client.Auth.SignUp(email, password);
            _logger.LogInformation("Пользователь {Email} зарегистрирован успешно", email);
            return session;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ошибка при регистрации для {Email}", email);
            throw;
        }
    }

    public async Task SignOutAsync()
    {
        try
        {
            await _client.Auth.SignOut();
            _logger.LogInformation("Пользователь вышел успешно");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ошибка при выходе");
            throw;
        }
    }

    public async Task<User?> GetCurrentUserAsync()
    {
        try
        {
            var user = _client.Auth.CurrentUser;
            return user;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ошибка при получении текущего пользователя");
            throw;
        }
    }

    public async Task<Session?> RefreshTokenAsync()
    {
        try
        {
            var session = await _client.Auth.RefreshSession();
            _logger.LogInformation("Токен обновлен успешно");
            return session;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ошибка при обновлении токена");
            throw;
        }
    }
}
```

**Регистрация через внедрение зависимостей**:

```csharp
// Program.cs
builder.Services.AddScoped<Supabase.Client>(sp =>
{
    var url = builder.Configuration["Supabase:Url"]!;
    var key = builder.Configuration["Supabase:AnonKey"]!;
    
    var options = new SupabaseOptions
    {
        AutoConnectRealtime = true,
        AutoRefreshToken = true
    };
    
    return new Supabase.Client(url, key, options);
});

builder.Services.AddScoped<IAuthService, SupabaseAuthService>();
```

<details>
<summary>In English</summary>

**Supabase C# SDK** provides the same functionality as the JavaScript SDK used in the React version.

**Authentication Service Implementation**: Encapsulates all Supabase authentication operations in a typed C# service.

**Dependency Injection Registration**: Configures the Supabase client and authentication service for use in the application.
</details>

---

### 2.4 Авторизация контроллеров / Controller Authorization

**Защита API-эндпоинтов** - Эквивалент middleware Passport.js в маршрутах Express.

**Пример контроллера**:

```csharp
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class ClustersController : ControllerBase
{
    private readonly IClusterService _clusterService;

    public ClustersController(IClusterService clusterService)
    {
        _clusterService = clusterService;
    }

    // Публичный эндпоинт - аутентификация не требуется
    [HttpGet("public")]
    [AllowAnonymous]
    public async Task<ActionResult<List<ClusterDto>>> GetPublicClusters()
    {
        var clusters = await _clusterService.GetPublicClustersAsync();
        return Ok(clusters);
    }

    // Требуется аутентификация (эквивалент: passport.authenticate('jwt'))
    [HttpGet]
    [Authorize]
    public async Task<ActionResult<List<ClusterDto>>> GetClusters()
    {
        var userId = User.FindFirst("sub")?.Value;
        var clusters = await _clusterService.GetUserClustersAsync(userId);
        return Ok(clusters);
    }

    // Требуется конкретная роль
    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<ClusterDto>> CreateCluster(CreateClusterRequest request)
    {
        var cluster = await _clusterService.CreateClusterAsync(request);
        return CreatedAtAction(nameof(GetCluster), new { id = cluster.Id }, cluster);
    }

    // Требуется конкретная политика
    [HttpDelete("{id}")]
    [Authorize(Policy = "RequireAdminRole")]
    public async Task<ActionResult> DeleteCluster(Guid id)
    {
        await _clusterService.DeleteClusterAsync(id);
        return NoContent();
    }

    // Получить информацию о текущем пользователе из JWT claims
    [HttpGet("me")]
    [Authorize]
    public ActionResult<UserInfo> GetCurrentUser()
    {
        var userId = User.FindFirst("sub")?.Value;
        var email = User.FindFirst("email")?.Value;
        var roles = User.FindAll("role").Select(c => c.Value).ToList();
        
        return Ok(new UserInfo
        {
            Id = userId,
            Email = email,
            Roles = roles
        });
    }
}
```

**Сравнение с Passport.js**:

| Express + Passport.js | ASP.NET Core |
|-----------------------|--------------|
| `passport.authenticate('jwt')` | `[Authorize]` |
| `ensureAuthenticated` middleware | Атрибут `[Authorize]` |
| `ensureRole('admin')` middleware | `[Authorize(Roles = "Admin")]` |
| `req.user` | `User` (ClaimsPrincipal) |
| `req.user.id` | `User.FindFirst("sub")?.Value` |
| Ручная защита маршрутов | Декларативно с атрибутами |

<details>
<summary>In English</summary>

**Securing API Endpoints** - Equivalent to Passport.js middleware in Express routes.

**Comparison with Passport.js**:

| Express + Passport.js | ASP.NET Core |
|-----------------------|--------------|
| `passport.authenticate('jwt')` | `[Authorize]` |
| `ensureAuthenticated` middleware | `[Authorize]` attribute |
| `ensureRole('admin')` middleware | `[Authorize(Roles = "Admin")]` |
| `req.user` | `User` (ClaimsPrincipal) |
| `req.user.id` | `User.FindFirst("sub")?.Value` |
| Manual route protection | Declarative with attributes |
</details>

---

## 3. Полное соответствие технологий / Complete Technology Mapping

### Комплексная таблица сравнения / Comprehensive Comparison Table

| Категория | Версия React | Версия C# | Примечания |
|-----------|--------------|-----------|------------|
| **Инструмент сборки** | Vite | MSBuild | Нативный движок сборки .NET |
| **Менеджер пакетов** | PNPM | NuGet | Нативный менеджер пакетов .NET |
| **Монорепозиторий** | Рабочие пространства PNPM | Решение .NET | Файл .sln координирует проекты |
| **Конфигурация** | package.json | Directory.Packages.props | Централизованные версии |
| **Общая конфигурация** | tsconfig.base.json | Directory.Build.props | Общие свойства сборки |
| **Горячая перезагрузка** | Vite HMR | dotnet watch | Встроенная возможность .NET |
| **Фронтенд** | React | Blazor WebAssembly | Компонентный UI |
| **Бэкенд** | Express.js | ASP.NET Core | Фреймворк Web API |
| **Язык** | TypeScript | C# | Строгая типизация |
| **Фреймворк аутентификации** | Passport.js | ASP.NET Core Identity | Аутентификация на основе стратегий |
| **Стратегия аутентификации** | passport-jwt | JWT Bearer | Валидация JWT токенов |
| **Хранение пользователей** | Supabase Auth | Supabase Auth | Тот же бэкенд |
| **Сеанс** | express-session | ASP.NET Session | Серверные сеансы |
| **RBAC** | Пользовательское | Встроенное | Доступ на основе ролей |
| **UI библиотека** | Material-UI | MudBlazor | Material Design |
| **Состояние** | Redux/Zustand | Fluxor | Паттерн Flux |
| **Маршрутизация** | React Router | Blazor Router | Маршрутизация компонентов |
| **HTTP клиент** | Axios | HttpClient | HTTP запросы |
| **ORM** | Prisma/TypeORM | Entity Framework Core | ORM для базы данных |
| **Тестирование** | Jest/Vitest | xUnit | Модульное тестирование |

<details>
<summary>In English</summary>

### Comprehensive Comparison Table

| Category | React Version | C# Version | Notes |
|----------|---------------|------------|-------|
| **Build Tool** | Vite | MSBuild | Native .NET build engine |
| **Package Manager** | PNPM | NuGet | Native .NET package manager |
| **Monorepo** | PNPM Workspaces | .NET Solution | .sln file coordinates projects |
| **Config** | package.json | Directory.Packages.props | Centralized versions |
| **Shared Config** | tsconfig.base.json | Directory.Build.props | Shared build properties |
| **Hot Reload** | Vite HMR | dotnet watch | Built-in .NET feature |
| **Frontend** | React | Blazor WebAssembly | Component-based UI |
| **Backend** | Express.js | ASP.NET Core | Web API framework |
| **Language** | TypeScript | C# | Strongly typed |
| **Auth Framework** | Passport.js | ASP.NET Core Identity | Strategy-based auth |
</details>

---

## 4. Процесс разработки / Development Workflow

### Команды быстрого старта / Quick Start Commands

**Рабочий процесс версии React** → **Эквивалент версии C#**:

```bash
# Установить зависимости
pnpm install                    →  dotnet restore

# Запустить сервер разработки
pnpm dev                        →  dotnet watch --project src/packages/api-host-srv/base

# Собрать для продакшн
pnpm build                      →  dotnet build -c Release

# Запустить тесты
pnpm test                       →  dotnet test

# Проверить код линтером
pnpm lint                       →  dotnet format --verify-no-changes

# Форматировать код
pnpm format                     →  dotnet format

# Добавить зависимость
pnpm add <package>              →  dotnet add package <PackageName>

# Удалить зависимость
pnpm remove <package>           →  dotnet remove package <PackageName>

# Очистить артефакты сборки
pnpm clean                      →  dotnet clean

# Создать новый пакет
pnpm create-package             →  dotnet new classlib -n <PackageName>
```

<details>
<summary>In English</summary>

### Quick Start Commands

**React Version Workflow** → **C# Version Equivalent**:

```bash
# Install dependencies
pnpm install                    →  dotnet restore

# Run development server
pnpm dev                        →  dotnet watch --project src/packages/api-host-srv/base

# Build for production
pnpm build                      →  dotnet build -c Release

# Run tests
pnpm test                       →  dotnet test

# Add dependency
pnpm add <package>              →  dotnet add package <PackageName>
```
</details>

---

## 5. Развертывание в продакшн / Production Deployment

### Оптимизация сборки / Build Optimization

**Конфигурация продакшн-сборки**:

```bash
# Сборка с конфигурацией Release (оптимизации включены)
dotnet publish -c Release -o ./publish

# Сборка с AOT (Ahead-of-Time) компиляцией для Blazor WASM
dotnet publish -c Release -p:RunAOTCompilation=true

# Сборка с обрезкой (уменьшает размер сборок)
dotnet publish -c Release -p:PublishTrimmed=true

# Сборка для конкретной среды выполнения (автономная)
dotnet publish -c Release -r linux-x64 --self-contained true
```

**Преимущества продакшн**:
- ✅ AOT компиляция для Blazor WASM (на 30-50% быстрее запуск)
- ✅ Обрезка сборок (меньший размер пакета)
- ✅ Генерация нативного кода
- ✅ Опция развертывания в одном файле
- ✅ Автономное развертывание (среда выполнения .NET не требуется на сервере)

<details>
<summary>In English</summary>

### Build Optimization

**Production Build Configuration**:

```bash
# Build with Release configuration (optimizations enabled)
dotnet publish -c Release -o ./publish

# Build with AOT (Ahead-of-Time) compilation for Blazor WASM
dotnet publish -c Release -p:RunAOTCompilation=true

# Build with trimming (reduces assembly size)
dotnet publish -c Release -p:PublishTrimmed=true
```

**Production Advantages**:
- ✅ AOT compilation for Blazor WASM (30-50% faster startup)
- ✅ Assembly trimming (smaller bundle size)
- ✅ Native code generation
- ✅ Single-file deployment option
- ✅ Self-contained deployment (no .NET runtime required on server)
</details>

---

## Резюме / Summary

### Ключевые выводы / Key Takeaways

1. **Система сборки**: Нативные инструменты .NET (MSBuild + NuGet + Решение .NET) обеспечивают эквивалентную или превосходящую функциональность по сравнению с Vite + PNPM
2. **Авторизация**: ASP.NET Core Identity + JWT + Supabase является прямым эквивалентом Passport.js + Supabase
3. **Монорепозиторий**: Файлы решения .NET и Directory.*.props обеспечивают управление монорепозиторием, эквивалентное рабочим пространствам PNPM
4. **Горячая перезагрузка**: `dotnet watch` обеспечивает тот же опыт разработки, что и Vite HMR
5. **Типобезопасность**: C# обеспечивает типобезопасность во время компиляции, сравнимую с TypeScript

### Преимущества стека C# / Benefits of C# Stack

✅ **Более строгая типобезопасность**: Проверки во время компиляции, никаких ошибок типов во время выполнения  
✅ **Лучшая производительность**: AOT компиляция, генерация нативного кода  
✅ **Единый язык**: Один язык для фронтенда и бэкенда (C#)  
✅ **Богатая экосистема**: Зрелые библиотеки, отличный инструментарий  
✅ **Готовность к энтерпрайзу**: Проверено в боевых продакшн-средах  
✅ **Нативная интеграция**: SDK Supabase работает бесшовно

<details>
<summary>In English</summary>

### Key Takeaways

1. **Build System**: .NET's native tools (MSBuild + NuGet + .NET Solution) provide equivalent or superior functionality to Vite + PNPM
2. **Authorization**: ASP.NET Core Identity + JWT + Supabase is the direct equivalent of Passport.js + Supabase
3. **Monorepo**: .NET Solution files and Directory.*.props provide monorepo management equivalent to PNPM workspaces
4. **Hot Reload**: `dotnet watch` provides the same developer experience as Vite HMR
5. **Type Safety**: C# provides compile-time type safety comparable to TypeScript

### Benefits of C# Stack

✅ **Stronger Type Safety**: Compile-time checks, no runtime type errors  
✅ **Better Performance**: AOT compilation, native code generation  
✅ **Unified Language**: Same language for frontend and backend (C#)  
✅ **Rich Ecosystem**: Mature libraries, excellent tooling  
✅ **Enterprise Ready**: Battle-tested in production environments  
✅ **Native Integration**: Supabase SDK works seamlessly
</details>

---

## Следующие шаги / Next Steps

1. ✅ **Технологический стек определен** - Этот документ
2. ⏭️ **Реализовать пакеты аутентификации** - `auth-frt` и `auth-srv`
3. ⏭️ **Настроить подключение к Supabase** - Настроить клиент и протестировать аутентификацию
4. ⏭️ **Создать примерное приложение** - Продемонстрировать поток аутентификации
5. ⏭️ **Документировать лучшие практики** - Паттерны аутентификации и безопасность

<details>
<summary>In English</summary>

## Next Steps

1. ✅ **Technology stack defined** - This document
2. ⏭️ **Implement authentication packages** - `auth-frt` and `auth-srv`
3. ⏭️ **Set up Supabase connection** - Configure client and test authentication
4. ⏭️ **Create sample application** - Demonstrate authentication flow
5. ⏭️ **Document best practices** - Authentication patterns and security
</details>

---

## Ссылки / References

- [Документация .NET](https://docs.microsoft.com/ru-ru/dotnet/)
- [Документация MSBuild](https://docs.microsoft.com/ru-ru/visualstudio/msbuild/)
- [Документация NuGet](https://docs.microsoft.com/ru-ru/nuget/)
- [ASP.NET Core Identity](https://docs.microsoft.com/ru-ru/aspnet/core/security/authentication/identity)
- [JWT Bearer аутентификация](https://docs.microsoft.com/ru-ru/aspnet/core/security/authentication/jwt-authn)
- [Документация Supabase C#](https://supabase.com/docs/reference/csharp/introduction)
- [Аутентификация Blazor](https://docs.microsoft.com/ru-ru/aspnet/core/blazor/security/)
- [Документация Hot Reload](https://docs.microsoft.com/ru-ru/dotnet/core/tools/dotnet-watch)

---

**Статус документа**: ✅ Завершен  
**Утверждение**: Готов к реализации  
**Версия**: 1.0  
**Последнее обновление**: 24 декабря 2025
