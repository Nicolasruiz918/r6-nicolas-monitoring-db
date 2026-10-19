-- R3 remediación (2026-08-06): 5 ENUM nativos -> VARCHAR+CHECK (ADR-004). Changeset NUEVO.
ALTER TABLE monitoring.alert_type ALTER COLUMN threshold_unit TYPE VARCHAR(20) USING threshold_unit::text;
ALTER TABLE monitoring.alert_type ADD CONSTRAINT ck_alert_type_threshold_unit CHECK (threshold_unit IN ('PERCENTAGE','COUNT','DAYS','HOURS'));
DROP TYPE IF EXISTS monitoring.threshold_unit_type;
ALTER TABLE monitoring.tracking_session ALTER COLUMN session_type TYPE VARCHAR(20) USING session_type::text;
ALTER TABLE monitoring.tracking_session ADD CONSTRAINT ck_tracking_session_session_type CHECK (session_type IN ('ACADEMIC','WELLNESS','PROJECT','PRODUCTIVE_STAGE'));
DROP TYPE IF EXISTS monitoring.tracking_session_type;
ALTER TABLE monitoring.improvement_plan ALTER COLUMN status TYPE VARCHAR(20) USING status::text;
ALTER TABLE monitoring.improvement_plan ADD CONSTRAINT ck_improvement_plan_status CHECK (status IN ('PENDING','IN_PROGRESS','COMPLETED','CANCELLED'));
DROP TYPE IF EXISTS monitoring.improvement_plan_status_type;
ALTER TABLE monitoring.sent_notification ALTER COLUMN channel TYPE VARCHAR(20) USING channel::text;
ALTER TABLE monitoring.sent_notification ADD CONSTRAINT ck_sent_notification_channel CHECK (channel IN ('EMAIL','IN_APP'));
DROP TYPE IF EXISTS monitoring.notification_channel_type;
-- send_status: el índice parcial idx_sent_notification_pending referencia el enum en su predicado; se recrea como texto.
DROP INDEX IF EXISTS monitoring.idx_sent_notification_pending;
ALTER TABLE monitoring.sent_notification ALTER COLUMN send_status TYPE VARCHAR(20) USING send_status::text;
ALTER TABLE monitoring.sent_notification ADD CONSTRAINT ck_sent_notification_send_status CHECK (send_status IN ('PENDING','SENT','FAILED'));
DROP TYPE IF EXISTS monitoring.notification_send_status_type;
