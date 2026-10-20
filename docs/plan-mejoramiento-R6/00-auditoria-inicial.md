# 00 — Auditoría inicial

**Fecha:** 2026-10-19 · **Reto:** R6 · **Repositorio:** design-software-monitoring-db

## Arquitectura encontrada

Los cinco directorios disponibles son `design-software-monitoring-db`, `design-software-monitoring-service`, `design-software-monitoring-mfe`, `design-software-docker-infra` y `design-software-web-shell`. La base usa PostgreSQL 16 y Liquibase; el backend es Python/FastAPI/SQLAlchemy; el MFE es React/TypeScript y el shell usa Module Federation.

## Dependencias reales

| Área | Archivos relevantes |
|---|---|
| Changelog | `changelog/changelog-master.yaml`, `01_ddl/04_alter/changelog.yaml` |
| Tabla | `01_ddl/03_tables/monitoring_tables.sql` |
| Migración previa de status | `01_ddl/04_alter/960_remediation.sql` |
| Backend | `src/monitoring/adapter/inbound/http/router.py`, `adapter/outbound/persistence/repo.py` |
| Frontend | `src/adapter/in/pages/AlertsPlansPage.tsx`, `contracts/generated/monitoring.ts` |
| Ambientes | `docker-infra/guia-aprendices.html`, puertos 15432–15435 |

## Candidata y riesgos

`monitoring.improvement_plan.specific_actions` es `TEXT NOT NULL`, se escribe desde `POST/PUT /api/v1/improvement-plans` y se muestra como texto en el MFE. `status` no fue seleccionada porque ya tiene la migración 960.

El riesgo principal es que una versión nueva consulte JSONB mientras una versión antigua espera texto. La mitigación es documento JSONB reversible, lectura que conserva el texto y escritura dual solo cuando la columna transitoria existe.

## Bloqueos detectados

No hay `.git` dentro de los cinco directorios, no están disponibles `.env.develop`, `.env.qa`, `.env.staging` ni `.env.main`, y no se pudo declarar una ejecución Docker real. Por seguridad, no se marcan los criterios de rollback como aprobados.
