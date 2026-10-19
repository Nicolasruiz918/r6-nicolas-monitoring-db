CREATE INDEX idx_ficha_tracking_overall_status
ON monitoring.ficha_tracking(overall_status_id);

CREATE INDEX idx_ficha_tracking_assigned_instructor
ON monitoring.ficha_tracking(assigned_instructor_id);

CREATE INDEX idx_kpi_tracking_history
ON monitoring.kpi_tracking(
    kpi_type_id,
    ficha_tracking_id,
    measured_at
);

CREATE INDEX idx_tracking_session_history
ON monitoring.tracking_session(
    ficha_tracking_id,
    session_date
);

CREATE INDEX idx_generated_alert_active
ON monitoring.generated_alert(
    ficha_tracking_id,
    is_resolved
);

CREATE INDEX idx_generated_alert_reports
ON monitoring.generated_alert(
    alert_type_id,
    risk_level_id,
    generated_at
);

CREATE INDEX idx_sent_notification_recipient
ON monitoring.sent_notification(recipient_id);

CREATE INDEX idx_sent_notification_pending
ON monitoring.sent_notification(send_status)
WHERE send_status = 'PENDING';
