# Plan de pruebas R6

1. Ejecutar `liquibase update`; repetirlo y comprobar `Previously run`.
2. Insertar casos normal, Unicode, texto largo, múltiples frases y nulo si el esquema lo permite.
3. Ejecutar `SELECT count(*)` y comprobar equivalencia exacta.
4. Ejecutar pruebas del servicio con esquema original y expandido.
5. Ejecutar CONTRACT solo con cero pendientes.
6. Ejecutar rollback y validar columnas, conteos y valores.
7. Repetir 1–6 de forma aislada para los cuatro perfiles.

**Resultado actual (2026-10-19):** batería R6 SQL/HTTP: 5 aprobadas; Ruff aprobó los archivos R6. La suite completa tiene 24 aprobadas y 5 advertencias, utilizando el repositorio local `design-software-docs-main`.
