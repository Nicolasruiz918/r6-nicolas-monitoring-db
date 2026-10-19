-- R3 (2026-08-06): kpi_tracking -> tabla PARTICIONADA por RANGE mensual de measured_at.
-- Changeset NUEVO (remediation-monitoring-961). Tabla vacía; nada la referencia por FK; sin vistas dependientes.
-- La PK pasa a (id, measured_at): Postgres exige que la clave de partición esté en la PK.
-- NOTA: idx_kpi_tracking_history lo crea 10_indexes (posterior); aquí solo se recrean las ix_ de FK (vienen de 950).
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
    CONSTRAINT pk_kpi_tracking PRIMARY KEY (id, measured_at)
) PARTITION BY RANGE (measured_at);
CREATE TABLE monitoring.kpi_tracking_default PARTITION OF monitoring.kpi_tracking DEFAULT;
CREATE TABLE monitoring.kpi_tracking_2026_08 PARTITION OF monitoring.kpi_tracking FOR VALUES FROM ('2026-08-01') TO ('2026-09-01');
ALTER TABLE monitoring.kpi_tracking ADD CONSTRAINT fk_kpi_tracking_ficha_tracking FOREIGN KEY (ficha_tracking_id) REFERENCES monitoring.ficha_tracking(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE monitoring.kpi_tracking ADD CONSTRAINT fk_kpi_tracking_kpi_status FOREIGN KEY (kpi_status_id) REFERENCES monitoring.kpi_status(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE monitoring.kpi_tracking ADD CONSTRAINT fk_kpi_tracking_kpi_type FOREIGN KEY (kpi_type_id) REFERENCES monitoring.kpi_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;
CREATE INDEX ix_kpi_tracking_ficha_tracking_id ON monitoring.kpi_tracking (ficha_tracking_id);
CREATE INDEX ix_kpi_tracking_kpi_status_id ON monitoring.kpi_tracking (kpi_status_id);
