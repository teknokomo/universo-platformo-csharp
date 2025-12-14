# API Host - Backend Service / API Хост - Серверная Служба

**Пакет**: `api-host-srv/base`  
**Тип**: Backend Service (ASP.NET Core Web API) / Серверная Служба  
**Версия**: 0.1.0-alpha  
**Статус**: В Разработке

## Обзор

API Хост - это главная точка входа для backend Universo Platformo. Он объединяет и размещает все пакеты функций (-srv packages), предоставляя единый API интерфейс для frontend приложения.

## Назначение

- **Композиция**: Объединяет все backend пакеты функций в единое развертываемое приложение
- **Конфигурация**: Централизованная конфигурация для аутентификации, кэширования, ограничения запросов и CORS
- **Документация**: Предоставляет Swagger/OpenAPI документацию для всех endpoints
- **Middleware**: Настраивает сквозные функции (логирование, обработка ошибок, безопасность)
- **Хостинг**: Production-ready ASP.NET Core хост с проверками здоровья и мониторингом

## Архитектура

Этот пакет следует **паттерну Application Host** из Конституции Принцип I:

```
api-host-srv/base/
├── Program.cs                    # Главная точка входа
├── appsettings.json              # Базовая конфигурация
├── appsettings.Development.json  # Переопределения для разработки
├── appsettings.Production.json   # Переопределения для production
└── README.md                     # Этот файл
```

## Возможности

### Текущая Реализация

- ✅ **Serilog Логирование**: Структурированное логирование с выводом в консоль и файлы
- ✅ **Swagger/OpenAPI**: Автоматически генерируемая API документация
- ✅ **CORS Поддержка**: Настраиваемый cross-origin resource sharing
- ✅ **Проверки Здоровья**: Базовый health endpoint на `/health`
- ✅ **Кэширование в Памяти**: IMemoryCache для локального кэширования
- ✅ **Ограничение Запросов**: Глобальное ограничение запросов с алгоритмом fixed window
- ✅ **Контроллеры**: Поддержка MVC контроллеров

### Запланированные Возможности

- ⏳ **Регистрация Сервисов**: Авто-регистрация всех сервисов -srv пакетов (T142.4)
- ⏳ **JWT Аутентификация**: Валидация Supabase JWT (T142.8)
- ⏳ **Обработка Ошибок**: Глобальный обработчик исключений с ProblemDetails (T142.5)
- ⏳ **Распределенное Кэширование**: Поддержка Redis (T142.12)
- ⏳ **Распределенное Ограничение Запросов**: Ограничение запросов на базе Redis (T142.13)
- ⏳ **Обнаружение Пакетов**: Динамическое обнаружение контроллеров и сервисов

## Конфигурация

### Переменные Окружения (Production)

Необходимые переменные окружения для production развертывания:

```bash
# База данных
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

# Redis (опционально, для распределенного кэширования)
REDIS_CONNECTION_STRING=your-redis-host:6379

# Хостинг
ALLOWED_HOSTS=your-api-domain.com
```

### Секции Конфигурации

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

#### Ограничение Запросов

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

#### Кэширование

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

## Запуск Локально

### Предварительные Требования

- .NET 9.0 SDK или новее
- PostgreSQL (при использовании базы данных)
- Redis (опционально, для распределенного кэширования)
- Аккаунт Supabase (для аутентификации)

### Режим Разработки

```bash
# Из корня репозитория
cd src/packages/api-host-srv/base

# Запустить API
dotnet run

# Или с режимом watch (авто-перезагрузка)
dotnet watch run
```

API запустится на:
- HTTP: http://localhost:5000
- HTTPS: https://localhost:5001

Swagger UI доступен по адресу: http://localhost:5000

### Сборка

```bash
# Debug сборка
dotnet build

# Release сборка
dotnet build -c Release

# Публикация для развертывания
dotnet publish -c Release -o ./publish
```

## Endpoints

### Встроенные Endpoints

| Метод | Путь | Описание |
|-------|------|----------|
| GET | `/health` | Endpoint проверки здоровья |
| GET | `/api/hello` | Тестовый endpoint |
| GET | `/swagger` | Swagger UI |
| GET | `/swagger/v1/swagger.json` | OpenAPI спецификация |

### Endpoints Пакетов Функций

Пакеты функций зарегистрируют свои собственные контроллеры:

- `/api/auth/*` - Аутентификация (auth-srv)
- `/api/clusters/*` - Управление кластерами (clusters-srv)
- `/api/metaverses/*` - Управление метавселенными (metaverses-srv)
- `/api/uniks/*` - Управление Unik/рабочими пространствами (uniks-srv)
- `/api/spaces/*` - Управление пространствами/канвасами (spaces-srv)
- `/api/profile/*` - Профиль пользователя (profile-srv)
- `/api/organizations/*` - Организации (organizations-srv)
- `/api/storage/*` - Хранилище файлов (storages-srv)
- `/api/publish/*` - Система публикации (publish-srv)

## Зависимости

### NuGet Пакеты

- `Microsoft.AspNetCore.Authentication.JwtBearer` - JWT аутентификация
- `Microsoft.Extensions.Configuration.Json` - JSON конфигурация
- `Serilog.AspNetCore` - Фреймворк логирования
- `Swashbuckle.AspNetCore` - Swagger/OpenAPI

### Ссылки на Проекты

- `Universo.Types` - Общие типы и интерфейсы
- `Universo.Utils` - Утилиты
- `Universo.I18n` - Интернационализация

## Логирование

Логи записываются в:

- **Консоль**: Структурированный вывод с цветами (разработка)
- **Файл**: `logs/api-host-YYYYMMDD.log` (ротация ежедневно)

Уровни логирования:
- Разработка: Debug
- Production: Warning

## Безопасность

### Текущие Функции Безопасности

- ✅ HTTPS редирект (только production)
- ✅ CORS с настраиваемыми источниками
- ✅ Ограничение запросов по IP адресу
- ✅ Проверки здоровья без аутентификации

### Запланированные Функции Безопасности

- ⏳ Валидация JWT токенов
- ⏳ Авторизация на основе ролей
- ⏳ API ключи для service-to-service аутентификации
- ⏳ Логирование запросов и аудит

## Мониторинг

### Проверки Здоровья

Endpoint `/health` предоставляет базовый статус здоровья. Будущие улучшения будут включать:

- Подключение к базе данных
- Подключение к Redis
- Доступность Supabase
- Использование памяти
- Дисковое пространство

### Метрики

Планируется интеграция метрик:
- Длительность запросов
- Количество запросов по endpoints
- Частота ошибок
- Попадания/промахи кэша

## Развертывание

### Docker

```dockerfile
# Пример Dockerfile (будет создан)
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

API может быть развернут в Azure App Service:

```bash
az webapp up --name universo-api --resource-group universo-rg --runtime "DOTNETCORE:9.0"
```

### Kubernetes

Пример конфигурации развертывания (будет создан в deployment/).

## Тестирование

```bash
# Запустить unit тесты
dotnet test

# Запустить с покрытием кода
dotnet test --collect:"XPlat Code Coverage"
```

## Устранение Неполадок

### Частые Проблемы

1. **Порт уже используется**
   ```bash
   # Измените порт в appsettings.json или используйте:
   dotnet run --urls "http://localhost:5001"
   ```

2. **CORS ошибки**
   - Проверьте `Cors.AllowedOrigins` в appsettings.json
   - Убедитесь что URL frontend включен
   - Проверьте что `AllowCredentials` установлен правильно

3. **JWT валидация не работает**
   - Проверьте что `Supabase.JwtSecret` совпадает с проектом Supabase
   - Проверьте что `Jwt.Issuer` совпадает с URL аутентификации Supabase
   - Убедитесь что токен отправляется в заголовке `Authorization: Bearer <token>`

## Участие в Разработке

См. корневой [CONTRIBUTING.md](../../../../CONTRIBUTING.md) для рабочего процесса разработки.

## Лицензия

Лицензировано под Omsk Open License. См. корневой [LICENSE.md](../../../../LICENSE.md).

## Связанная Документация

- [Обзор Архитектуры](../../../../ARCHITECTURE.md)
- [Руководство по Установке](../../../../SETUP.md)
- [Английская Документация](./README.md)
- [Список Задач](../../../../.specify/specs/001-initial-setup/tasks.md)

## Контакты

- VK: https://vk.com/vladimirlevadnij
- Telegram: https://t.me/Vladimir_Levadnij
- Email: universo.pro@yandex.com
- Веб-сайт: https://universo.pro
