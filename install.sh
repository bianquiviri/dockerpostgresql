#!/bin/bash

# --- Colores para salida ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Iniciando instalador de PostgreSQL Optimized para Linux...${NC}"

# 1. Crear directorios
mkdir -p init.sql

# 3. Crear archivo .env
cat <<EOF > .env
POSTGRES_DB=largedb
POSTGRES_USER=admin
POSTGRES_PASSWORD=!N1k00905
POSTGRES_PORT=5432
EOF

# 4. Crear archivo postgresql.conf
cat <<EOF > postgresql.conf
# CONFIGURACIÓN OPTIMIZADA POR ANTIGRAVITY
listen_addresses = '*'

# --- Memory & Performance ---
shared_buffers = 1GB
effective_cache_size = 3GB
work_mem = 32MB
maintenance_work_mem = 256MB
huge_pages = off

# --- Parallelism ---
max_worker_processes = 8
max_parallel_workers_per_gather = 4
max_parallel_workers = 8
max_parallel_maintenance_workers = 4

# --- Disk & I/O ---
effective_io_concurrency = 200
random_page_cost = 1.1
min_wal_size = 1GB
max_wal_size = 4GB

# --- Connections & Security ---
max_connections = 100
shared_preload_libraries = 'pg_stat_statements'
EOF

# 5. Crear archivo init.sql
cat <<EOF > init.sql/init.sql
-- Habilitar extensiones
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Crear el usuario administrador solicitado
CREATE USER bianquiviri WITH PASSWORD '!N1k00905' SUPERUSER;
EOF

# 6. Crear archivo docker-compose.yml
cat <<EOF > docker-compose.yml
services:
  postgres:
    image: postgres:15-alpine
    container_name: postgres_optimized
    environment:
      POSTGRES_DB: \${POSTGRES_DB}
      POSTGRES_USER: \${POSTGRES_USER}
      POSTGRES_PASSWORD: \${POSTGRES_PASSWORD}
    ports:
      - "\${POSTGRES_PORT}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./postgresql.conf:/etc/postgresql/postgresql.conf:ro
      - ./init.sql:/docker-entrypoint-initdb.d:ro
    command: >
      postgres -c config_file=/etc/postgresql/postgresql.conf
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U \${POSTGRES_USER} -d \${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
EOF

# 7. Levantar el servicio
echo -e "${GREEN}Levantando contenedores...${NC}"
docker compose up -d

echo -e "${GREEN}¡Instalación completada!${NC}"
echo "PostgreSQL está escuchando en el puerto 5432."
echo "Usuario administrador: bianquiviri"
