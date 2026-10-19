-- Quality fixes (v2.0.0): id DEFAULT gen_random_uuid() e indices de FK faltantes
ALTER TABLE monitoring.alert_type ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE monitoring.ficha_tracking ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE monitoring.generated_alert ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE monitoring.improvement_plan ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE monitoring.kpi_status ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE monitoring.kpi_tracking ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE monitoring.kpi_type ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE monitoring.risk_level ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE monitoring.sent_notification ALTER COLUMN id SET DEFAULT gen_random_uuid();
ALTER TABLE monitoring.tracking_session ALTER COLUMN id SET DEFAULT gen_random_uuid();
CREATE INDEX IF NOT EXISTS ix_generated_alert_risk_level_id ON monitoring.generated_alert (risk_level_id);
CREATE INDEX IF NOT EXISTS ix_improvement_plan_ficha_tracking_id ON monitoring.improvement_plan (ficha_tracking_id);
CREATE INDEX IF NOT EXISTS ix_improvement_plan_generated_alert_id ON monitoring.improvement_plan (generated_alert_id);
CREATE INDEX IF NOT EXISTS ix_kpi_status_risk_level_id ON monitoring.kpi_status (risk_level_id);
CREATE INDEX IF NOT EXISTS ix_kpi_tracking_ficha_tracking_id ON monitoring.kpi_tracking (ficha_tracking_id);
CREATE INDEX IF NOT EXISTS ix_kpi_tracking_kpi_status_id ON monitoring.kpi_tracking (kpi_status_id);
CREATE INDEX IF NOT EXISTS ix_sent_notification_generated_alert_id ON monitoring.sent_notification (generated_alert_id);
