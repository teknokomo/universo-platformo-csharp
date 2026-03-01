# GitHub Setup Guide

**Version**: 1.0  
**Date**: November 16, 2025  
**Purpose**: Manual setup procedures for GitHub repository configuration

<details>
<summary>In Russian</summary>

# Руководство по настройке GitHub

**Версия**: 1.0  
**Дата**: 16 ноября 2025  
**Цель**: Процедуры ручной настройки для конфигурации репозитория GitHub
</details>

---

## Overview

This guide provides step-by-step instructions for setting up GitHub labels, branch protection rules, and other manual configurations required for the Universo Platformo C# repository.

<details>
<summary>In Russian</summary>

## Обзор

Это руководство предоставляет пошаговые инструкции по настройке меток GitHub, правил защиты веток и других ручных конфигураций, требуемых для репозитория Universo Platformo C#.
</details>

---

## GitHub Labels Setup

Labels must be created manually in the repository settings. Follow these steps:

### Step 1: Access Label Settings

1. Navigate to your repository: `https://github.com/teknokomo/universo-platformo-csharp`
2. Click on **"Issues"** tab
3. Click on **"Labels"** button
4. Click **"New label"** button

<details>
<summary>In Russian</summary>

### Шаг 1: Доступ к настройкам меток

1. Перейдите в ваш репозиторий
2. Нажмите на вкладку "Issues"
3. Нажмите кнопку "Labels"
4. Нажмите кнопку "New label"
</details>

### Step 2: Create Labels

Create each label with the exact name, description, and color specified below:

#### Priority Labels / Метки приоритета

| Label Name | Description | Color |
|------------|-------------|-------|
| `priority: critical` | Critical priority, must be addressed immediately | `#B60205` (Red) |
| `priority: high` | High priority, should be addressed soon | `#D93F0B` (Dark Orange) |
| `priority: medium` | Medium priority, normal timeline | `#FBCA04` (Yellow) |
| `priority: low` | Low priority, can be deferred | `#0E8A16` (Green) |

#### Type Labels / Метки типа

| Label Name | Description | Color |
|------------|-------------|-------|
| `type: feature` | New feature or enhancement | `#A2EEEF` (Light Blue) |
| `type: bug` | Something isn't working | `#D73A4A` (Red) |
| `type: documentation` | Improvements or additions to documentation | `#0075CA` (Blue) |
| `type: refactor` | Code refactoring | `#FBCA04` (Yellow) |
| `type: performance` | Performance improvements | `#D4C5F9` (Purple) |
| `type: security` | Security improvements or vulnerabilities | `#B60205` (Red) |
| `type: test` | Adding or updating tests | `#1D76DB` (Dark Blue) |

#### Status Labels / Метки статуса

| Label Name | Description | Color |
|------------|-------------|-------|
| `status: in-progress` | Work is currently in progress | `#FEF2C0` (Light Yellow) |
| `status: blocked` | Blocked by dependencies or issues | `#D73A4A` (Red) |
| `status: review-needed` | Needs code review | `#0E8A16` (Green) |
| `status: needs-info` | More information is needed | `#D876E3` (Pink) |
| `status: ready` | Ready for implementation | `#0075CA` (Blue) |

#### Component Labels / Метки компонентов

| Label Name | Description | Color |
|------------|-------------|-------|
| `component: frontend` | Related to Blazor frontend | `#C5DEF5` (Light Blue) |
| `component: backend` | Related to ASP.NET backend | `#BFD4F2` (Light Purple) |
| `component: database` | Related to database schema | `#D4C5F9` (Purple) |
| `component: auth` | Related to authentication/authorization | `#F9D0C4` (Light Orange) |
| `component: ui` | Related to UI/UX | `#C2E0C6` (Light Green) |
| `component: api` | Related to API endpoints | `#FEF2C0` (Light Yellow) |

#### Package Labels / Метки пакетов

| Label Name | Description | Color |
|------------|-------------|-------|
| `package: clusters` | Related to Clusters package | `#BFDADC` (Light Teal) |
| `package: metaverses` | Related to Metaverses package | `#C2E0C6` (Light Green) |
| `package: uniks` | Related to Uniks package | `#D4C5F9` (Purple) |
| `package: spaces` | Related to Spaces package | `#FEF2C0` (Light Yellow) |
| `package: auth` | Related to Auth package | `#F9D0C4` (Light Orange) |
| `package: shared` | Related to shared libraries | `#E99695` (Pink) |

#### Special Labels / Специальные метки

| Label Name | Description | Color |
|------------|-------------|-------|
| `good first issue` | Good for newcomers | `#7057FF` (Purple) |
| `help wanted` | Extra attention is needed | `#008672` (Teal) |
| `question` | Further information is requested | `#D876E3` (Pink) |
| `wontfix` | This will not be worked on | `#FFFFFF` (White) |
| `duplicate` | This issue or pull request already exists | `#CFD3D7` (Gray) |
| `dependencies` | Pull requests that update a dependency | `#0366D6` (Blue) |

<details>
<summary>In Russian</summary>

### Шаг 2: Создание меток

Создайте каждую метку с точным именем, описанием и цветом, указанными в таблицах выше.
</details>

### Step 3: Verify Labels

After creating all labels, verify that:
1. All 37 labels are created
2. Names match exactly (including spaces and special characters)
3. Colors are set correctly
4. Descriptions are clear and helpful

<details>
<summary>In Russian</summary>

### Шаг 3: Проверка меток

После создания всех меток проверьте, что:
1. Создано все 37 меток
2. Имена точно совпадают
3. Цвета установлены правильно
4. Описания ясны и полезны
</details>

---

## Branch Protection Rules

Configure branch protection rules to maintain code quality and prevent accidental changes to important branches.

### Step 1: Access Branch Settings

1. Navigate to **Settings** → **Branches**
2. Click **"Add rule"** under "Branch protection rules"

### Step 2: Protect Main Branch

Create a protection rule for `main` branch:

**Branch name pattern**: `main`

**Settings to enable**:
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: **1**
  - ✅ Dismiss stale pull request approvals when new commits are pushed
  - ✅ Require review from Code Owners
- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - Required status checks: `build`, `test` (will be available after CI/CD setup)
- ✅ **Require conversation resolution before merging**
- ✅ **Require signed commits** (optional but recommended)
- ✅ **Include administrators** (enforce rules for everyone)
- ✅ **Restrict who can push to matching branches** (optional)

<details>
<summary>In Russian</summary>

### Шаг 2: Защита основной ветки

Создайте правило защиты для ветки `main` с включенными настройками для обязательных проверок, утверждений PR и разрешения обсуждений.
</details>

### Step 3: Protect Development Branch (Optional)

If using a `develop` branch, create similar rules with potentially relaxed requirements:

**Branch name pattern**: `develop`

**Settings to enable**:
- ✅ Require a pull request before merging
  - ✅ Require approvals: **1**
- ✅ Require status checks to pass before merging
- ✅ Require conversation resolution before merging

<details>
<summary>In Russian</summary>

### Шаг 3: Защита ветки разработки (опционально)

Если используется ветка `develop`, создайте похожие правила с потенциально смягченными требованиями.
</details>

---

## Repository Settings

### General Settings

1. Navigate to **Settings** → **General**
2. Configure the following:

**Features**:
- ✅ Issues
- ✅ Preserve this repository (if critical)
- ✅ Discussions (if needed for community)
- ✅ Projects

**Pull Requests**:
- ✅ Allow squash merging
- ✅ Allow merge commits
- ❌ Allow rebase merging (to keep clean history)
- ✅ Always suggest updating pull request branches
- ✅ Allow auto-merge
- ✅ Automatically delete head branches

<details>
<summary>In Russian</summary>

### Общие настройки

Настройте функции репозитория и параметры pull request для оптимального рабочего процесса.
</details>

### Collaborators and Teams

1. Navigate to **Settings** → **Collaborators and teams**
2. Add team members with appropriate permissions:
   - **Admin**: Full access (for project leads)
   - **Write**: Can push and create PRs (for core developers)
   - **Read**: Can view and clone (for external contributors)

<details>
<summary>In Russian</summary>

### Соавторы и команды

Добавьте членов команды с соответствующими разрешениями (Admin, Write, Read).
</details>

---

## Issue Templates

Issue templates should already exist in `.github/ISSUE_TEMPLATE/`. Verify they are available:

1. Navigate to **Issues** → **New issue**
2. Verify the following templates appear:
   - **Bug Report** (`bug_report.md`)
   - **Feature Request** (`feature_request.md`)
   - **Documentation** (`documentation.md`)

If templates are missing, they need to be created in the repository.

<details>
<summary>In Russian</summary>

## Шаблоны задач

Шаблоны задач должны уже существовать в `.github/ISSUE_TEMPLATE/`. Проверьте их наличие.
</details>

---

## Pull Request Template

Verify that `.github/pull_request_template.md` exists and is being used for new PRs.

When creating a new PR, you should see the template automatically filled in with:
- Description
- Type of Change
- Checklist
- Related Issues
- Bilingual sections

<details>
<summary>In Russian</summary>

## Шаблон Pull Request

Проверьте, что `.github/pull_request_template.md` существует и используется для новых PR.
</details>

---

## GitHub Actions Secrets

If your workflows require secrets (API keys, tokens, etc.), set them up:

1. Navigate to **Settings** → **Secrets and variables** → **Actions**
2. Click **"New repository secret"**
3. Add required secrets:
   - `SUPABASE_URL`: Your Supabase project URL
   - `SUPABASE_ANON_KEY`: Your Supabase anonymous key
   - Any other deployment or service credentials

<details>
<summary>In Russian</summary>

## Секреты GitHub Actions

Настройте секреты для рабочих процессов (URL Supabase, ключи API и т.д.).
</details>

---

## Verification Checklist

After completing all setup steps, verify:

- [ ] All 37 labels created with correct names and colors
- [ ] Branch protection rules configured for `main` branch
- [ ] Repository settings optimized (auto-delete branches, squash merge, etc.)
- [ ] Collaborators added with appropriate permissions
- [ ] Issue templates are accessible
- [ ] PR template is working
- [ ] Required secrets are configured (if applicable)

<details>
<summary>In Russian</summary>

## Контрольный список проверки

После завершения всех шагов настройки проверьте все пункты.
</details>

---

## Troubleshooting

### Labels Not Appearing in Issues

**Problem**: Labels don't show up when creating issues  
**Solution**: Refresh the page, clear cache, or wait a few minutes for GitHub to sync

### Branch Protection Not Working

**Problem**: Can push directly to protected branch  
**Solution**: Ensure "Include administrators" is checked if you're an admin

### PR Template Not Loading

**Problem**: Template doesn't appear in new PRs  
**Solution**: Verify file exists at `.github/pull_request_template.md` and is committed to `main` branch

<details>
<summary>In Russian</summary>

## Устранение неполадок

Решения распространенных проблем с метками, защитой веток и шаблонами PR.
</details>

---

## Additional Resources

- [GitHub Labels Documentation](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels)
- [Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)
- [Issue Templates Guide](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository)

<details>
<summary>In Russian</summary>

## Дополнительные ресурсы

Ссылки на официальную документацию GitHub по меткам, защите веток и шаблонам задач.
</details>

---

**Document Version**: 1.0  
**Last Updated**: November 16, 2025  
**Status**: Ready for Use
