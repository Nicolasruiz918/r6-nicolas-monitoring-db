-- Rollback de remediation-monitoring-960 (VARCHAR+CHECK -> ENUM)
CREATE TYPE monitoring.threshold_unit_type AS ENUM ('PERCENTAGE','COUNT','DAYS','HOURS');
ALTER TABLE monitoring.alert_type DROP CONSTRAINT IF EXISTS ck_alert_type_threshold_unit;
ALTER TABLE monitoring.alert_type ALTER COLUMN threshold_unit TYPE monitoring.threshold_unit_type USING threshold_unit::monitoring.threshold_unit_type;
CREATE TYPE monitoring.tracking_session_type AS ENUM ('ACADEMIC','WELLNESS','PROJECT','PRODUCTIVE_STAGE');
ALTER TABLE monitoring.tracking_session DROP CONSTRAINT IF EXISTS ck_tracking_session_session_type;
ALTER TABLE monitoring.tracking_session ALTER COLUMN session_type TYPE monitoring.tracking_session_type USING session_type::monitoring.tracking_session_type;
CREATE TYPE monitoring.improvement_plan_status_type AS ENUM ('PENDING','IN_PROGRESS','COMPLETED','CANCELLED');
ALTER TABLE monitoring.improvement_plan DROP CONSTRAINT IF EXISTS ck_improvement_plan_status;
ALTER TABLE monitoring.improvement_plan ALTER COLUMN status TYPE monitoring.improvement_plan_status_type USING status::monitoring.improvement_plan_status_type;
CREATE TYPE monitoring.notification_channel_type AS ENUM ('EMAIL','IN_APP');
ALTER TABLE monitoring.sent_notification DROP CONSTRAINT IF EXISTS ck_sent_notification_channel;
ALTER TABLE monitoring.sent_notification ALTER COLUMN channel TYPE monitoring.notification_channel_type USING channel::monitoring.notification_channel_type;
CREATE TYPE monitoring.notification_send_status_type AS ENUM ('PENDING','SENT','FAILED');
DROP INDEX IF EXISTS monitoring.idx_sent_notification_pending;
ALTER TABLE monitoring.sent_notification DROP CONSTRAINT IF EXISTS ck_sent_notification_send_status;
ALTER TABLE monitoring.sent_notification ALTER COLUMN send_status TYPE monitoring.notification_send_status_type USING send_status::monitoring.notification_send_status_type;
CREATE INDEX idx_sent_notification_pending ON monitoring.sent_notification (send_status) WHERE (send_status = 'PENDING'::monitoring.notification_send_status_type);
