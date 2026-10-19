-- Refinamiento (2026-08-13): notificacion accionable (lectura/prioridad/categoria/deep-link/evento origen).
-- Changeset NUEVO (refinamiento-monitoring-notification-970); solo ADD COLUMN + CHECK.
ALTER TABLE monitoring.sent_notification ADD COLUMN IF NOT EXISTS is_read           BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE monitoring.sent_notification ADD COLUMN IF NOT EXISTS read_at           TIMESTAMPTZ;
ALTER TABLE monitoring.sent_notification ADD COLUMN IF NOT EXISTS category          VARCHAR(30);
ALTER TABLE monitoring.sent_notification ADD COLUMN IF NOT EXISTS priority          VARCHAR(10) NOT NULL DEFAULT 'NORMAL';
ALTER TABLE monitoring.sent_notification ADD COLUMN IF NOT EXISTS deep_link         VARCHAR(500);
ALTER TABLE monitoring.sent_notification ADD COLUMN IF NOT EXISTS source_event_id   UUID;
ALTER TABLE monitoring.sent_notification ADD COLUMN IF NOT EXISTS source_event_type VARCHAR(100);
ALTER TABLE monitoring.sent_notification DROP CONSTRAINT IF EXISTS ck_sent_notification_priority;
ALTER TABLE monitoring.sent_notification ADD  CONSTRAINT ck_sent_notification_priority CHECK (priority IN ('LOW','NORMAL','HIGH'));
ALTER TABLE monitoring.sent_notification DROP CONSTRAINT IF EXISTS ck_sent_notification_category;
ALTER TABLE monitoring.sent_notification ADD  CONSTRAINT ck_sent_notification_category CHECK (category IS NULL OR category IN
  ('SCHEDULE_PUBLISHED','SCHEDULE_CHANGED','CONFLICT','INSTRUCTOR_EXCEPTION','GENERAL'));
