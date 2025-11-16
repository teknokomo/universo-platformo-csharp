# Contributing to Universo Platformo C#

First off, thank you for considering contributing to Universo Platformo C#! It's people like you who help create a global teknokomization and save humanity from final enslavement and total destruction.

<details>
<summary>In Russian</summary>

# Участие в разработке Universo Platformo C#

Прежде всего, спасибо за то, что рассматриваете возможность внести вклад в Universo Platformo C#! Именно такие люди, как вы, помогают создать глобальную текнокомизацию и спасти человечество от окончательного порабощения и полного уничтожения.
</details>

## Table of Contents / Содержание

- [Code of Conduct / Кодекс поведения](#code-of-conduct--кодекс-поведения)
- [Getting Started / Начало работы](#getting-started--начало-работы)
- [Development Process / Процесс разработки](#development-process--процесс-разработки)
- [Coding Standards / Стандарты кодирования](#coding-standards--стандарты-кодирования)
- [Testing Guidelines / Руководство по тестированию](#testing-guidelines--руководство-по-тестированию)
- [Documentation / Документация](#documentation--документация)
- [Pull Request Process / Процесс Pull Request](#pull-request-process--процесс-pull-request)
- [Issue Guidelines / Руководство по Issues](#issue-guidelines--руководство-по-issues)

## Code of Conduct / Кодекс поведения

This project follows the principles outlined in the Omsk Open License, which includes respect for traditional values and meaningful contribution to society. We expect all contributors to:

- Be respectful and inclusive
- Focus on constructive criticism
- Help build a positive community
- Contribute meaningfully to the project goals

<details>
<summary>In Russian</summary>

Этот проект следует принципам, изложенным в Omsk Open License, которая включает уважение к традиционным ценностям и осмысленный вклад в общество. Мы ожидаем, что все участники будут:

- Уважительными и инклюзивными
- Фокусироваться на конструктивной критике
- Помогать строить позитивное сообщество
- Вносить осмысленный вклад в цели проекта
</details>

## Getting Started / Начало работы

### Prerequisites / Требования

- .NET 9.0 SDK or later / .NET 9.0 SDK или новее
- Visual Studio 2022, VS Code, or Rider / Visual Studio 2022, VS Code или Rider
- Git for version control / Git для контроля версий
- Basic knowledge of C# and Blazor / Базовые знания C# и Blazor

### Setting Up Development Environment / Настройка среды разработки

1. Fork the repository / Форкните репозиторий
2. Clone your fork / Клонируйте свой форк

```bash
git clone https://github.com/YOUR_USERNAME/universo-platformo-csharp.git
cd universo-platformo-csharp
```

3. Add upstream remote / Добавьте upstream remote

```bash
git remote add upstream https://github.com/teknokomo/universo-platformo-csharp.git
```

4. Create a feature branch / Создайте ветку функционала

```bash
git checkout -b feature/your-feature-name
```

<details>
<summary>In Russian</summary>

### Настройка среды разработки

1. Форкните репозиторий
2. Клонируйте свой форк
3. Добавьте upstream remote
4. Создайте ветку функционала
</details>

## Development Process / Процесс разработки

### Workflow / Рабочий процесс

1. **Pick an Issue / Выберите Issue**
   - Check existing issues or create a new one
   - Comment on the issue to claim it
   - Wait for maintainer approval before starting work

2. **Create a Branch / Создайте ветку**
   - Branch from `main` for new features
   - Use descriptive branch names: `feature/`, `bugfix/`, `docs/`

3. **Make Changes / Внесите изменения**
   - Write clean, maintainable code
   - Follow coding standards (see below)
   - Add tests for new functionality
   - Update documentation as needed

4. **Commit / Коммитьте**
   - Write clear commit messages
   - Reference issue numbers in commits
   - Keep commits atomic and focused

5. **Push and Create PR / Запушьте и создайте PR**
   - Push to your fork
   - Create a pull request to upstream
   - Fill out the PR template completely

<details>
<summary>In Russian</summary>

### Рабочий процесс

1. **Выберите Issue** - Проверьте существующие issues или создайте новую
2. **Создайте ветку** - Создайте ветку от `main` для новых функций
3. **Внесите изменения** - Пишите чистый, поддерживаемый код
4. **Коммитьте** - Пишите ясные сообщения коммитов
5. **Запушьте и создайте PR** - Создайте pull request в upstream
</details>

## Coding Standards / Стандарты кодирования

### C# Style Guide / Руководство по стилю C#

- **Naming Conventions / Соглашения об именовании:**
  - Classes, methods, properties: `PascalCase`
  - Private fields: `_camelCase` with underscore prefix
  - Local variables, parameters: `camelCase`
  - Constants: `PascalCase`
  - Interfaces: `IPascalCase` with 'I' prefix

- **Code Organization / Организация кода:**
  - One class per file
  - Organize usings at the top
  - Use file-scoped namespaces (C# 10+)
  - Keep methods small and focused

- **Best Practices / Лучшие практики:**
  - Use LINQ for collections
  - Prefer `async/await` for asynchronous code
  - Use dependency injection
  - Avoid magic numbers and strings
  - Use meaningful variable names

### Example / Пример

```csharp
namespace Universo.Packages.Clusters;

public interface IClusterService
{
    Task<Cluster> GetClusterAsync(Guid id);
}

public class ClusterService : IClusterService
{
    private readonly IClusterRepository _repository;
    private readonly ILogger<ClusterService> _logger;

    public ClusterService(
        IClusterRepository repository,
        ILogger<ClusterService> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    public async Task<Cluster> GetClusterAsync(Guid id)
    {
        _logger.LogInformation("Retrieving cluster {ClusterId}", id);
        return await _repository.GetByIdAsync(id);
    }
}
```

<details>
<summary>In Russian</summary>

### Руководство по стилю C#

- **Соглашения об именовании:** Классы, методы, свойства - PascalCase; Приватные поля - _camelCase
- **Организация кода:** Один класс на файл, использовать file-scoped namespaces
- **Лучшие практики:** Использовать LINQ, async/await, внедрение зависимостей
</details>

## Testing Guidelines / Руководство по тестированию

### Unit Tests / Юнит-тесты

- Write unit tests for all business logic
- Use xUnit as the testing framework
- Use Moq for mocking dependencies
- Aim for high code coverage (>80%)
- Test both success and failure scenarios

### Integration Tests / Интеграционные тесты

- Test API endpoints
- Test database operations
- Use TestContainers for database testing
- Clean up test data after tests

### Test Naming / Именование тестов

```csharp
[Fact]
public async Task GetClusterAsync_WithValidId_ReturnsCluster()
{
    // Arrange
    var clusterId = Guid.NewGuid();
    
    // Act
    var result = await _service.GetClusterAsync(clusterId);
    
    // Assert
    Assert.NotNull(result);
}
```

<details>
<summary>In Russian</summary>

### Руководство по тестированию

- Пишите юнит-тесты для всей бизнес-логики
- Используйте xUnit как фреймворк тестирования
- Используйте Moq для моков зависимостей
- Стремитесь к высокому покрытию кода (>80%)
- Тестируйте как успешные, так и неуспешные сценарии
</details>

## Documentation / Документация

### Code Documentation / Документация кода

- Write XML documentation comments for all public APIs
- Include parameter descriptions
- Include return value descriptions
- Include exception descriptions
- Add usage examples for complex methods

### Example / Пример

```csharp
/// <summary>
/// Retrieves a cluster by its unique identifier.
/// </summary>
/// <param name="id">The unique identifier of the cluster.</param>
/// <returns>
/// The cluster with the specified identifier, or null if not found.
/// </returns>
/// <exception cref="ArgumentException">
/// Thrown when the id parameter is empty.
/// </exception>
/// <example>
/// <code>
/// var cluster = await service.GetClusterAsync(clusterId);
/// </code>
/// </example>
public async Task<Cluster?> GetClusterAsync(Guid id)
{
    if (id == Guid.Empty)
        throw new ArgumentException("Cluster ID cannot be empty", nameof(id));
        
    return await _repository.GetByIdAsync(id);
}
```

### README Files / README файлы

- Create README.md for each package
- Include both English and Russian versions
- Follow the bilingual format established in project instructions
- Document package purpose, API, and usage examples

<details>
<summary>In Russian</summary>

### Документация

- Пишите XML комментарии документации для всех публичных API
- Включайте описания параметров, возвращаемых значений и исключений
- Добавляйте примеры использования для сложных методов
- Создавайте README.md для каждого пакета на английском и русском
</details>

## Pull Request Process / Процесс Pull Request

### Before Submitting / Перед отправкой

1. **Ensure all tests pass / Убедитесь, что все тесты проходят**

```bash
dotnet test
```

2. **Build successfully / Успешная сборка**

```bash
dotnet build
```

3. **Update documentation / Обновите документацию**
   - Update README if needed
   - Update API documentation
   - Update changelog

4. **Follow PR template / Следуйте шаблону PR**
   - Use the PR template structure from `.github/instructions/github-pr.md`
   - Include English and Russian descriptions
   - Reference the related issue

### PR Title Format / Формат заголовка PR

```
GH123 Add cluster management functionality
```

Where `GH123` is the issue number.

### PR Description Template / Шаблон описания PR

```markdown
Fixes #123

# Description

Brief description of changes.

## Changes Made

- Specific change 1
- Specific change 2

## Additional Work

- Documentation updates
- Test additions

## Testing

- [x] Manual testing completed
- [x] Automated tests pass
- [x] No breaking changes

<details>
<summary>In Russian</summary>

Исправляет #123

# Описание

Краткое описание изменений.

## Внесенные изменения

- Конкретное изменение 1
- Конкретное изменение 2

## Дополнительная работа

- Обновления документации
- Добавление тестов

## Тестирование

- [x] Ручное тестирование завершено
- [x] Автоматические тесты проходят
- [x] Не внесено критических изменений
</details>
```

<details>
<summary>In Russian</summary>

### Процесс Pull Request

1. Убедитесь, что все тесты проходят
2. Успешно соберите проект
3. Обновите документацию
4. Следуйте шаблону PR
5. Используйте формат заголовка с номером issue: `GH123 Описание`
</details>

## Issue Guidelines / Руководство по Issues

### Creating Issues / Создание Issues

1. **Check for duplicates / Проверьте дубликаты**
   - Search existing issues first

2. **Use issue template / Используйте шаблон issue**
   - Follow the structure from `.github/instructions/github-issues.md`
   - Include both English and Russian descriptions

3. **Be specific / Будьте конкретны**
   - Clear title describing the issue
   - Detailed description of the problem or feature
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior

4. **Add appropriate labels / Добавьте соответствующие метки**
   - See `.github/instructions/github-labels.md` for label guidelines

### Issue Title Examples / Примеры заголовков Issues

Good examples / Хорошие примеры:
- "Add cluster deletion functionality"
- "Fix authentication error on login"
- "Update documentation for Blazor components"

Bad examples / Плохие примеры:
- "Bug" (too vague / слишком размыто)
- "It doesn't work" (not specific / не конкретно)

<details>
<summary>In Russian</summary>

### Создание Issues

1. Проверьте дубликаты
2. Используйте шаблон issue с английским и русским описанием
3. Будьте конкретны в описании
4. Добавьте соответствующие метки
</details>

## Package Structure / Структура пакетов

When adding new packages, follow this structure:

```
src/packages/
└── your-package-name/
    └── base/
        ├── YourPackage.csproj
        ├── README.md
        ├── README-RU.md
        └── src/
            ├── Services/
            ├── Models/
            ├── Controllers/ (for backend)
            └── Pages/ (for frontend)
```

<details>
<summary>In Russian</summary>

### Структура пакетов

При добавлении новых пакетов следуйте этой структуре с папкой `base/` и README на двух языках.
</details>

## Questions? / Вопросы?

If you have questions about contributing, feel free to:

- Create a discussion on GitHub
- Contact the maintainers (see README.md for contact info)
- Ask in existing issues

<details>
<summary>In Russian</summary>

Если у вас есть вопросы о внесении вклада:

- Создайте обсуждение на GitHub
- Свяжитесь с мейнтейнерами (см. README.md)
- Спросите в существующих issues
</details>

## Thank You! / Спасибо!

Your contributions help make Universo Platformo C# better and contribute to the global teknokomization effort!

<details>
<summary>In Russian</summary>

Ваш вклад помогает сделать Universo Platformo C# лучше и способствует усилиям глобальной текнокомизации!
</details>
