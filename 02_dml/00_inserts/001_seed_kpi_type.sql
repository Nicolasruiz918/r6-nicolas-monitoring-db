-- Seed kpi_type — fuente: docs/09-microservices/services/08-monitoring-service/data-model.md
-- id sin DEFAULT en el modelo -> se genera aqui con gen_random_uuid()
INSERT INTO monitoring.kpi_type (id, code, name, unit) VALUES
  (gen_random_uuid(),'ATTENDANCE','Asistencia','PERCENTAGE'),
  (gen_random_uuid(),'CURRICULUM_PROGRESS','Avance curricular','PERCENTAGE'),
  (gen_random_uuid(),'DROPOUT_RISK','Riesgo de desercion','COUNT'),
  (gen_random_uuid(),'PRODUCTIVE_STAGE_PROGRESS','Avance etapa productiva','PERCENTAGE')
ON CONFLICT (code) DO NOTHING;
