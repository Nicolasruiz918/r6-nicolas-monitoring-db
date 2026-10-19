-- HU-MON-F3 (2026-08-28): keep ficha_tracking.active_alert_count (desnormalizado,
-- decisions.md #03) en sincronia con las filas activas de generated_alert.
-- INSERT de alerta no resuelta -> +1; alerta que pasa a resuelta -> -1;
-- alerta reabierta (resuelta -> no resuelta) -> +1; DELETE de alerta no resuelta -> -1.
CREATE OR REPLACE FUNCTION monitoring.fn_sync_ficha_tracking_active_alert_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.is_resolved = FALSE THEN
            UPDATE monitoring.ficha_tracking
               SET active_alert_count = active_alert_count + 1
             WHERE id = NEW.ficha_tracking_id;
        END IF;
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.is_resolved = FALSE AND NEW.is_resolved = TRUE THEN
            UPDATE monitoring.ficha_tracking
               SET active_alert_count = GREATEST(active_alert_count - 1, 0)
             WHERE id = NEW.ficha_tracking_id;
        ELSIF OLD.is_resolved = TRUE AND NEW.is_resolved = FALSE THEN
            UPDATE monitoring.ficha_tracking
               SET active_alert_count = active_alert_count + 1
             WHERE id = NEW.ficha_tracking_id;
        END IF;
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.is_resolved = FALSE THEN
            UPDATE monitoring.ficha_tracking
               SET active_alert_count = GREATEST(active_alert_count - 1, 0)
             WHERE id = OLD.ficha_tracking_id;
        END IF;
        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_generated_alert_sync_active_alert_count
    AFTER INSERT OR UPDATE OF is_resolved OR DELETE ON monitoring.generated_alert
    FOR EACH ROW
    EXECUTE FUNCTION monitoring.fn_sync_ficha_tracking_active_alert_count();
