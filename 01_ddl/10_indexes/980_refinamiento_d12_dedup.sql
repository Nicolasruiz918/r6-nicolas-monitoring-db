-- D-12 (2026-08-13): deduplicacion de notificaciones por evento+destinatario+canal+categoria.
-- Indice unico PARCIAL: solo aplica a notificaciones nacidas de un evento (source_event_id NOT NULL);
-- las de alerta (source_event_id NULL) no se restringen. Evita 2 avisos por el mismo evento.
CREATE UNIQUE INDEX IF NOT EXISTS uq_sent_notification_dedup
  ON monitoring.sent_notification (source_event_id, recipient_id, channel, category)
  WHERE source_event_id IS NOT NULL;
