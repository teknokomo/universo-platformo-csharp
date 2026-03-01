# Three-Entity Pattern Specification

**Version**: 1.0  
**Date**: November 16, 2025  
**Status**: Specification

<details>
<summary>In Russian</summary>

# Спецификация паттерна трех сущностей

**Версия**: 1.0  
**Дата**: 16 ноября 2025  
**Статус**: Спецификация
</details>

---

## Overview

The Three-Entity Pattern is a core architectural pattern in Universo Platformo that provides a consistent structure for hierarchical features. This pattern is used across multiple features (Clusters, Metaverses, Uniks, etc.) to maintain consistency and enable code reuse.

**Pattern Structure**:
```
Parent Entity
 └── Child Entity (many-to-one relationship with Parent)
      └── Grandchild Entity (many-to-one relationship with Child)
```

<details>
<summary>In Russian</summary>

## Обзор

Паттерн трех сущностей - это основной архитектурный паттерн в Universo Platformo, который обеспечивает согласованную структуру для иерархических функций. Этот паттерн используется в нескольких функциях для поддержания согласованности и повторного использования кода.
</details>

---

## Pattern Implementations

### 1. Clusters Feature

```
Cluster (Parent)
 └── Domain (Child)
      └── Resource (Grandchild)
```

**Use Case**: Organizing infrastructure and resources into hierarchical clusters.

<details>
<summary>In Russian</summary>

### 1. Функция Кластеров

**Случай использования**: Организация инфраструктуры и ресурсов в иерархические кластеры.
</details>

### 2. Metaverses Feature

```
Metaverse (Parent)
 └── Section (Child)
      └── Entity (Grandchild)
```

**Use Case**: Organizing metaverse content into sections and entities.

<details>
<summary>In Russian</summary>

### 2. Функция Метавселенных

**Случай использования**: Организация контента метавселенной в секции и сущности.
</details>

### 3. Uniks Feature (Extended Pattern)

```
Unik (Parent)
 └── UniLevel1 (Child)
      └── UniLevel2 (Grandchild)
           └── UniLevel3 (Extended - 4+ levels possible)
```

**Use Case**: Complex hierarchical structures with potentially unlimited depth.

<details>
<summary>In Russian</summary>

### 3. Функция Уников (расширенный паттерн)

**Случай использования**: Сложные иерархические структуры с потенциально неограниченной глубиной.
</details>

---

## Pattern Variations

### Two-Entity Pattern (Simplified)

```
Parent Entity
 └── Child Entity
```

**Example**: User Profiles
```
User
 └── ProfileSetting
```

**When to use**: Simple parent-child relationships without deep nesting.

<details>
<summary>In Russian</summary>

### Паттерн двух сущностей (упрощенный)

**Когда использовать**: Простые родительско-дочерние отношения без глубокой вложенности.
</details>

### Four+ Entity Pattern (Extended)

```
Level1
 └── Level2
      └── Level3
           └── Level4
                └── ...
```

**Example**: Complex organizational structures

**When to use**: Deep hierarchies where relationships must be explicitly modeled.

<details>
<summary>In Russian</summary>

### Паттерн четырех+ сущностей (расширенный)

**Когда использовать**: Глубокие иерархии, где отношения должны быть явно смоделированы.
</details>

---

## Entity Schema Template

All entities in the pattern follow this base structure:

```csharp
public class BaseHierarchicalEntity
{
    // Identity
    public Guid Id { get; set; }
    
    // Core Properties
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? Slug { get; set; } // URL-friendly identifier
    
    // Hierarchy
    public Guid? ParentId { get; set; } // Reference to parent entity
    public int Order { get; set; } // Display order among siblings
    
    // Metadata
    public JsonDocument? Metadata { get; set; } // Flexible additional data
    
    // Audit
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public Guid? CreatedBy { get; set; }
    public Guid? UpdatedBy { get; set; }
    
    // Soft Delete
    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    
    // Status
    public EntityStatus Status { get; set; } // Active, Inactive, Archived
}

public enum EntityStatus
{
    Active,
    Inactive,
    Archived
}
```

<details>
<summary>In Russian</summary>

Все сущности в паттерне следуют этой базовой структуре с идентификацией, основными свойствами, иерархией, метаданными, аудитом, мягким удалением и статусом.
</details>

---

## Database Schema Template

```sql
-- Parent Entity Table
CREATE TABLE {feature}_parents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    slug VARCHAR(255) UNIQUE,
    order_index INTEGER DEFAULT 0,
    metadata JSONB,
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id),
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Child Entity Table
CREATE TABLE {feature}_children (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID NOT NULL REFERENCES {feature}_parents(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    slug VARCHAR(255),
    order_index INTEGER DEFAULT 0,
    metadata JSONB,
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id),
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(parent_id, slug)
);

-- Grandchild Entity Table
CREATE TABLE {feature}_grandchildren (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID NOT NULL REFERENCES {feature}_children(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    slug VARCHAR(255),
    order_index INTEGER DEFAULT 0,
    metadata JSONB,
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id),
    is_deleted BOOLEAN DEFAULT false,
    deleted_at TIMESTAMP WITH TIME ZONE,
    UNIQUE(parent_id, slug)
);

-- Indexes
CREATE INDEX idx_{feature}_children_parent ON {feature}_children(parent_id);
CREATE INDEX idx_{feature}_grandchildren_parent ON {feature}_grandchildren(parent_id);
CREATE INDEX idx_{feature}_parents_status ON {feature}_parents(status) WHERE is_deleted = false;
CREATE INDEX idx_{feature}_children_status ON {feature}_children(status) WHERE is_deleted = false;
CREATE INDEX idx_{feature}_grandchildren_status ON {feature}_grandchildren(status) WHERE is_deleted = false;
```

<details>
<summary>In Russian</summary>

Шаблон схемы базы данных для паттерна трех сущностей с таблицами для родительской, дочерней и внучьей сущностей, включая индексы для оптимизации запросов.
</details>

---

## CRUD Operations Template

### Repository Interface

```csharp
public interface IHierarchicalRepository<TParent, TChild, TGrandchild>
    where TParent : BaseHierarchicalEntity
    where TChild : BaseHierarchicalEntity
    where TGrandchild : BaseHierarchicalEntity
{
    // Parent operations
    Task<TParent?> GetParentByIdAsync(Guid id);
    Task<IEnumerable<TParent>> GetAllParentsAsync();
    Task<TParent> CreateParentAsync(TParent entity);
    Task<TParent> UpdateParentAsync(TParent entity);
    Task DeleteParentAsync(Guid id);
    
    // Child operations
    Task<TChild?> GetChildByIdAsync(Guid id);
    Task<IEnumerable<TChild>> GetChildrenByParentIdAsync(Guid parentId);
    Task<TChild> CreateChildAsync(TChild entity);
    Task<TChild> UpdateChildAsync(TChild entity);
    Task DeleteChildAsync(Guid id);
    
    // Grandchild operations
    Task<TGrandchild?> GetGrandchildByIdAsync(Guid id);
    Task<IEnumerable<TGrandchild>> GetGrandchildrenByParentIdAsync(Guid parentId);
    Task<TGrandchild> CreateGrandchildAsync(TGrandchild entity);
    Task<TGrandchild> UpdateGrandchildAsync(TGrandchild entity);
    Task DeleteGrandchildAsync(Guid id);
    
    // Hierarchical operations
    Task<IEnumerable<TGrandchild>> GetAllGrandchildrenInHierarchyAsync(Guid parentId);
    Task<int> GetTotalCountInHierarchyAsync(Guid parentId);
}
```

### Service Layer Template

```csharp
public class HierarchicalService<TParent, TChild, TGrandchild>
    where TParent : BaseHierarchicalEntity
    where TChild : BaseHierarchicalEntity
    where TGrandchild : BaseHierarchicalEntity
{
    private readonly IHierarchicalRepository<TParent, TChild, TGrandchild> _repository;
    private readonly ILogger _logger;
    
    public async Task<TParent> CreateParentWithValidationAsync(TParent entity)
    {
        // Generate slug from name
        entity.Slug = GenerateSlug(entity.Name);
        
        // Validate slug uniqueness
        if (await IsSlugTakenAsync(entity.Slug))
        {
            entity.Slug = $"{entity.Slug}-{Guid.NewGuid().ToString().Substring(0, 8)}";
        }
        
        // Set audit fields
        entity.CreatedAt = DateTime.UtcNow;
        entity.UpdatedAt = DateTime.UtcNow;
        
        return await _repository.CreateParentAsync(entity);
    }
    
    // Similar methods for Child and Grandchild...
}
```

<details>
<summary>In Russian</summary>

Шаблоны интерфейсов репозиториев и сервисов для CRUD операций над иерархическими сущностями с валидацией, генерацией slug и аудитом.
</details>

---

## UI Component Reusability

### List Component Template

```razor
@typeparam TEntity where TEntity : BaseHierarchicalEntity

<MudTable Items="@Entities" Loading="@IsLoading" Hover="true" Breakpoint="Breakpoint.Sm">
    <ToolBarContent>
        <MudText Typo="Typo.h6">@Title</MudText>
        <MudSpacer />
        <MudButton Variant="Variant.Filled" 
                   Color="Color.Primary" 
                   OnClick="@OnCreateClick">
            Create New
        </MudButton>
    </ToolBarContent>
    <HeaderContent>
        <MudTh>Name</MudTh>
        <MudTh>Description</MudTh>
        <MudTh>Status</MudTh>
        <MudTh>Actions</MudTh>
    </HeaderContent>
    <RowTemplate>
        <MudTd DataLabel="Name">
            <MudLink Href="@GetDetailUrl(context.Id)">@context.Name</MudLink>
        </MudTd>
        <MudTd DataLabel="Description">@context.Description</MudTd>
        <MudTd DataLabel="Status">
            <MudChip Size="Size.Small" Color="@GetStatusColor(context.Status)">
                @context.Status
            </MudChip>
        </MudTd>
        <MudTd DataLabel="Actions">
            <MudIconButton Icon="@Icons.Material.Filled.Edit" 
                           OnClick="@(() => OnEditClick(context))" />
            <MudIconButton Icon="@Icons.Material.Filled.Delete" 
                           OnClick="@(() => OnDeleteClick(context))" />
        </MudTd>
    </RowTemplate>
</MudTable>

@code {
    [Parameter] public IEnumerable<TEntity> Entities { get; set; } = new List<TEntity>();
    [Parameter] public string Title { get; set; } = "";
    [Parameter] public bool IsLoading { get; set; }
    [Parameter] public EventCallback OnCreateClick { get; set; }
    [Parameter] public EventCallback<TEntity> OnEditClick { get; set; }
    [Parameter] public EventCallback<TEntity> OnDeleteClick { get; set; }
    [Parameter] public Func<Guid, string> GetDetailUrl { get; set; } = (id) => "";
    
    private Color GetStatusColor(EntityStatus status) => status switch
    {
        EntityStatus.Active => Color.Success,
        EntityStatus.Inactive => Color.Warning,
        EntityStatus.Archived => Color.Default,
        _ => Color.Default
    };
}
```

### Form Component Template

```razor
@typeparam TEntity where TEntity : BaseHierarchicalEntity

<EditForm Model="@Entity" OnValidSubmit="@OnSubmit">
    <DataAnnotationsValidator />
    
    <MudTextField @bind-Value="Entity.Name" 
                  Label="Name" 
                  Required="true"
                  For="@(() => Entity.Name)" />
    
    <MudTextField @bind-Value="Entity.Description" 
                  Label="Description" 
                  Lines="3"
                  For="@(() => Entity.Description)" />
    
    <MudSelect @bind-Value="Entity.Status" 
               Label="Status"
               For="@(() => Entity.Status)">
        <MudSelectItem Value="@EntityStatus.Active">Active</MudSelectItem>
        <MudSelectItem Value="@EntityStatus.Inactive">Inactive</MudSelectItem>
        <MudSelectItem Value="@EntityStatus.Archived">Archived</MudSelectItem>
    </MudSelect>
    
    <MudButton ButtonType="ButtonType.Submit" 
               Variant="Variant.Filled" 
               Color="Color.Primary">
        Save
    </MudButton>
</EditForm>

@code {
    [Parameter] public TEntity Entity { get; set; } = default!;
    [Parameter] public EventCallback<TEntity> OnSubmit { get; set; }
}
```

<details>
<summary>In Russian</summary>

Повторно используемые компоненты UI для списков и форм, параметризованные типом сущности, что позволяет использовать один компонент для всех реализаций паттерна.
</details>

---

## Permission Model

### Role-Based Permissions

```csharp
public enum Permission
{
    // Parent entity
    ViewParents,
    CreateParent,
    EditParent,
    DeleteParent,
    
    // Child entity
    ViewChildren,
    CreateChild,
    EditChild,
    DeleteChild,
    
    // Grandchild entity
    ViewGrandchildren,
    CreateGrandchild,
    EditGrandchild,
    DeleteGrandchild,
    
    // Hierarchical
    ViewFullHierarchy,
    ManageFullHierarchy
}

public class HierarchicalPermissionService
{
    public async Task<bool> CanUserAccessParentAsync(Guid userId, Guid parentId, Permission permission)
    {
        // Check user role and permissions
        var userRoles = await GetUserRolesAsync(userId);
        
        // Check if user has permission
        if (!userRoles.Any(r => r.Permissions.Contains(permission)))
            return false;
        
        // Check ownership (if applicable)
        var parent = await GetParentAsync(parentId);
        if (parent.CreatedBy == userId)
            return true;
        
        // Check team/organization access
        return await IsUserInParentOrganizationAsync(userId, parentId);
    }
}
```

### Row-Level Security (Supabase)

```sql
-- Enable RLS on all tables
ALTER TABLE {feature}_parents ENABLE ROW LEVEL SECURITY;
ALTER TABLE {feature}_children ENABLE ROW LEVEL SECURITY;
ALTER TABLE {feature}_grandchildren ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own entities
CREATE POLICY "Users can view own parents"
    ON {feature}_parents FOR SELECT
    USING (created_by = auth.uid());

-- Policy: Users can edit their own entities
CREATE POLICY "Users can update own parents"
    ON {feature}_parents FOR UPDATE
    USING (created_by = auth.uid());

-- Policy: Admins can view all
CREATE POLICY "Admins can view all parents"
    ON {feature}_parents FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM user_roles
            WHERE user_id = auth.uid()
            AND role = 'admin'
        )
    );
```

<details>
<summary>In Russian</summary>

Модель разрешений включает ролевые разрешения на уровне приложения и безопасность на уровне строк (RLS) на уровне базы данных для контроля доступа к иерархическим сущностям.
</details>

---

## Best Practices

### 1. Naming Conventions

- **Parent Entity**: Use singular noun (e.g., `Cluster`, `Metaverse`)
- **Child Entity**: Use related singular noun (e.g., `Domain`, `Section`)
- **Grandchild Entity**: Use descriptive singular noun (e.g., `Resource`, `Entity`)
- **Tables**: Use plural lowercase (e.g., `clusters`, `domains`, `resources`)
- **API Endpoints**: Use plural (e.g., `/api/clusters`, `/api/domains`)

### 2. Cascade Behavior

- **Delete Parent**: Should cascade delete all children and grandchildren
- **Archive Parent**: Should mark all children and grandchildren as archived
- **Restore Parent**: Should restore only the parent, allow manual restore of children

### 3. Performance Optimization

- **Eager Loading**: Use `.Include()` for child entities when displaying parent details
- **Pagination**: Always paginate lists, especially for large hierarchies
- **Caching**: Cache stable parent entities (e.g., frequently accessed clusters)
- **Indexes**: Create indexes on foreign keys and frequently queried fields

### 4. Validation Rules

- **Name**: Required, 1-255 characters
- **Slug**: Auto-generated from name, must be unique within parent
- **Parent Reference**: Must exist and not be deleted
- **Circular References**: Prevent self-referencing or circular hierarchies

<details>
<summary>In Russian</summary>

## Лучшие практики

Включают соглашения об именовании, поведение каскадного удаления, оптимизацию производительности и правила валидации для обеспечения согласованности и эффективности реализации паттерна.
</details>

---

## Migration from Other Patterns

If you need to migrate an existing feature to use the Three-Entity Pattern:

1. **Analyze Current Structure**: Identify parent-child relationships
2. **Create Migration Script**: Write EF Core migration or SQL script
3. **Data Migration**: Migrate existing data to new schema
4. **Update Code**: Refactor services and repositories
5. **Test**: Comprehensive testing of hierarchy operations
6. **Deploy**: Deploy with backward compatibility if needed

<details>
<summary>In Russian</summary>

## Миграция с других паттернов

Процесс миграции включает анализ текущей структуры, создание скриптов миграции, перенос данных, обновление кода, тестирование и развертывание.
</details>

---

## Conclusion

The Three-Entity Pattern provides a solid foundation for building hierarchical features in Universo Platformo. By following this specification, all features will maintain consistency, enable code reuse, and simplify maintenance.

**Next Steps**:
1. Implement pattern for Clusters feature (Phase 2)
2. Document lessons learned
3. Refine pattern based on real-world usage
4. Apply to other features (Metaverses, Uniks, etc.)

<details>
<summary>In Russian</summary>

## Заключение

Паттерн трех сущностей обеспечивает прочную основу для построения иерархических функций. Следование этой спецификации обеспечит согласованность всех функций, повторное использование кода и упрощение поддержки.
</details>

---

**Document Version**: 1.0  
**Last Updated**: November 16, 2025  
**Status**: Ready for Implementation
