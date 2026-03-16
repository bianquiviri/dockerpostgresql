#!/bin/sh
# wait-for-it.sh

set -e

host="$1"
port="$2"
shift 2
cmd="$@"

until pg_isready -h "$host" -p "$port" -U "${POSTGRES_USER:-admin}"; do
  >&2 echo "PostgreSQL no está disponible - esperando..."
  sleep 2
done

>&2 echo "PostgreSQL está disponible - ejecutando comando"
exec $cmd