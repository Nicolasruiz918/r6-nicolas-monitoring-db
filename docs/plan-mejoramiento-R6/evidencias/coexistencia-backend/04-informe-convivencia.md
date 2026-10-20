# Evidencia de convivencia de backends — Reto R6

## Objetivo

Validar la evolución de `monitoring.improvement_plan.specific_actions` desde TEXT NOT NULL hacia JSONB NOT NULL mediante la estrategia Expand–Migrate–Contract, manteniendo disponible el backend nuevo.

## Ambiente

- Base de datos aislada: `r6_coexistence_db`.
- Backend antiguo: commit base `a9c9904`, puerto 18001.
- Backend nuevo: commit `05bf633`, puerto 18002.
- PostgreSQL y Liquibase ejecutados con Docker.
- Changelogs EXPAND 991, BACKFILL 992 y CONTRACT 993.

## Desarrollo y resultados

1. Se inicializó la base con 11 changesets, antes de EXPAND.
2. El backend antiguo respondió HTTP 200 con el esquema original.
3. EXPAND 991 agregó `specific_actions_v2 JSONB` sin retirar TEXT.
4. Ambos backends respondieron HTTP 200 simultáneamente.
5. El backend antiguo creó un plan mediante POST HTTP 201.
6. Ambos backends recuperaron el mismo plan mediante GET HTTP 200.
7. El backend nuevo creó un plan mediante POST HTTP 201 y confirmó escritura dual TEXT/JSONB.
8. El backend nuevo realizó PUT HTTP 200 manteniendo ambas columnas consistentes.
9. El backend antiguo realizó PUT HTTP 200 sobre el plan nuevo y produjo una discrepancia entre TEXT y JSONB.
10. BACKFILL 992 actualizó un registro con JSONB NULL, pero no corrigió el JSONB desactualizado.
11. Se detuvo el backend antiguo; el backend nuevo continuó respondiendo HTTP 200.
12. Se ejecutó una sincronización final idempotente: UPDATE 1; pendientes 0 e inconsistentes 0.
13. Se completaron los 26 changesets del changelog principal.
14. CONTRACT 993 dejó `specific_actions JSONB NOT NULL`, conservando los dos planes existentes.
15. Después de CONTRACT, el backend nuevo completó GET 200, POST 201 y PUT 200.
16. La base conservó tres planes con tres estructuras JSONB válidas.
17. Se ejecutó `rollback-count 1`, revirtiendo CONTRACT 993.
18. Después del rollback se conservaron los tres planes y se recuperó `specific_actions TEXT NOT NULL` junto con `specific_actions_v2 JSONB NULLABLE`.
19. CONTRACT 993 dejó de aparecer en `databasechangelog`.

## Hallazgos técnicos

### Compatibilidad entre versiones

Las dos versiones coexistieron después de EXPAND, utilizando una misma base PostgreSQL.

La versión nueva mantuvo el contrato HTTP de `specific_actions` como texto y almacenó también la estructura JSONB durante la transición.

### Riesgo de datos desactualizados

El backend antiguo podía actualizar TEXT sin modificar JSONB, generando una divergencia aunque la columna JSONB no fuera NULL.

Por ello, la sincronización final debe ejecutarse después de retirar los escritores antiguos y antes de CONTRACT, comparando la estructura JSONB completa con el texto vigente.

### Corrección local de la versión histórica

El commit `a9c9904` presentó un defecto preexistente de serialización UUID:

`AttributeError: 'UUID' object has no attribute 'isoformat'`

Se aplicó un parche local exclusivamente en el worktree antiguo para convertir UUID con `str(value)`, conservando `isoformat()` para fechas.

Este ajuste no forma parte del commit histórico y no fue publicado como una modificación de la rama principal.

### Seguridad de las pruebas

La implementación consultada decodifica el contenido JWT sin verificar la firma. Para las pruebas se utilizó un token temporal exclusivamente en el ambiente Docker aislado.

Este mecanismo no constituye una validación segura para producción y requiere corrección independiente antes de desplegar públicamente el servicio.

## Alcance de la evidencia

Se comprobó continuidad funcional mediante respuestas HTTP y operaciones reales de lectura y escritura, pero no se realizaron pruebas de carga ni mediciones de disponibilidad continua.

## Resultado final

La estrategia Expand–Migrate–Contract permitió evolucionar el esquema de TEXT a JSONB sin perder los registros evaluados, mantener la compatibilidad funcional del backend nuevo y recuperar el esquema anterior mediante rollback de CONTRACT.

## Archivos complementarios

- `01-estado-final-rollback.txt`
- `02-backend-antiguo.txt`
- `03-backend-nuevo.txt`
