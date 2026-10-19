# Guion de sustentación — 10 minutos

1. (0–1) Mostrar la tabla original y explicar el riesgo de cambiar TEXT directamente.
2. (1–3) Abrir changeset 991 y comprobar que la columna antigua permanece.
3. (3–4) Ejecutar la consulta de backfill y mostrar equivalencia exacta.
4. (4–6) Mostrar la matriz y el adaptador de compatibilidad del backend.
5. (6–8) Ejecutar precondiciones de CONTRACT y mostrar rollback aislado.
6. (8–9) Mostrar evidencias por ambiente, sin presentar pendientes como aprobados.
7. (9–10) Explicar reversibilidad, límites y comandos de reproducción.

Preguntas frecuentes: `update` es idempotente por checksum/identidad; BACKFILL no divide texto; JSONB permite evolución estructural; CONTRACT está protegido por precondición; rollback de CONTRACT depende del documento validado; el servicio antiguo no se despliega tras retirar la columna legacy.
