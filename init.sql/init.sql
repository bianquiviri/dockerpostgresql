-- init.sql
-- Este script se ejecuta después de que Docker crea la DB y el usuario base

-- Habilitar extensiones útiles
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_prewarm;
CREATE EXTENSION IF NOT EXISTS pg_buffercache;

-- Configurar permisos adicionales si fuera necesario
-- (Docker ya asigna al usuario de la env como owner de la DB)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;\n-- Crear el usuario administrador solicitado\nCREATE USER bianquiviri WITH PASSWORD '!N1k00905' SUPERUSER;
