-- HU-MON-F3 (2026-08-28): seed risk_level -- fuente: data-model.md de monitoring.
-- Valores fijos: INFO (5) -> LOW (4) -> MEDIUM (3) -> HIGH (2) -> CRITICAL (1).
INSERT INTO monitoring.risk_level (id, code, label, color_hex, priority_order) VALUES
  (gen_random_uuid(),'INFO','Informativo','#3B82F6',5),
  (gen_random_uuid(),'LOW','Riesgo Bajo','#22C55E',4),
  (gen_random_uuid(),'MEDIUM','Riesgo Medio','#F59E0B',3),
  (gen_random_uuid(),'HIGH','Riesgo Alto','#F97316',2),
  (gen_random_uuid(),'CRITICAL','Riesgo Critico','#E53E3E',1)
ON CONFLICT (code) DO NOTHING;
