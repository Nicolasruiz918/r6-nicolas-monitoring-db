# Resultados BACKFILL

**Estado:** implementado, ejecución pendiente.

La transformación es idempotente (`WHERE specific_actions_v2 IS NULL`) y conserva el valor exacto como `actions[0].text`. Las consultas de validación están en `scripts/verify-backfill.sql`.
