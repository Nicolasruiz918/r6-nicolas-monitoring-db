-- R6 BACKFILL. Idempotente: solo procesa filas pendientes.
UPDATE monitoring.improvement_plan
SET specific_actions_v2 = jsonb_build_object(
    'version', 1,
    'actions', jsonb_build_array(jsonb_build_object('text', specific_actions))
)
WHERE specific_actions_v2 IS NULL;
