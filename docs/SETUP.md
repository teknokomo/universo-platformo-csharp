# Project Setup Guide / Руководство по настройке проекта

This guide provides step-by-step instructions for setting up the Universo Platformo C# development environment and understanding the project structure.

<details>
<summary>In Russian</summary>

Это руководство предоставляет пошаговые инструкции по настройке среды разработки Universo Platformo C# и пониманию структуры проекта.
</details>

## Prerequisites / Требования

### Required Software / Необходимое ПО

1. **.NET 9.0 SDK or later / .NET 9.0 SDK или новее**
   - Download: https://dotnet.microsoft.com/download
   - Verify installation: `dotnet --version`

2. **IDE (choose one) / IDE (выберите один)**
   - **Visual Studio 2022** (Community, Professional, or Enterprise)
     - Download: https://visualstudio.microsoft.com/
     - Required workloads: ASP.NET and web development, .NET desktop development
   - **Visual Studio Code** with C# extension
     - Download: https://code.visualstudio.com/
     - Extensions: C# Dev Kit, C#, Blazor WASM Debugging
   - **JetBrains Rider**
     - Download: https://www.jetbrains.com/rider/

3. **Git**
   - Download: https://git-scm.com/
   - Verify installation: `git --version`

4. **Node.js (optional, for tooling) / Node.js (опционально, для инструментария)**
   - Download: https://nodejs.org/
   - Required for some build tools and documentation generators

### Optional Software / Опциональное ПО

- **Docker** (for containerized development / для контейнеризованной разработки)
- **PostgreSQL** (if not using Supabase / если не используете Supabase)
- **Postman** or **Insomnia** (for API testing / для тестирования API)

<details>
<summary>In Russian</summary>

### Необходимое ПО

1. .NET 9.0 SDK или новее
2. IDE (Visual Studio 2022, VS Code или Rider)
3. Git
4. Node.js (опционально)
</details>

## Initial Setup / Первоначальная настройка

### 1. Clone the Repository / Клонируйте репозиторий

```bash
git clone https://github.com/teknokomo/universo-platformo-csharp.git
cd universo-platformo-csharp
```

### 2. Verify .NET Installation / Проверьте установку .NET

```bash
dotnet --version
# Should output 9.0.0 or higher / Должно вывести 9.0.0 или выше
```

### 3. Restore NuGet Packages / Восстановите пакеты NuGet

```bash
dotnet restore
```

This command:
- Downloads all required NuGet packages
- Validates package versions
- Prepares the project for building

<details>
<summary>In Russian</summary>

Эта команда:
- Загружает все необходимые пакеты NuGet
- Проверяет версии пакетов
- Подготавливает проект к сборке
</details>

### 4. Configure Supabase / Настройте Supabase

**Note**: Currently, the project structure is being set up. Supabase configuration will be needed once the initial implementation is complete.

Create `appsettings.Development.json` in backend projects:

```json
{
  "Supabase": {
    "Url": "https://your-project.supabase.co",
    "AnonKey": "your-anon-key",
    "JwtSecret": "your-jwt-secret"
  },
  "ConnectionStrings": {
    "Supabase": "Host=db.your-project.supabase.co;Database=postgres;Username=postgres;Password=your-password"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  }
}
```

**Security Note**: Never commit `appsettings.Development.json` to Git. It's already in `.gitignore`.

<details>
<summary>In Russian</summary>

Создайте `appsettings.Development.json` в проектах бэкенда с конфигурацией Supabase. Никогда не коммитьте этот файл в Git.
</details>

## Building the Project / Сборка проекта

### Build All Projects / Собрать все проекты

```bash
# Build entire solution / Собрать всё решение
dotnet build

# Build in Release mode / Собрать в режиме Release
dotnet build -c Release

# Clean and rebuild / Очистить и пересобрать
dotnet clean && dotnet build
```

### Build Specific Package / Собрать конкретный пакет

```bash
# Build clusters frontend / Собрать фронтенд кластеров
dotnet build src/packages/clusters-frt/base

# Build clusters backend / Собрать бэкенд кластеров
dotnet build src/packages/clusters-srv/base
```

## Running the Application / Запуск приложения

**Note**: Currently in early development. The following commands will work once the initial implementation is complete.

### Development Mode / Режим разработки

#### Backend / Бэкенд

```bash
cd src/packages/main-srv/base
dotnet watch run
```

This starts the backend with hot reload enabled.
The API will be available at: `https://localhost:5001`

#### Frontend / Фронтенд

```bash
cd src/packages/main-frt/base
dotnet watch run
```

This starts the Blazor WebAssembly app with hot reload.
The app will be available at: `https://localhost:5002`

<details>
<summary>In Russian</summary>

Режим разработки с горячей перезагрузкой. Бэкенд будет доступен на `https://localhost:5001`, фронтенд на `https://localhost:5002`.
</details>

### Production Build / Production сборка

```bash
# Publish backend / Опубликовать бэкенд
dotnet publish src/packages/main-srv/base -c Release -o publish/backend

# Publish frontend / Опубликовать фронтенд
dotnet publish src/packages/main-frt/base -c Release -o publish/frontend
```

## Testing / Тестирование

### Run All Tests / Запустить все тесты

```bash
# Run all tests / Запустить все тесты
dotnet test

# Run with coverage / Запустить с покрытием
dotnet test --collect:"XPlat Code Coverage"

# Run specific test project / Запустить конкретный тестовый проект
dotnet test tests/unit/Universo.Clusters.Tests
```

### Test Organization / Организация тестов

```
tests/
├── unit/
│   ├── Universo.Clusters.Tests/
│   ├── Universo.Auth.Tests/
│   └── Universo.Shared.Tests/
└── integration/
    ├── Universo.Api.Integration.Tests/
    └── Universo.Database.Integration.Tests/
```

<details>
<summary>In Russian</summary>

Тесты организованы в папки `unit/` для юнит-тестов и `integration/` для интеграционных тестов.
</details>

## Project Structure / Структура проекта

### Current Structure / Текущая структура

```
universo-platformo-csharp/
├── src/                           # Source code / Исходный код
│   ├── packages/                  # Feature packages / Пакеты функций
│   │   ├── auth-frt/              # Authentication frontend
│   │   ├── auth-srv/              # Authentication backend
│   │   ├── clusters-frt/          # Clusters frontend
│   │   ├── clusters-srv/          # Clusters backend
│   │   ├── metaverses-frt/        # Metaverses frontend
│   │   ├── metaverses-srv/        # Metaverses backend
│   │   ├── spaces-frt/            # Spaces frontend
│   │   ├── spaces-srv/            # Spaces backend
│   │   ├── uniks-frt/             # Uniks frontend
│   │   ├── uniks-srv/             # Uniks backend
│   │   ├── updl/                  # UPDL system
│   │   └── publish/               # Publication system
│   ├── shared/                    # Shared libraries / Общие библиотеки
│   │   ├── Universo.Types/        # Common types
│   │   ├── Universo.Utils/        # Utilities
│   │   └── Universo.I18n/         # Internationalization
│   └── Universo.sln               # Main solution / Главное решение
├── tests/                         # Test projects / Тестовые проекты
├── tools/                         # Build tools / Инструменты сборки
├── docs/                          # Documentation / Документация
├── .github/                       # GitHub configuration / Конфигурация GitHub
├── README.md                      # Project readme (English)
├── README-RU.md                   # Project readme (Russian)
├── ARCHITECTURE.md                # Architecture docs
├── CONTRIBUTING.md                # Contribution guide
└── LICENSE.md                     # License
```

### Package Structure / Структура пакета

Each package follows this structure:

```
packages/feature-name-frt/
└── base/
    ├── Universo.Feature.Frontend.csproj
    ├── Pages/                      # Razor pages
    │   ├── Index.razor
    │   └── Details.razor
    ├── Components/                 # Reusable components
    │   ├── FeatureList.razor
    │   └── FeatureForm.razor
    ├── Services/                   # Frontend services
    │   └── FeatureService.cs
    ├── Models/                     # View models
    │   └── FeatureViewModel.cs
    ├── wwwroot/                    # Static files
    │   ├── css/
    │   └── js/
    ├── _Imports.razor              # Global using directives
    ├── App.razor                   # App component
    ├── Program.cs                  # Entry point
    ├── README.md                   # Package readme (English)
    └── README-RU.md                # Package readme (Russian)
```

<details>
<summary>In Russian</summary>

Каждый пакет следует этой структуре с папками Pages, Components, Services и Models.
</details>

## Development Workflow / Рабочий процесс разработки

### 1. Create a Feature Branch / Создайте ветку функционала

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Changes / Внесите изменения

- Write code following C# conventions
- Add XML documentation comments
- Create unit tests
- Update documentation

### 3. Build and Test / Соберите и протестируйте

```bash
dotnet build
dotnet test
```

### 4. Commit Changes / Закоммитьте изменения

```bash
git add .
git commit -m "Add your feature description"
```

### 5. Push and Create PR / Запушьте и создайте PR

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub following the PR template.

<details>
<summary>In Russian</summary>

Рабочий процесс: создайте ветку, внесите изменения, соберите и протестируйте, закоммитьте, запушьте и создайте PR.
</details>

## IDE-Specific Setup / Настройка для конкретной IDE

### Visual Studio 2022

1. **Open solution**: Double-click `Universo.sln` or open via File → Open → Project/Solution
2. **Set startup projects**: Right-click solution → Properties → Multiple startup projects
3. **Configure debugging**: Set breakpoints and use F5 to start debugging
4. **NuGet Package Manager**: Tools → NuGet Package Manager → Manage NuGet Packages for Solution

### Visual Studio Code

1. **Open folder**: File → Open Folder → Select `universo-platformo-csharp`
2. **Install extensions**:
   - C# Dev Kit
   - C#
   - Blazor WASM Debugging
3. **Build**: Terminal → Run Build Task (Ctrl+Shift+B)
4. **Debug**: Run → Start Debugging (F5)

### JetBrains Rider

1. **Open solution**: File → Open → Select `Universo.sln`
2. **Configure run configurations**: Run → Edit Configurations
3. **NuGet**: Tools → NuGet → Manage NuGet Packages
4. **Debug**: Run → Debug (Shift+F9)

<details>
<summary>In Russian</summary>

Инструкции по настройке для Visual Studio 2022, VS Code и JetBrains Rider.
</details>

## Common Issues / Частые проблемы

### Issue: "The SDK 'Microsoft.NET.Sdk.Web' specified could not be found"

**Solution**: Ensure you have .NET 9.0 SDK installed:
```bash
dotnet --list-sdks
```

If not listed, download and install from https://dotnet.microsoft.com/download

### Issue: "Cannot connect to Supabase"

**Solution**: 
1. Check your `appsettings.Development.json` configuration
2. Verify Supabase credentials
3. Ensure your Supabase project is active

### Issue: "Port already in use"

**Solution**: 
```bash
# Find process using port 5001
lsof -i :5001  # Linux/Mac
netstat -ano | findstr :5001  # Windows

# Kill the process or change the port in launchSettings.json
```

### Issue: "Package restore failed"

**Solution**:
```bash
# Clear NuGet cache
dotnet nuget locals all --clear

# Restore packages again
dotnet restore
```

<details>
<summary>In Russian</summary>

Решения частых проблем: отсутствие SDK, проблемы с Supabase, занятый порт, ошибки восстановления пакетов.
</details>

## Environment Variables / Переменные окружения

### Development / Разработка

Create `.env` file in project root (already in `.gitignore`):

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_JWT_SECRET=your-jwt-secret
ASPNETCORE_ENVIRONMENT=Development
```

### Production / Production

Configure environment variables in your hosting platform:
- Azure App Service: Application Settings
- AWS: Environment Variables in Elastic Beanstalk
- Docker: Use `.env` file with docker-compose

<details>
<summary>In Russian</summary>

Настройте переменные окружения для разработки в файле `.env` и для продакшена в настройках хостинга.
</details>

## Database Setup / Настройка базы данных

### Supabase (Recommended / Рекомендуется)

1. Create account at https://supabase.com
2. Create new project
3. Copy connection string and API keys
4. Configure in `appsettings.Development.json`

### Local PostgreSQL (Alternative / Альтернатива)

```bash
# Install PostgreSQL
# Create database
createdb universo_platformo

# Update connection string in appsettings
```

### Entity Framework Migrations / Миграции Entity Framework

```bash
# Create migration / Создать миграцию
dotnet ef migrations add InitialCreate -p src/packages/clusters-srv/base

# Update database / Обновить базу данных
dotnet ef database update -p src/packages/clusters-srv/base

# Remove last migration / Удалить последнюю миграцию
dotnet ef migrations remove -p src/packages/clusters-srv/base
```

<details>
<summary>In Russian</summary>

Используйте Supabase (рекомендуется) или локальный PostgreSQL. Entity Framework Migrations для управления схемой базы данных.
</details>

## Next Steps / Следующие шаги

After setup is complete:

1. **Read documentation**:
   - [ARCHITECTURE.md](ARCHITECTURE.md) - Understand the architecture
   - [CONTRIBUTING.md](CONTRIBUTING.md) - Learn how to contribute
   - [README.md](README.md) - Project overview

2. **Explore the code**:
   - Start with `src/packages/clusters-frt` and `clusters-srv`
   - Review shared libraries in `src/shared`

3. **Run tests**:
   - `dotnet test` to ensure everything works

4. **Start developing**:
   - Pick an issue from GitHub
   - Follow the contribution guidelines
   - Submit a pull request

<details>
<summary>In Russian</summary>

После настройки: прочитайте документацию, изучите код, запустите тесты, начните разработку.
</details>

## Getting Help / Получение помощи

- **GitHub Issues**: Report bugs or request features
- **GitHub Discussions**: Ask questions and discuss ideas
- **Contact**: See README.md for contact information

<details>
<summary>In Russian</summary>

Для получения помощи: GitHub Issues для багов, GitHub Discussions для вопросов, контактная информация в README.md.
</details>

## Additional Resources / Дополнительные ресурсы

- [.NET Documentation](https://docs.microsoft.com/dotnet/)
- [Blazor Documentation](https://docs.microsoft.com/aspnet/core/blazor/)
- [ASP.NET Core Documentation](https://docs.microsoft.com/aspnet/core/)
- [MudBlazor Documentation](https://mudblazor.com/)
- [Entity Framework Core Documentation](https://docs.microsoft.com/ef/core/)
- [Supabase Documentation](https://supabase.com/docs)
- [C# Coding Conventions](https://docs.microsoft.com/dotnet/csharp/fundamentals/coding-style/coding-conventions)
