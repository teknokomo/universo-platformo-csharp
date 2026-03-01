# Universo Platformo C# - Feature Roadmap

This document outlines the planned features and implementation phases for Universo Platformo C#, based on the React implementation and adapted for C#/.NET.

<details>
<summary>In Russian</summary>

# Universo Platformo C# - Дорожная карта функций

Этот документ описывает планируемые функции и фазы реализации для Universo Platformo C#, основанные на реализации на React и адаптированные для C#/.NET.
</details>

## Implementation Phases / Фазы реализации

### Phase 0: Repository Setup (Current / Текущая)

**Status**: In Progress / В процессе

**Objectives / Цели:**
- ✅ Create comprehensive README files (English + Russian)
- ✅ Set up .gitignore for C#/.NET projects
- ✅ Create CONTRIBUTING.md with guidelines
- ✅ Create LICENSE.md (Omsk Open License)
- ✅ Create ARCHITECTURE.md documentation
- ✅ Create SETUP.md guide
- ⏳ Set up GitHub labels
- ⏳ Create initial project structure with .NET solution files
- ⏳ Set up CI/CD pipeline
- ⏳ Create issue templates

<details>
<summary>In Russian</summary>

**Статус**: В процессе

**Цели:**
- ✅ Создать подробные README файлы
- ✅ Настроить .gitignore
- ✅ Создать руководства и документацию
- ⏳ Настроить метки GitHub
- ⏳ Создать начальную структуру проекта
- ⏳ Настроить CI/CD
</details>

### Phase 1: Foundation (Planned / Запланирована)

**Estimated Duration**: 2-3 weeks / Примерная длительность: 2-3 недели

**Objectives / Цели:**

1. **Project Structure / Структура проекта**
   - Create .NET solution file (Universo.sln)
   - Set up Directory.Build.props
   - Set up Directory.Packages.props
   - Create shared libraries structure

2. **Authentication & Authorization / Аутентификация и авторизация**
   - Supabase integration
   - ASP.NET Core Identity setup
   - JWT token handling
   - User session management
   - Login/logout functionality

3. **UI Framework / UI фреймворк**
   - MudBlazor integration
   - Theme configuration
   - Layout components
   - Navigation menu
   - Internationalization (i18n) support

4. **Database Layer / Слой базы данных**
   - Entity Framework Core setup
   - DbContext configuration
   - Base repository pattern
   - Migration infrastructure

5. **Base Packages / Базовые пакеты**
   - `Universo.Types` - Shared types
   - `Universo.Utils` - Utility functions
   - `Universo.I18n` - Internationalization
   - `Universo.Api.Client` - API client library

<details>
<summary>In Russian</summary>

**Примерная длительность**: 2-3 недели

**Цели:**
1. Структура проекта - .NET решение, общие свойства, управление пакетами
2. Аутентификация - интеграция Supabase, ASP.NET Core Identity
3. UI фреймворк - MudBlazor, темы, компоненты
4. Слой БД - Entity Framework Core, репозитории, миграции
5. Базовые пакеты - типы, утилиты, интернационализация
</details>

### Phase 2: First Feature - Clusters (Planned / Запланирована)

**Estimated Duration**: 1-2 weeks / Примерная длительность: 1-2 недели

The Clusters feature serves as the base template for other similar features (Metaverses, Uniks, etc.).

**Entities / Сущности:**
- **Clusters** (Кластеры) - Top-level organization units
- **Domains** (Домены) - Sub-units within clusters
- **Resources** (Ресурсы) - Items within domains

**Functionality / Функциональность:**

1. **Clusters Management / Управление кластерами**
   - List all clusters
   - View cluster details
   - Create new cluster
   - Edit cluster
   - Delete cluster
   - Search and filter clusters

2. **Domains Management / Управление доменами**
   - List domains within a cluster
   - View domain details
   - Create new domain
   - Edit domain
   - Delete domain
   - Associate domains with clusters

3. **Resources Management / Управление ресурсами**
   - List resources within a domain
   - View resource details
   - Create new resource
   - Edit resource
   - Delete resource
   - Associate resources with domains

**Technical Implementation / Техническая реализация:**

- **Frontend** (`clusters-frt/base`):
  - Blazor pages for CRUD operations
  - MudBlazor components for UI
  - State management with Fluxor
  - Form validation
  - Error handling

- **Backend** (`clusters-srv/base`):
  - ASP.NET Core Web API controllers
  - Service layer for business logic
  - Repository pattern for data access
  - Entity Framework Core entities
  - AutoMapper for DTO mapping

**Database Schema / Схема базы данных:**

```sql
CREATE TABLE clusters (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id)
);

CREATE TABLE domains (
    id UUID PRIMARY KEY,
    cluster_id UUID REFERENCES clusters(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id)
);

CREATE TABLE resources (
    id UUID PRIMARY KEY,
    domain_id UUID REFERENCES domains(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100),
    url TEXT,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id)
);
```

<details>
<summary>In Russian</summary>

Функция Кластеров служит базовым шаблоном для других похожих функций.

**Сущности:**
- Кластеры - организационные единицы верхнего уровня
- Домены - под-единицы в кластерах
- Ресурсы - элементы в доменах

**Функциональность:**
1. Управление кластерами - CRUD операции
2. Управление доменами - CRUD операции
3. Управление ресурсами - CRUD операции
</details>

### Phase 3: Additional Features (Planned / Запланирована)

**Estimated Duration**: 3-4 weeks / Примерная длительность: 3-4 недели

Based on the Clusters template, implement:

1. **Metaverses** (Метавселенные)
   - Entities: Metaverses / Sections / Entities
   - Similar structure to Clusters
   - Additional VR/AR specific fields

2. **Uniks** (Уники)
   - Entities: Uniks / [Multi-level structure]
   - More complex hierarchy
   - Advanced permissions

3. **Spaces** (Пространства)
   - Entities: Spaces / Canvases
   - Node-based editor foundation
   - Canvas management

4. **Profile** (Профиль)
   - User profile management
   - Settings and preferences
   - Avatar and customization

5. **Analytics** (Аналитика)
   - Dashboard components
   - Usage statistics
   - Performance metrics

<details>
<summary>In Russian</summary>

На основе шаблона Кластеров реализовать: Метавселенные, Уники, Пространства, Профиль, Аналитику.
</details>

### Phase 4: UPDL System (Planned / Запланирована)

**Estimated Duration**: 4-6 weeks / Примерная длительность: 4-6 недели

**Universal Platform Description Language (UPDL) / Универсальный язык описания платформы:**

1. **Node System / Система узлов**
   - Base node types
   - Node properties
   - Node connections
   - Node validation

2. **Node Types / Типы узлов:**
   - Scene nodes
   - Object nodes (3D models, primitives)
   - Camera nodes
   - Light nodes
   - Interaction nodes
   - Animation nodes
   - Logic nodes

3. **Node Editor / Редактор узлов**
   - Visual node editor using Blazor
   - Drag and drop functionality
   - Connection validation
   - Property panels
   - Preview system

4. **UPDL Parser / Парсер UPDL**
   - Parse UPDL JSON
   - Validate node structure
   - Generate scene graph
   - Export to different formats

<details>
<summary>In Russian</summary>

**UPDL система:**
1. Система узлов - базовые типы, свойства, связи
2. Типы узлов - сцены, объекты, камеры, свет, взаимодействия, анимации, логика
3. Редактор узлов - визуальный редактор на Blazor
4. Парсер UPDL - парсинг, валидация, экспорт
</details>

### Phase 5: Publication System (Planned / Запланирована)

**Estimated Duration**: 3-4 weeks / Примерная длительность: 3-4 недели

1. **Export System / Система экспорта**
   - UPDL to AR.js converter
   - UPDL to PlayCanvas converter
   - UPDL to Babylon.js converter
   - UPDL to Three.js converter
   - UPDL to A-Frame converter

2. **Publication Management / Управление публикацией**
   - Create publication
   - Version control
   - URL generation
   - Embedding options
   - Access control

3. **Deployment / Развёртывание**
   - Static file hosting
   - CDN integration
   - Custom domain support
   - Analytics integration

<details>
<summary>In Russian</summary>

**Система публикации:**
1. Экспорт - конвертеры в различные форматы
2. Управление публикацией - версионирование, URL, доступ
3. Развёртывание - хостинг, CDN, домены
</details>

### Phase 6: Advanced Features (Future / Будущее)

**Estimated Duration**: Ongoing / Длительность: Постоянная

1. **Multiplayer Support / Поддержка многопользователя**
   - SignalR integration
   - Real-time collaboration
   - User presence
   - Synchronized state

2. **Kiberplano Integration / Интеграция Киберплано**
   - Resource planning
   - Task management
   - Robot control interfaces
   - Production chains

3. **3D Editor Enhancements / Улучшения 3D редактора**
   - Advanced material editor
   - Physics simulation
   - Particle systems
   - Shader editor

4. **AI Integration / Интеграция ИИ**
   - LangChain nodes
   - AI-assisted content generation
   - NPC behavior AI
   - Procedural generation

<details>
<summary>In Russian</summary>

**Продвинутые функции:**
1. Поддержка многопользователя - SignalR, совместная работа
2. Интеграция Киберплано - планирование ресурсов, управление задачами
3. Улучшения 3D редактора - материалы, физика, частицы, шейдеры
4. Интеграция ИИ - LangChain, генерация контента, поведение NPC
</details>

## Feature Comparison with React Version / Сравнение функций с версией на React

| Feature | React Version | C# Version | Status |
|---------|---------------|------------|--------|
| Authentication | ✅ Passport.js | ⏳ ASP.NET Identity | Planned |
| Clusters | ✅ Implemented | ⏳ Planned | Phase 2 |
| Metaverses | ✅ Implemented | ⏳ Planned | Phase 3 |
| Uniks | ✅ Implemented | ⏳ Planned | Phase 3 |
| Spaces | ✅ Partial | ⏳ Planned | Phase 3 |
| UPDL | ✅ Partial | ⏳ Planned | Phase 4 |
| Publication | ✅ Partial | ⏳ Planned | Phase 5 |
| Multiplayer | ❌ Future | ⏳ Planned | Phase 6 |

Legend / Легенда:
- ✅ Implemented / Реализовано
- ⏳ Planned / Запланировано
- ❌ Not implemented / Не реализовано

## Technology Stack Summary / Сводка технологического стека

### Frontend / Фронтенд
- **Blazor WebAssembly** - UI framework
- **MudBlazor** - Material Design components
- **Fluxor** - State management
- **Blazor Router** - Routing

### Backend / Бэкенд
- **ASP.NET Core** - Web framework
- **Entity Framework Core** - ORM
- **AutoMapper** - Object mapping
- **FluentValidation** - Input validation
- **Serilog** - Logging

### Database / База данных
- **PostgreSQL** (via Supabase)
- **Entity Framework Core Migrations**

### DevOps
- **.NET CLI** - Build and deployment
- **GitHub Actions** - CI/CD
- **Docker** - Containerization

### Testing / Тестирование
- **xUnit** - Unit testing framework
- **Moq** - Mocking framework
- **FluentAssertions** - Assertion library
- **Testcontainers** - Integration testing

## Contributing to Features / Вклад в функции

To contribute to a specific feature:

1. **Check the roadmap** - See which phase it belongs to
2. **Review existing issues** - Look for related issues in GitHub
3. **Create a specification** - Use `/speckit.specify` if needed
4. **Implement incrementally** - Break down into small PRs
5. **Follow patterns** - Use Clusters as a template for similar features

<details>
<summary>In Russian</summary>

Чтобы внести вклад в конкретную функцию:
1. Проверьте дорожную карту
2. Просмотрите существующие issues
3. Создайте спецификацию
4. Реализуйте постепенно
5. Следуйте паттернам
</details>

## References / Ссылки

- [React Version Repository](https://github.com/teknokomo/universo-platformo-react)
- [ARCHITECTURE.md](ARCHITECTURE.md) - Complete architecture documentation with database, session, UI, and i18n
- [THREE_ENTITY_PATTERN.md](THREE_ENTITY_PATTERN.md) - Specification for hierarchical feature pattern
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [SETUP.md](SETUP.md)
- [GITHUB_SETUP.md](GITHUB_SETUP.md) - Manual GitHub labels and settings setup

<details>
<summary>In Russian</summary>

- [Репозиторий версии React](https://github.com/teknokomo/universo-platformo-react)
- [ARCHITECTURE.md](ARCHITECTURE.md) - Полная документация архитектуры с базой данных, сеансами, UI и i18n
- [THREE_ENTITY_PATTERN.md](THREE_ENTITY_PATTERN.md) - Спецификация паттерна иерархических функций
- [CONTRIBUTING.md](CONTRIBUTING.md)
- [SETUP.md](SETUP.md)
- [GITHUB_SETUP.md](GITHUB_SETUP.md) - Ручная настройка меток и настроек GitHub
</details>
