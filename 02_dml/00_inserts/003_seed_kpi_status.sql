-- HU-MON-F3 (2026-08-28): seed kpi_status -- fuente: data-model.md de monitoring.
-- Depende de risk_level (002_seed_risk_level.sql) para resolver risk_level_id por code.
INSERT INTO monitoring.kpi_status (id, code, description, risk_level_id)
SELECT gen_random_uuid(), v.code, v.description, rl.id
FROM (VALUES
  ('ON_TRACK','Ficha dentro de los parametros esperados','INFO'),
  ('AT_RISK','Ficha con indicadores por debajo del umbral, requiere atencion','MEDIUM'),
  ('CRITICAL','Ficha con indicadores criticos, requiere intervencion inmediata','CRITICAL')
) AS v(code, description, risk_level_code)
JOIN monitoring.risk_level rl ON rl.code = v.risk_level_code
ON CONFLICT (code) DO NOTHING;
