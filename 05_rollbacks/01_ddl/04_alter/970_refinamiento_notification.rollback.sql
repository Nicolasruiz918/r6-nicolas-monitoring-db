-- Rollback espejo de refinamiento-monitoring-notification-970.
ALTER TABLE monitoring.sent_notification DROP CONSTRAINT IF EXISTS ck_sent_notification_category;
ALTER TABLE monitoring.sent_notification DROP CONSTRAINT IF EXISTS ck_sent_notification_priority;
ALTER TABLE monitoring.sent_notification DROP COLUMN IF EXISTS source_event_type;
ALTER TABLE monitoring.sent_notification DROP COLUMN IF EXISTS source_event_id;
ALTER TABLE monitoring.sent_notification DROP COLUMN IF EXISTS deep_link;
ALTER TABLE monitoring.sent_notification DROP COLUMN IF EXISTS priority;
ALTER TABLE monitoring.sent_notification DROP COLUMN IF EXISTS category;
ALTER TABLE monitoring.sent_notification DROP COLUMN IF EXISTS read_at;
ALTER TABLE monitoring.sent_notification DROP COLUMN IF EXISTS is_read;
