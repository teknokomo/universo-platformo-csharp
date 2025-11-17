# Code Review Checklist

This checklist must be verified for every Pull Request to ensure compliance with the constitution and project standards.

## 1. Package Architecture Verification (NON-NEGOTIABLE)

**Constitution Principle I - Monorepo Package Architecture**

- [ ] **All feature functionality is in `src/packages/` directory**
  - ✅ Domain features (Clusters, Metaverses, Uniks, Auth, etc.)
  - ✅ Template packages
  - ✅ Any feature-specific functionality
  
- [ ] **NO feature functionality outside `src/packages/`**
  - ❌ Feature logic in `src/shared/` (shared is ONLY for infrastructure)
  - ❌ Feature logic in root directory
  - ❌ Feature logic in any other location
  
- [ ] **Proper package naming convention**
  - ✅ Frontend packages: `[feature]-frt` (e.g., `clusters-frt`)
  - ✅ Backend packages: `[feature]-srv` (e.g., `clusters-srv`)
  - ✅ Shared contracts: `[feature]-common` (optional)
  
- [ ] **Each package has `base/` directory**
  - ✅ Primary implementation in `base/` subdirectory
  - ✅ Future implementations will be sibling directories to `base/`

**Rationale**: This is NON-NEGOTIABLE because packages will gradually migrate to separate repositories. Any code outside `packages/` blocks this critical evolution.

## 2. Frontend/Backend Separation

**Constitution Principle II**

- [ ] **Clear separation maintained**
  - ✅ Frontend in `-frt` packages (Blazor WebAssembly)
  - ✅ Backend in `-srv` packages (ASP.NET Core)
  - ✅ No business logic in frontend packages
  - ✅ Backend exposes APIs (REST/gRPC)

## 3. Infrastructure vs Feature Code

**What goes in `src/shared/`:**
- ✅ Common types and interfaces (Universo.Types)
- ✅ Utility functions (Universo.Utils)
- ✅ Internationalization (Universo.I18n)
- ✅ Error handling, validation, caching (Universo.Common)
- ✅ API client libraries

**What goes in `src/packages/`:**
- ✅ ALL domain features (Clusters, Metaverses, Uniks, etc.)
- ✅ Authentication packages
- ✅ Template packages
- ✅ Feature-specific logic

## 4. Bilingual Documentation

**Constitution Principle IV**

- [ ] **All documentation is bilingual**
  - ✅ English version (e.g., `README.md`)
  - ✅ Russian version with `-RU` suffix (e.g., `README-RU.md`)
  - ✅ Identical structure and line count
  - ✅ Both versions updated simultaneously

## 5. Independent Testability

**Constitution Principle V**

- [ ] **Each package has its own tests**
  - ✅ Test directory exists in package
  - ✅ Package can be built independently
  - ✅ Package can be tested independently
  - ✅ No circular dependencies

## 6. Multi-Database Preparedness

**Constitution Principle VII**

- [ ] **Database access is abstracted**
  - ✅ Repository pattern used
  - ✅ Interfaces separate from implementations
  - ✅ Not Supabase-specific
  - ✅ EF Core ready for future DBMS

## 7. Error Handling Architecture

**Constitution Principle XI**

- [ ] **Centralized error handling implemented**
  - ✅ Custom exception types used
  - ✅ Global exception middleware configured
  - ✅ Structured error responses (ProblemDetails)
  - ✅ Blazor error boundaries for frontend

## 8. Validation Strategy

**Constitution Principle XII**

- [ ] **FluentValidation used for input validation**
  - ✅ Validator classes for DTOs
  - ✅ Validation at API boundaries
  - ✅ Both client and server validation

## 9. Code Quality

- [ ] **Follows C# coding conventions**
  - ✅ Nullable reference types enabled
  - ✅ XML documentation for public APIs
  - ✅ Async/await properly used
  - ✅ SOLID principles followed

## 10. GitHub Workflow Integration

**Constitution Principle VI**

- [ ] **PR follows standards**
  - ✅ PR title format: `GH{issue_number} {title}`
  - ✅ Links to related Issue
  - ✅ Bilingual description with spoiler tags
  - ✅ Russian translation complete (not just summary)

## 11. Security

- [ ] **No security vulnerabilities introduced**
  - ✅ No secrets in code
  - ✅ Input validation implemented
  - ✅ SQL injection prevented
  - ✅ XSS prevention in frontend

## 12. Performance

- [ ] **Performance considerations addressed**
  - ✅ Caching strategy considered
  - ✅ Database queries optimized
  - ✅ Async operations used appropriately

## Final Verification

- [ ] **All automated tests pass**
- [ ] **Build succeeds without warnings**
- [ ] **Documentation is complete and bilingual**
- [ ] **Constitution compliance verified**
- [ ] **No unjustified violations**

---

**Reviewer**: Before approving this PR, verify that ALL items above are checked. If any item is not applicable, note the reason in the PR comments.

**Submitter**: Self-review using this checklist before requesting review. It will save time and iterations.

<details>
<summary>In Russian</summary>

# Контрольный список проверки кода

Этот контрольный список должен быть проверен для каждого Pull Request для обеспечения соответствия конституции и стандартам проекта.

## 1. Проверка архитектуры пакетов (НЕ ПОДЛЕЖИТ ОБСУЖДЕНИЮ)

**Принцип I Конституции - Архитектура пакетов монорепозитория**

- [ ] **Вся функциональность находится в директории `src/packages/`**
  - ✅ Доменные функции (Кластеры, Метавселенные, Уники, Аутентификация и т.д.)
  - ✅ Пакеты шаблонов
  - ✅ Любая функциональность, специфичная для функции
  
- [ ] **НЕТ функциональности вне `src/packages/`**
  - ❌ Логика функций в `src/shared/` (shared ТОЛЬКО для инфраструктуры)
  - ❌ Логика функций в корневой директории
  - ❌ Логика функций в любом другом месте
  
- [ ] **Правильное соглашение об именовании пакетов**
  - ✅ Пакеты фронтенда: `[feature]-frt` (например, `clusters-frt`)
  - ✅ Пакеты бэкенда: `[feature]-srv` (например, `clusters-srv`)
  - ✅ Общие контракты: `[feature]-common` (опционально)
  
- [ ] **Каждый пакет имеет директорию `base/`**
  - ✅ Основная реализация в поддиректории `base/`
  - ✅ Будущие реализации будут соседними директориями с `base/`

**Обоснование**: Это НЕ ПОДЛЕЖИТ ОБСУЖДЕНИЮ, потому что пакеты постепенно мигрируют в отдельные репозитории. Любой код вне `packages/` блокирует эту критическую эволюцию.

## 2. Разделение фронтенда/бэкенда

**Принцип II Конституции**

- [ ] **Четкое разделение поддерживается**
  - ✅ Фронтенд в пакетах `-frt` (Blazor WebAssembly)
  - ✅ Бэкенд в пакетах `-srv` (ASP.NET Core)
  - ✅ Нет бизнес-логики в пакетах фронтенда
  - ✅ Бэкенд предоставляет API (REST/gRPC)

## 3. Код инфраструктуры vs код функций

**Что размещается в `src/shared/`:**
- ✅ Общие типы и интерфейсы (Universo.Types)
- ✅ Вспомогательные функции (Universo.Utils)
- ✅ Интернационализация (Universo.I18n)
- ✅ Обработка ошибок, валидация, кеширование (Universo.Common)
- ✅ Библиотеки API-клиентов

**Что размещается в `src/packages/`:**
- ✅ ВСЕ доменные функции (Кластеры, Метавселенные, Уники и т.д.)
- ✅ Пакеты аутентификации
- ✅ Пакеты шаблонов
- ✅ Логика, специфичная для функций

## 4. Двуязычная документация

**Принцип IV Конституции**

- [ ] **Вся документация двуязычная**
  - ✅ Английская версия (например, `README.md`)
  - ✅ Русская версия с суффиксом `-RU` (например, `README-RU.md`)
  - ✅ Идентичная структура и количество строк
  - ✅ Обе версии обновляются одновременно

## 5. Независимая тестируемость

**Принцип V Конституции**

- [ ] **Каждый пакет имеет свои собственные тесты**
  - ✅ Директория тестов существует в пакете
  - ✅ Пакет может быть собран независимо
  - ✅ Пакет может быть протестирован независимо
  - ✅ Нет циклических зависимостей

## 6. Готовность к мульти-базам данных

**Принцип VII Конституции**

- [ ] **Доступ к базе данных абстрагирован**
  - ✅ Используется паттерн репозитория
  - ✅ Интерфейсы отделены от реализаций
  - ✅ Не специфично для Supabase
  - ✅ EF Core готов для будущих СУБД

## 7. Архитектура обработки ошибок

**Принцип XI Конституции**

- [ ] **Реализована централизованная обработка ошибок**
  - ✅ Используются пользовательские типы исключений
  - ✅ Настроено глобальное промежуточное ПО для исключений
  - ✅ Структурированные ответы об ошибках (ProblemDetails)
  - ✅ Границы ошибок Blazor для фронтенда

## 8. Стратегия валидации

**Принцип XII Конституции**

- [ ] **FluentValidation используется для валидации входных данных**
  - ✅ Классы валидаторов для DTO
  - ✅ Валидация на границах API
  - ✅ Валидация как на клиенте, так и на сервере

## 9. Качество кода

- [ ] **Следует соглашениям о кодировании C#**
  - ✅ Включены ссылочные типы, допускающие значение null
  - ✅ XML-документация для публичных API
  - ✅ Async/await правильно используется
  - ✅ Соблюдаются принципы SOLID

## 10. Интеграция с рабочим процессом GitHub

**Принцип VI Конституции**

- [ ] **PR соответствует стандартам**
  - ✅ Формат заголовка PR: `GH{issue_number} {title}`
  - ✅ Ссылается на связанный Issue
  - ✅ Двуязычное описание с тегами спойлера
  - ✅ Русский перевод полный (не просто резюме)

## 11. Безопасность

- [ ] **Не внесены уязвимости безопасности**
  - ✅ Нет секретов в коде
  - ✅ Реализована валидация ввода
  - ✅ Предотвращение SQL-инъекций
  - ✅ Предотвращение XSS во фронтенде

## 12. Производительность

- [ ] **Рассмотрены вопросы производительности**
  - ✅ Рассмотрена стратегия кеширования
  - ✅ Оптимизированы запросы к базе данных
  - ✅ Асинхронные операции используются правильно

## Окончательная проверка

- [ ] **Все автоматические тесты проходят**
- [ ] **Сборка завершается без предупреждений**
- [ ] **Документация полная и двуязычная**
- [ ] **Проверено соответствие конституции**
- [ ] **Нет неоправданных нарушений**

---

**Рецензент**: Перед одобрением этого PR проверьте, что ВСЕ пункты выше отмечены. Если какой-либо пункт неприменим, отметьте причину в комментариях к PR.

**Отправитель**: Самостоятельная проверка с использованием этого контрольного списка перед запросом проверки. Это сэкономит время и итерации.
</details>
