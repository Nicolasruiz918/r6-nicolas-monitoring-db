-- Rollback de remediation-monitoring-961 (particionada -> tabla simple, PK (id))
-- idx_kpi_tracking_history lo maneja el rollback de 10_indexes.
DROP TABLE monitoring.kpi_tracking CASCADE;
CREATE TABLE monitoring.kpi_tracking (
    id                UUID NOT NULL DEFAULT gen_random_uuid(),
    ficha_tracking_id UUID NOT NULL,
    kpi_type_id       UUID NOT NULL,
    current_value     DECIMAL(10,4) NOT NULL,
    threshold_value   DECIMAL(10,4) NOT NULL,
    kpi_status_id     UUID NOT NULL,
    period_start      DATE NOT NULL,
    period_end        DATE NOT NULL,
    measured_at       TIMESTAMPTZ NOT NULL,
    CONSTRAINT pk_kpi_tracking PRIMARY KEY (id)
);
ALTER TABLE monitoring.kpi_tracking ADD CONSTRAINT fk_kpi_tracking_ficha_tracking FOREIGN KEY (ficha_tracking_id) REFERENCES monitoring.ficha_tracking(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE monitoring.kpi_tracking ADD CONSTRAINT fk_kpi_tracking_kpi_status FOREIGN KEY (kpi_status_id) REFERENCES monitoring.kpi_status(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE monitoring.kpi_tracking ADD CONSTRAINT fk_kpi_tracking_kpi_type FOREIGN KEY (kpi_type_id) REFERENCES monitoring.kpi_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;
CREATE INDEX ix_kpi_tracking_ficha_tracking_id ON monitoring.kpi_tracking (ficha_tracking_id);
CREATE INDEX ix_kpi_tracking_kpi_status_id ON monitoring.kpi_tracking (kpi_status_id);
