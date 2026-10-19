ALTER TABLE monitoring.kpi_type
ADD CONSTRAINT pk_kpi_type
PRIMARY KEY (id);

ALTER TABLE monitoring.alert_type
ADD CONSTRAINT pk_alert_type
PRIMARY KEY (id);

ALTER TABLE monitoring.risk_level
ADD CONSTRAINT pk_risk_level
PRIMARY KEY (id);

ALTER TABLE monitoring.kpi_status
ADD CONSTRAINT pk_kpi_status
PRIMARY KEY (id);

ALTER TABLE monitoring.ficha_tracking
ADD CONSTRAINT pk_ficha_tracking
PRIMARY KEY (id);

ALTER TABLE monitoring.kpi_tracking
ADD CONSTRAINT pk_kpi_tracking
PRIMARY KEY (id);

ALTER TABLE monitoring.tracking_session
ADD CONSTRAINT pk_tracking_session
PRIMARY KEY (id);

ALTER TABLE monitoring.generated_alert
ADD CONSTRAINT pk_generated_alert
PRIMARY KEY (id);

ALTER TABLE monitoring.improvement_plan
ADD CONSTRAINT pk_improvement_plan
PRIMARY KEY (id);

ALTER TABLE monitoring.sent_notification
ADD CONSTRAINT pk_sent_notification
PRIMARY KEY (id);

ALTER TABLE monitoring.kpi_type
ADD CONSTRAINT uk_kpi_type_code
UNIQUE (code);

ALTER TABLE monitoring.alert_type
ADD CONSTRAINT uk_alert_type_code
UNIQUE (code);

ALTER TABLE monitoring.risk_level
ADD CONSTRAINT uk_risk_level_code
UNIQUE (code);

ALTER TABLE monitoring.kpi_status
ADD CONSTRAINT uk_kpi_status_code
UNIQUE (code);

ALTER TABLE monitoring.ficha_tracking
ADD CONSTRAINT uk_ficha_tracking_ficha_id
UNIQUE (ficha_id);

ALTER TABLE monitoring.kpi_status
ADD CONSTRAINT fk_kpi_status_risk_level
FOREIGN KEY (risk_level_id)
REFERENCES monitoring.risk_level(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE monitoring.ficha_tracking
ADD CONSTRAINT fk_ficha_tracking_overall_status
FOREIGN KEY (overall_status_id)
REFERENCES monitoring.kpi_status(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE monitoring.kpi_tracking
ADD CONSTRAINT fk_kpi_tracking_ficha_tracking
FOREIGN KEY (ficha_tracking_id)
REFERENCES monitoring.ficha_tracking(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE monitoring.kpi_tracking
ADD CONSTRAINT fk_kpi_tracking_kpi_type
FOREIGN KEY (kpi_type_id)
REFERENCES monitoring.kpi_type(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE monitoring.kpi_tracking
ADD CONSTRAINT fk_kpi_tracking_kpi_status
FOREIGN KEY (kpi_status_id)
REFERENCES monitoring.kpi_status(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE monitoring.tracking_session
ADD CONSTRAINT fk_tracking_session_ficha_tracking
FOREIGN KEY (ficha_tracking_id)
REFERENCES monitoring.ficha_tracking(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE monitoring.generated_alert
ADD CONSTRAINT fk_generated_alert_ficha_tracking
FOREIGN KEY (ficha_tracking_id)
REFERENCES monitoring.ficha_tracking(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE monitoring.generated_alert
ADD CONSTRAINT fk_generated_alert_alert_type
FOREIGN KEY (alert_type_id)
REFERENCES monitoring.alert_type(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE monitoring.generated_alert
ADD CONSTRAINT fk_generated_alert_risk_level
FOREIGN KEY (risk_level_id)
REFERENCES monitoring.risk_level(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE monitoring.improvement_plan
ADD CONSTRAINT fk_improvement_plan_ficha_tracking
FOREIGN KEY (ficha_tracking_id)
REFERENCES monitoring.ficha_tracking(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE monitoring.improvement_plan
ADD CONSTRAINT fk_improvement_plan_generated_alert
FOREIGN KEY (generated_alert_id)
REFERENCES monitoring.generated_alert(id)
ON UPDATE CASCADE
ON DELETE SET NULL;

ALTER TABLE monitoring.sent_notification
ADD CONSTRAINT fk_sent_notification_generated_alert
FOREIGN KEY (generated_alert_id)
REFERENCES monitoring.generated_alert(id)
ON UPDATE CASCADE
ON DELETE SET NULL;
