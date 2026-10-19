-- HU-MON-F3 (2026-08-28): seed alert_type -- 6 alertas pre-configuradas
-- (Circular 1-2014 SENA, Acuerdo 00003/2012) -- fuente: data-model.md de monitoring.
-- affects_ficha_status queda en su DEFAULT (false): la regla de que alertas
-- cambian el overall_status de la ficha es una decision de producto pendiente.
INSERT INTO monitoring.alert_type (id, code, name, description, default_threshold, threshold_unit) VALUES
  (gen_random_uuid(),'LOW_ATTENDANCE','Asistencia baja','Asistencia por debajo del minimo reglamentario',80.0000,'PERCENTAGE'),
  (gen_random_uuid(),'HIGH_DROPOUT_RISK','Riesgo alto de desercion','Aprendices con riesgo de desercion en la ficha',3.0000,'COUNT'),
  (gen_random_uuid(),'CURRICULUM_DELAY','Retraso curricular','Ficha con avance curricular por debajo del esperado',70.0000,'PERCENTAGE'),
  (gen_random_uuid(),'LEARNER_ABSENCE_CRITICAL','Inasistencia critica de aprendiz','Aprendiz con mas de 3 sesiones sin asistir',3.0000,'COUNT'),
  (gen_random_uuid(),'PRODUCTIVE_STAGE_DELAY','Retraso en etapa productiva','Etapa productiva sin registro de visita en mas de 30 dias',30.0000,'DAYS'),
  (gen_random_uuid(),'INSTRUCTOR_OVERLOAD','Sobrecarga de instructor','Instructor con mas horas asignadas que su limite semanal',40.0000,'HOURS')
ON CONFLICT (code) DO NOTHING;
