-- Refinamiento (2026-08-13): indice parcial de no-leidas por destinatario. Va en 10_indexes (tras 04_alter).
CREATE INDEX IF NOT EXISTS ix_sent_notification_recipient_unread
  ON monitoring.sent_notification (recipient_id) WHERE is_read = false;
