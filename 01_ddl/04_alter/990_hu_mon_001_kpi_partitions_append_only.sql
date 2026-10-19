-- HU-MON-001: monthly partitions and append-only guard for monitoring.kpi_tracking.
CREATE TABLE IF NOT EXISTS monitoring.kpi_tracking_2026_09
    PARTITION OF monitoring.kpi_tracking
    FOR VALUES FROM ('2026-09-01') TO ('2026-10-01');

CREATE TABLE IF NOT EXISTS monitoring.kpi_tracking_2026_10
    PARTITION OF monitoring.kpi_tracking
    FOR VALUES FROM ('2026-10-01') TO ('2026-11-01');

CREATE TABLE IF NOT EXISTS monitoring.kpi_tracking_2026_11
    PARTITION OF monitoring.kpi_tracking
    FOR VALUES FROM ('2026-11-01') TO ('2026-12-01');

CREATE TABLE IF NOT EXISTS monitoring.kpi_tracking_2026_12
    PARTITION OF monitoring.kpi_tracking
    FOR VALUES FROM ('2026-12-01') TO ('2027-01-01');

CREATE OR REPLACE FUNCTION monitoring.prevent_kpi_tracking_mutation()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE EXCEPTION 'monitoring.kpi_tracking is append-only; % is not allowed', TG_OP
        USING ERRCODE = 'check_violation';
END;
$$;

DROP TRIGGER IF EXISTS trg_kpi_tracking_prevent_update ON monitoring.kpi_tracking;
CREATE TRIGGER trg_kpi_tracking_prevent_update
    BEFORE UPDATE ON monitoring.kpi_tracking
    FOR EACH ROW
    EXECUTE FUNCTION monitoring.prevent_kpi_tracking_mutation();

DROP TRIGGER IF EXISTS trg_kpi_tracking_prevent_delete ON monitoring.kpi_tracking;
CREATE TRIGGER trg_kpi_tracking_prevent_delete
    BEFORE DELETE ON monitoring.kpi_tracking
    FOR EACH ROW
    EXECUTE FUNCTION monitoring.prevent_kpi_tracking_mutation();

ALTER TABLE monitoring.generated_alert
    DROP CONSTRAINT IF EXISTS ck_generated_alert_affected_actor_exclusive;

ALTER TABLE monitoring.generated_alert
    ADD CONSTRAINT ck_generated_alert_affected_actor_exclusive
    CHECK (affected_learner_id IS NULL OR affected_instructor_id IS NULL);
