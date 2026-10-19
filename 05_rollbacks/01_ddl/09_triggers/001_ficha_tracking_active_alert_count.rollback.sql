DROP TRIGGER IF EXISTS trg_generated_alert_sync_active_alert_count ON monitoring.generated_alert;
DROP FUNCTION IF EXISTS monitoring.fn_sync_ficha_tracking_active_alert_count();
