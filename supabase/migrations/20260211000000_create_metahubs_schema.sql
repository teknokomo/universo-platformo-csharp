CREATE SCHEMA IF NOT EXISTS metahubs;

CREATE TABLE IF NOT EXISTS metahubs."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL,
    CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId")
);

CREATE TABLE metahubs.metahubs (
    "Id" uuid NOT NULL,
    "Name" jsonb NOT NULL,
    "Description" jsonb,
    "Codename" character varying(100) NOT NULL,
    "Slug" character varying(100),
    default_branch_id uuid,
    last_branch_number integer NOT NULL,
    is_public boolean NOT NULL,
    _upl_created_at timestamp with time zone NOT NULL DEFAULT (now()),
    _upl_created_by uuid,
    _upl_updated_at timestamp with time zone NOT NULL DEFAULT (now()),
    _upl_updated_by uuid,
    _upl_version integer NOT NULL DEFAULT 1,
    _upl_archived boolean NOT NULL DEFAULT FALSE,
    _upl_archived_at timestamp with time zone,
    _upl_archived_by uuid,
    _upl_deleted boolean NOT NULL DEFAULT FALSE,
    _upl_deleted_at timestamp with time zone,
    _upl_deleted_by uuid,
    _upl_purge_after timestamp with time zone,
    _upl_locked boolean NOT NULL DEFAULT FALSE,
    _upl_locked_at timestamp with time zone,
    _upl_locked_by uuid,
    _upl_locked_reason text,
    _mhb_published boolean NOT NULL DEFAULT FALSE,
    _mhb_published_at timestamp with time zone,
    _mhb_published_by uuid,
    _mhb_archived boolean NOT NULL DEFAULT FALSE,
    _mhb_archived_at timestamp with time zone,
    _mhb_archived_by uuid,
    _mhb_deleted boolean NOT NULL DEFAULT FALSE,
    _mhb_deleted_at timestamp with time zone,
    _mhb_deleted_by uuid,
    CONSTRAINT "PK_metahubs" PRIMARY KEY ("Id")
);

CREATE TABLE metahubs.metahubs_branches (
    "Id" uuid NOT NULL,
    metahub_id uuid NOT NULL,
    source_branch_id uuid,
    "Name" jsonb NOT NULL,
    "Description" jsonb,
    "Codename" character varying(100) NOT NULL,
    branch_number integer NOT NULL,
    schema_name character varying(100) NOT NULL,
    _upl_created_at timestamp with time zone NOT NULL DEFAULT (now()),
    _upl_created_by uuid,
    _upl_updated_at timestamp with time zone NOT NULL DEFAULT (now()),
    _upl_updated_by uuid,
    _upl_version integer NOT NULL DEFAULT 1,
    _upl_archived boolean NOT NULL DEFAULT FALSE,
    _upl_archived_at timestamp with time zone,
    _upl_archived_by uuid,
    _upl_deleted boolean NOT NULL DEFAULT FALSE,
    _upl_deleted_at timestamp with time zone,
    _upl_deleted_by uuid,
    _upl_purge_after timestamp with time zone,
    _upl_locked boolean NOT NULL DEFAULT FALSE,
    _upl_locked_at timestamp with time zone,
    _upl_locked_by uuid,
    _upl_locked_reason text,
    _mhb_published boolean NOT NULL DEFAULT FALSE,
    _mhb_published_at timestamp with time zone,
    _mhb_published_by uuid,
    _mhb_archived boolean NOT NULL DEFAULT FALSE,
    _mhb_archived_at timestamp with time zone,
    _mhb_archived_by uuid,
    _mhb_deleted boolean NOT NULL DEFAULT FALSE,
    _mhb_deleted_at timestamp with time zone,
    _mhb_deleted_by uuid,
    CONSTRAINT "PK_metahubs_branches" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_metahubs_branches_metahubs_branches_source_branch_id" FOREIGN KEY (source_branch_id) REFERENCES metahubs.metahubs_branches ("Id") ON DELETE SET NULL,
    CONSTRAINT "FK_metahubs_branches_metahubs_metahub_id" FOREIGN KEY (metahub_id) REFERENCES metahubs.metahubs ("Id") ON DELETE CASCADE
);

CREATE TABLE metahubs.metahubs_users (
    "Id" uuid NOT NULL,
    metahub_id uuid NOT NULL,
    user_id uuid NOT NULL,
    active_branch_id uuid,
    "Role" character varying(50) NOT NULL DEFAULT 'owner',
    "Comment" text,
    _upl_created_at timestamp with time zone NOT NULL DEFAULT (now()),
    _upl_created_by uuid,
    _upl_updated_at timestamp with time zone NOT NULL DEFAULT (now()),
    _upl_updated_by uuid,
    _upl_version integer NOT NULL DEFAULT 1,
    _upl_archived boolean NOT NULL DEFAULT FALSE,
    _upl_archived_at timestamp with time zone,
    _upl_archived_by uuid,
    _upl_deleted boolean NOT NULL DEFAULT FALSE,
    _upl_deleted_at timestamp with time zone,
    _upl_deleted_by uuid,
    _upl_purge_after timestamp with time zone,
    _upl_locked boolean NOT NULL DEFAULT FALSE,
    _upl_locked_at timestamp with time zone,
    _upl_locked_by uuid,
    _upl_locked_reason text,
    _mhb_published boolean NOT NULL DEFAULT FALSE,
    _mhb_published_at timestamp with time zone,
    _mhb_published_by uuid,
    _mhb_archived boolean NOT NULL DEFAULT FALSE,
    _mhb_archived_at timestamp with time zone,
    _mhb_archived_by uuid,
    _mhb_deleted boolean NOT NULL DEFAULT FALSE,
    _mhb_deleted_at timestamp with time zone,
    _mhb_deleted_by uuid,
    CONSTRAINT "PK_metahubs_users" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_metahubs_users_metahubs_branches_active_branch_id" FOREIGN KEY (active_branch_id) REFERENCES metahubs.metahubs_branches ("Id") ON DELETE SET NULL,
    CONSTRAINT "FK_metahubs_users_metahubs_metahub_id" FOREIGN KEY (metahub_id) REFERENCES metahubs.metahubs ("Id") ON DELETE CASCADE
);

CREATE TABLE metahubs.publication_versions (
    "Id" uuid NOT NULL,
    publication_id uuid NOT NULL,
    branch_id uuid,
    version_number integer NOT NULL,
    "Name" jsonb NOT NULL,
    "Description" jsonb,
    snapshot_json jsonb NOT NULL,
    snapshot_hash character varying(64) NOT NULL,
    is_active boolean NOT NULL,
    _upl_created_at timestamp with time zone NOT NULL DEFAULT (now()),
    _upl_created_by uuid,
    _upl_updated_at timestamp with time zone NOT NULL DEFAULT (now()),
    _upl_updated_by uuid,
    _upl_version integer NOT NULL DEFAULT 1,
    _upl_archived boolean NOT NULL DEFAULT FALSE,
    _upl_archived_at timestamp with time zone,
    _upl_archived_by uuid,
    _upl_deleted boolean NOT NULL DEFAULT FALSE,
    _upl_deleted_at timestamp with time zone,
    _upl_deleted_by uuid,
    _upl_purge_after timestamp with time zone,
    _upl_locked boolean NOT NULL DEFAULT FALSE,
    _upl_locked_at timestamp with time zone,
    _upl_locked_by uuid,
    _upl_locked_reason text,
    _mhb_published boolean NOT NULL DEFAULT FALSE,
    _mhb_published_at timestamp with time zone,
    _mhb_published_by uuid,
    _mhb_archived boolean NOT NULL DEFAULT FALSE,
    _mhb_archived_at timestamp with time zone,
    _mhb_archived_by uuid,
    _mhb_deleted boolean NOT NULL DEFAULT FALSE,
    _mhb_deleted_at timestamp with time zone,
    _mhb_deleted_by uuid,
    CONSTRAINT "PK_publication_versions" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_publication_versions_metahubs_branches_branch_id" FOREIGN KEY (branch_id) REFERENCES metahubs.metahubs_branches ("Id") ON DELETE SET NULL
);

CREATE TABLE metahubs.publications (
    "Id" uuid NOT NULL,
    metahub_id uuid NOT NULL,
    "Name" jsonb NOT NULL,
    "Description" jsonb,
    access_mode text NOT NULL,
    access_config jsonb,
    schema_name character varying(100),
    schema_status text,
    schema_error text,
    schema_synced_at timestamp with time zone,
    schema_snapshot jsonb,
    auto_create_application boolean NOT NULL,
    active_version_id uuid,
    _upl_created_at timestamp with time zone NOT NULL DEFAULT (now()),
    _upl_created_by uuid,
    _upl_updated_at timestamp with time zone NOT NULL DEFAULT (now()),
    _upl_updated_by uuid,
    _upl_version integer NOT NULL DEFAULT 1,
    _upl_archived boolean NOT NULL DEFAULT FALSE,
    _upl_archived_at timestamp with time zone,
    _upl_archived_by uuid,
    _upl_deleted boolean NOT NULL DEFAULT FALSE,
    _upl_deleted_at timestamp with time zone,
    _upl_deleted_by uuid,
    _upl_purge_after timestamp with time zone,
    _upl_locked boolean NOT NULL DEFAULT FALSE,
    _upl_locked_at timestamp with time zone,
    _upl_locked_by uuid,
    _upl_locked_reason text,
    _mhb_published boolean NOT NULL DEFAULT FALSE,
    _mhb_published_at timestamp with time zone,
    _mhb_published_by uuid,
    _mhb_archived boolean NOT NULL DEFAULT FALSE,
    _mhb_archived_at timestamp with time zone,
    _mhb_archived_by uuid,
    _mhb_deleted boolean NOT NULL DEFAULT FALSE,
    _mhb_deleted_at timestamp with time zone,
    _mhb_deleted_by uuid,
    CONSTRAINT "PK_publications" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_publications_metahubs_metahub_id" FOREIGN KEY (metahub_id) REFERENCES metahubs.metahubs ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_publications_publication_versions_active_version_id" FOREIGN KEY (active_version_id) REFERENCES metahubs.publication_versions ("Id") ON DELETE SET NULL
);

CREATE INDEX idx_metahub_name_gin ON metahubs.metahubs USING gin ("Name");

CREATE INDEX idx_metahubs_archived ON metahubs.metahubs (_upl_archived) WHERE _upl_archived = true;

CREATE UNIQUE INDEX idx_metahubs_codename_active ON metahubs.metahubs ("Codename") WHERE _upl_deleted = false AND _mhb_deleted = false;

CREATE INDEX idx_metahubs_deleted ON metahubs.metahubs (_upl_deleted_at) WHERE _upl_deleted = true;

CREATE UNIQUE INDEX idx_metahubs_slug_active ON metahubs.metahubs ("Slug") WHERE _upl_deleted = false AND _mhb_deleted = false AND "Slug" IS NOT NULL;

CREATE INDEX "IX_metahubs_default_branch_id" ON metahubs.metahubs (default_branch_id);

CREATE INDEX idx_branch_codename ON metahubs.metahubs_branches ("Codename");

CREATE INDEX idx_branch_metahub ON metahubs.metahubs_branches (metahub_id);

CREATE INDEX idx_branch_number ON metahubs.metahubs_branches (branch_number);

CREATE INDEX idx_branch_source ON metahubs.metahubs_branches (source_branch_id);

CREATE UNIQUE INDEX idx_branches_metahub_codename_active ON metahubs.metahubs_branches (metahub_id, "Codename") WHERE _upl_deleted = false AND _mhb_deleted = false;

CREATE UNIQUE INDEX idx_branches_metahub_number_active ON metahubs.metahubs_branches (metahub_id, branch_number) WHERE _upl_deleted = false AND _mhb_deleted = false;

CREATE UNIQUE INDEX metahubs_branches_schema_name_key ON metahubs.metahubs_branches (schema_name);

CREATE UNIQUE INDEX idx_metahubs_users_active ON metahubs.metahubs_users (metahub_id, user_id) WHERE _upl_deleted = false AND _mhb_deleted = false;

CREATE INDEX idx_mu_active_branch ON metahubs.metahubs_users (active_branch_id);

CREATE INDEX idx_mu_metahub ON metahubs.metahubs_users (metahub_id);

CREATE INDEX idx_mu_user ON metahubs.metahubs_users (user_id);

CREATE INDEX idx_publication_versions_branch ON metahubs.publication_versions (branch_id);

CREATE UNIQUE INDEX idx_publication_versions_number_active ON metahubs.publication_versions (publication_id, version_number) WHERE _upl_deleted = false AND _mhb_deleted = false;

CREATE INDEX idx_publication_versions_publication ON metahubs.publication_versions (publication_id);

CREATE UNIQUE INDEX uq_active_version ON metahubs.publication_versions (publication_id, is_active) WHERE is_active = true;

CREATE INDEX idx_pub_metahub ON metahubs.publications (metahub_id);

CREATE INDEX idx_pub_name_gin ON metahubs.publications USING gin ("Name");

CREATE UNIQUE INDEX idx_pub_schema_name ON metahubs.publications (schema_name) WHERE _upl_deleted = false AND _mhb_deleted = false AND schema_name IS NOT NULL;

CREATE INDEX idx_pub_status ON metahubs.publications (schema_status);

CREATE INDEX "IX_publications_active_version_id" ON metahubs.publications (active_version_id);

ALTER TABLE metahubs.metahubs ADD CONSTRAINT "FK_metahubs_metahubs_branches_default_branch_id" FOREIGN KEY (default_branch_id) REFERENCES metahubs.metahubs_branches ("Id") ON DELETE SET NULL;

ALTER TABLE metahubs.publication_versions ADD CONSTRAINT "FK_publication_versions_publications_publication_id" FOREIGN KEY (publication_id) REFERENCES metahubs.publications ("Id") ON DELETE CASCADE;

-- Record migration in history
INSERT INTO metahubs."__EFMigrationsHistory" ("MigrationId", "ProductVersion")
VALUES ('20260211145609_InitialMetahubsSchema', '9.0.0');


