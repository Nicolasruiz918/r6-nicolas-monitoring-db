ALTER TABLE monitoring.sent_notification
DROP CONSTRAINT IF EXISTS fk_sent_notification_generated_alert;

ALTER TABLE monitoring.improvement_plan
DROP CONSTRAINT IF EXISTS fk_improvement_plan_generated_alert;

ALTER TABLE monitoring.improvement_plan
DROP CONSTRAINT IF EXISTS fk_improvement_plan_ficha_tracking;

ALTER TABLE monitoring.generated_alert
DROP CONSTRAINT IF EXISTS fk_generated_alert_risk_level;

ALTER TABLE monitoring.generated_alert
DROP CONSTRAINT IF EXISTS fk_generated_alert_alert_type;

ALTER TABLE monitoring.generated_alert
DROP CONSTRAINT IF EXISTS fk_generated_alert_ficha_tracking;

ALTER TABLE monitoring.tracking_session
DROP CONSTRAINT IF EXISTS fk_tracking_session_ficha_tracking;

ALTER TABLE monitoring.kpi_tracking
DROP CONSTRAINT IF EXISTS fk_kpi_tracking_kpi_status;

ALTER TABLE monitoring.kpi_tracking
DROP CONSTRAINT IF EXISTS fk_kpi_tracking_kpi_type;

ALTER TABLE monitoring.kpi_tracking
DROP CONSTRAINT IF EXISTS fk_kpi_tracking_ficha_tracking;

ALTER TABLE monitoring.ficha_tracking
DROP CONSTRAINT IF EXISTS fk_ficha_tracking_overall_status;

ALTER TABLE monitoring.kpi_status
DROP CONSTRAINT IF EXISTS fk_kpi_status_risk_level;

ALTER TABLE monitoring.ficha_tracking
DROP CONSTRAINT IF EXISTS uk_ficha_tracking_ficha_id;

ALTER TABLE monitoring.kpi_status
DROP CONSTRAINT IF EXISTS uk_kpi_status_code;

ALTER TABLE monitoring.risk_level
DROP CONSTRAINT IF EXISTS uk_risk_level_code;

ALTER TABLE monitoring.alert_type
DROP CONSTRAINT IF EXISTS uk_alert_type_code;

ALTER TABLE monitoring.kpi_type
DROP CONSTRAINT IF EXISTS uk_kpi_type_code;

ALTER TABLE monitoring.sent_notification
DROP CONSTRAINT IF EXISTS pk_sent_notification;

ALTER TABLE monitoring.improvement_plan
DROP CONSTRAINT IF EXISTS pk_improvement_plan;

ALTER TABLE monitoring.generated_alert
DROP CONSTRAINT IF EXISTS pk_generated_alert;

ALTER TABLE monitoring.tracking_session
DROP CONSTRAINT IF EXISTS pk_tracking_session;

ALTER TABLE monitoring.kpi_tracking
DROP CONSTRAINT IF EXISTS pk_kpi_tracking;

ALTER TABLE monitoring.ficha_tracking
DROP CONSTRAINT IF EXISTS pk_ficha_tracking;

ALTER TABLE monitoring.kpi_status
DROP CONSTRAINT IF EXISTS pk_kpi_status;

ALTER TABLE monitoring.risk_level
DROP CONSTRAINT IF EXISTS pk_risk_level;

ALTER TABLE monitoring.alert_type
DROP CONSTRAINT IF EXISTS pk_alert_type;

ALTER TABLE monitoring.kpi_type
DROP CONSTRAINT IF EXISTS pk_kpi_type;
