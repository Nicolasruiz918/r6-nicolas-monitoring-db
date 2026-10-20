# Trazabilidad R6

| Criterio | Implementación | Evidencia | Estado |
|---|---|---|---|
| R6.a | Changesets 991/992 en flujo normal y 993 en changelog-contract | Liquibase develop ejecutado | Aprobado en develop aislado |
| R6.b | Changeset 992 idempotente | Prueba PostgreSQL R6 aprobada | Aprobado en prueba aislada |
| R6.c | Adaptador FastAPI compatible, TEXT/JSONB y doble escritura | `2026-10-19-r6-http-postgres.txt`, `2026-10-19-r6-tests-final.txt` | Aprobado en PostgreSQL HTTP aislado |
| R6.d | Rollback controlado por changeset, estructura y datos | `evidencias/06-rollback/develop/00-validated-changeset.txt`, `04-after-structure-data.txt` | Parcial: develop aprobado; qa/staging/main pendientes |
