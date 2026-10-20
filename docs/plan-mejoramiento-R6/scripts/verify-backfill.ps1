param([string]$EnvFile = '.env.develop')
docker compose --env-file $EnvFile --profile tooling run --rm liquibase-monitoring update
Write-Host 'Ejecutar scripts/verify-backfill.sql con psql contra el puerto definido por el ambiente.'
