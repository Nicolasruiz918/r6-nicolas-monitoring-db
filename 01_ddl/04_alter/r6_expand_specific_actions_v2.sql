-- R6 EXPAND. No cambia ni bloquea el contrato legacy.
ALTER TABLE monitoring.improvement_plan ADD COLUMN specific_actions_v2 JSONB;
COMMENT ON COLUMN monitoring.improvement_plan.specific_actions_v2 IS 'R6 transitional document: {version:1, actions:[{text:string}]}';
