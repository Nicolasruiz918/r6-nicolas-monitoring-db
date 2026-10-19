ALTER TABLE monitoring.generated_alert
    DROP CONSTRAINT IF EXISTS ck_generated_alert_affected_actor_exclusive;

DROP TRIGGER IF EXISTS trg_kpi_tracking_prevent_delete ON monitoring.kpi_tracking;
DROP TRIGGER IF EXISTS trg_kpi_tracking_prevent_update ON monitoring.kpi_tracking;
DROP FUNCTION IF EXISTS monitoring.prevent_kpi_tracking_mutation();

DROP TABLE IF EXISTS monitoring.kpi_tracking_2026_12;
DROP TABLE IF EXISTS monitoring.kpi_tracking_2026_11;
DROP TABLE IF EXISTS monitoring.kpi_tracking_2026_10;
DROP TABLE IF EXISTS monitoring.kpi_tracking_2026_09;
