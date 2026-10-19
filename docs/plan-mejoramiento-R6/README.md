# R6 — Evolución de esquema sin caída

Implementación del reto R6 para `monitoring`, usando `specific_actions_v2 JSONB` como estructura transitoria. La migración conserva el contrato HTTP `specific_actions: string` y usa la secuencia EXPAND → BACKFILL → COMPATIBILITY → CONTRACT.

## Estado verificable al 2026-10-19

- EXPAND y BACKFILL: implementados en changesets nuevos `991` y `992`, incluidos en `changelog-master.yaml`.
- CONTRACT: implementado como changeset `993` en `changelog-contract.yaml`; nunca se ejecuta durante el primer `liquibase update` normal.
- Compatibilidad del servicio: implementada con `specific_actions_compat.py` y pruebas unitarias.
- Pruebas R6 locales: **5 aprobadas** en SQL/HTTP PostgreSQL aislado; Ruff sin errores.
- Suite completa última ejecución: **24 aprobadas, 5 advertencias** con `design-software-docs-main`; no quedaron fallos.
- Ejecución Docker/Liquibase: **develop aislado aprobado**; qa, staging y main pendientes. Se usó el proyecto local `ds-r6-final` para no tocar el volumen preexistente `ds-develop`.
- No se fabricaron capturas ni resultados de comandos no ejecutados.

Ver [07-guia-reproduccion.md](07-guia-reproduccion.md) para la ejecución real.
