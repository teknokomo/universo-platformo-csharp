-- Register EF Core migration history records in public.__EFMigrationsHistory.
-- The actual schema changes were applied manually via Supabase CLI/Studio.
-- These INSERTs let EF Core know the migrations are already applied so it won't
-- try to re-run them on the next `dotnet ef database update`.

-- Record the initial schema migration (applied via 20260211000000_create_metahubs_schema.sql)
INSERT INTO public."__EFMigrationsHistory" ("MigrationId", "ProductVersion")
SELECT '20260211145609_InitialMetahubsSchema', '9.0.0'
WHERE NOT EXISTS (
    SELECT 1 FROM public."__EFMigrationsHistory"
    WHERE "MigrationId" = '20260211145609_InitialMetahubsSchema'
);

-- Record the schema-to-public migration (applied via 20260217000000_move_to_public_schema.sql)
INSERT INTO public."__EFMigrationsHistory" ("MigrationId", "ProductVersion")
SELECT '20260220105741_SchemaToPublic', '9.0.0'
WHERE NOT EXISTS (
    SELECT 1 FROM public."__EFMigrationsHistory"
    WHERE "MigrationId" = '20260220105741_SchemaToPublic'
);
