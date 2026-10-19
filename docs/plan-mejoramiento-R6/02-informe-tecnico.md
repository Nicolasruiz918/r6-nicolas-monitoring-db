# Informe técnico R6

## Resumen

Se implementó una evolución expand/contract para `monitoring.improvement_plan.specific_actions`, conservando el contrato del servicio FastAPI.

## Implementación

Los changesets `r6-monitoring-expand-specific-actions-v2-991` y `992` están incluidos en el flujo normal. El `993` está en `changelog/changelog-contract.yaml` y solo se ejecuta explícitamente con el contexto `r6-contract`. El backfill usa `jsonb_build_object` y solo procesa filas pendientes. CONTRACT tiene una precondición SQL que comprueba equivalencia fila a fila antes de retirar la columna antigua.

El adaptador `monitoring.adapter.outbound.persistence.specific_actions_compat` codifica/decodifica el documento y realiza escritura dual cuando la columna existe.

## Resultados

La ejecución final sí comprobó PostgreSQL, CRUD HTTP real y rollback CONTRACT en instancias locales aisladas. Las evidencias identifican explícitamente los resultados de develop; no se extrapolan a qa, staging ni main.
