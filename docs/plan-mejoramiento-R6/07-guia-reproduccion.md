# Guía de reproducción en Windows PowerShell

Desde `design-software-docker-infra`, crear cuatro `.env.*` locales a partir de `.env.example`, usando bases y puertos separados. No commitear secretos.

```powershell
$envFile = '.env.develop'
docker compose --env-file $envFile up postgres -d
docker compose --env-file $envFile --profile tooling run --rm liquibase-monitoring update
docker compose --env-file $envFile --profile tooling run --rm liquibase-monitoring status --verbose
# CONTRACT es explícito: no forma parte de changelog-master.yaml
docker compose --env-file $envFile --profile tooling run --rm liquibase-monitoring-contract update --context-filter=r6-contract
pwsh ./scripts/verify-rollback.ps1 -EnvFile $envFile -Environment develop -AllowIsolatedEnvironment
```

Repetir exactamente con `.env.qa`, `.env.staging` y `.env.main`, guardando una salida independiente por ambiente en `evidencias/06-rollback/<ambiente>/`. Para una prueba real, levantar además el servicio y enviar solicitudes repetidas mientras se ejecutan EXPAND/BACKFILL.

Pruebas del servicio:

```powershell
cd ..\design-software-monitoring-service
py -3.11 -m venv .venv
\.venv\Scripts\python.exe -m pip install -e '.[dev]'
\.venv\Scripts\python.exe -m pytest -q
\.venv\Scripts\python.exe -m pytest -q tests/test_r6_postgres_integration.py
```

La prueba PostgreSQL R6 requiere `MONITORING_R6_TEST_DATABASE_URL`, `MONITORING_R6_TEST_ALLOW_SCHEMA_RESET=1` y una base local cuyo nombre contenga `r6`. La prueba HTTP requiere `MONITORING_HTTP_TEST_DATABASE_URL` y `MONITORING_HTTP_TEST_ALLOW_RESET=1`; ambas variables de permiso son obligatorias para impedir ejecuciones destructivas accidentales.
