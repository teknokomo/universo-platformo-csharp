# Автоматические миграции через Supabase CLI

## Проблема: Почему нельзя как в Django?

### Django (серверная архитектура)
```bash
python manage.py migrate  # ← работает, есть прямой доступ к PostgreSQL
```

**Django работает на сервере** → прямое подключение к БД → может выполнять DDL операции

### Blazor WASM (клиентская архитектура)
```csharp
// Ваш код выполняется В БРАУЗЕРЕ пользователя!
await SupabaseClient.From<Metahub>().Get();
```

**Blazor WASM работает в браузере** → только REST API → DDL операции запрещены (безопасность)

---

## Решение: Supabase CLI для миграций

Вы МОЖЕТЕ применять миграции через консоль, но нужно использовать **Supabase CLI** (у вас уже установлен v2.75.0).

## Опция 1: Link к Production и Apply (рекомендуется)

### Шаг 1: Link проекта
```powershell
# Из корня проекта
supabase link --project-ref pleeyslewsialvplxdpg
```

Вам понадобится **Database Password** из Supabase Dashboard:
- https://supabase.com/dashboard/project/pleeyslewsialvplxdpg/settings/database

### Шаг 2: Применить миграции
```powershell
supabase db push
```

Эта команда:
1. Найдёт все `.sql` файлы в `supabase/migrations/`
2. Проверит, какие уже применены
3. Применит новые миграции в порядке имён файлов
4. Запишет историю в `supabase_migrations.schema_migrations`

### Шаг 3: Проверка
```powershell
# Посмотреть историю миграций
supabase migration list

# Проверить статус
supabase db diff
```

---

## Опция 2: Локальная разработка с Local Supabase

### Преимущества
- ✅ PostgreSQL работает локально в Docker
- ✅ Автоматические миграции при старте
- ✅ Можно тестировать без интернета
- ✅ Не ломаете production базу

### Настройка

#### 1. Убедитесь что Docker запущен
```powershell
docker --version  # Должен быть установлен Docker Desktop
```

#### 2. Инициализация локального Supabase
```powershell
# Из корня проекта
supabase init  # Создаст supabase/config.toml если его нет
```

#### 3. Запуск локального Supabase
```powershell
supabase start
```

Это развернёт локально:
- PostgreSQL на `localhost:54322`
- Supabase Studio на `http://localhost:54323`
- PostgREST API на `http://localhost:54321`

#### 4. Применение миграций автоматически
```powershell
# Миграции автоматически применяются при supabase start
# Или вручную:
supabase db reset  # Пересоздаёт БД и применяет все миграции
```

#### 5. Переключение между local и production

В `appsettings.Development.json`:
```json
{
  "Supabase": {
    "Url": "http://localhost:54321",  // ← локальная БД
    "Key": "eyJh..."  // ← anon key из supabase start output
  }
}
```

В `appsettings.json`:
```json
{
  "Supabase": {
    "Url": "https://pleeyslewsialvplxdpg.supabase.co",  // ← production
    "Key": "eyJh..."
  }
}
```

---

## Опция 3: SQL через psql (как в Django)

Если хотите ПРЯМОЕ подключение как в Django:

### 1. Получите connection string из Dashboard
https://supabase.com/dashboard/project/pleeyslewsialvplxdpg/settings/database

Формат:
```
postgresql://postgres:[YOUR-PASSWORD]@db.pleeyslewsialvplxdpg.supabase.co:5432/postgres
```

### 2. Применить миграции вручную
```powershell
# Установите psql (входит в PostgreSQL)
scoop install postgresql  # если нет

# Применить первую миграцию
psql "postgresql://postgres:password@db.pleeyslewsialvplxdpg.supabase.co:5432/postgres" `
  -f supabase/migrations/20260211_create_metahubs_schema.sql

# Применить вторую миграцию
psql "postgresql://postgres:password@db.pleeyslewsialvplxdpg.supabase.co:5432/postgres" `
  -f supabase/migrations/20260211_add_enums_and_rls.sql
```

---

## Сравнение подходов

| Подход | Скорость | Безопасность | Удобство | Production Ready |
|--------|----------|--------------|----------|------------------|
| **Supabase Studio** (текущий) | ⭐⭐ (ручное копирование) | ⭐⭐⭐ | ⭐⭐⭐ (GUI) | ✅ Рекомендуется для первого раза |
| **`supabase db push`** | ⭐⭐⭐ | ⭐⭐ (нужен DB password) | ⭐⭐⭐ | ✅ Для CI/CD |
| **Local Supabase** | ⭐⭐⭐ | ⭐⭐⭐ (изолировано) | ⭐⭐⭐ | ✅ Для разработки |
| **psql** | ⭐⭐⭐ | ⭐ (прямой доступ) | ⭐⭐ | ⚠️ Для экспертов |

---

## Рекомендация

Для текущей ситуации делайте так:

### Сейчас (первый раз):
```powershell
# Применяем через Supabase Studio (уже есть инструкция в README.md)
# Это самый безопасный способ для первого раза
```

### Для будущей разработки:
```powershell
# Настройте локальный Supabase
supabase init
supabase start

# Теперь миграции применяются автоматически при старте!
# Как в Django, но безопаснее
```

---

## Итог: Вы МОЖЕТЕ делать как в Django!

Просто у Blazor WASM другая архитектура:
- Django: сервер → прямая миграция
- Blazor WASM: браузер → нужен инструмент (CLI)

**Используйте `supabase start` для локальной разработки** - это аналог `python manage.py migrate`, только лучше (изолировано, воспроизводимо, автоматически).

Хотите настроить локальный Supabase сейчас?
