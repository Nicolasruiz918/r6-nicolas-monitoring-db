param([string]$EnvFile = '.env.develop')
docker compose --env-file $EnvFile --profile tooling run --rm liquibase-monitoring status --verbose
