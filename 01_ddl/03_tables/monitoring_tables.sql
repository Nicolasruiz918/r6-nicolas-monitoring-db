CREATE TABLE monitoring.kpi_type (
    id UUID,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    unit VARCHAR(20) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE monitoring.alert_type (
    id UUID,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    default_threshold DECIMAL(10,4),
    threshold_unit monitoring.threshold_unit_type,
    affects_ficha_status BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE monitoring.risk_level (
    id UUID,
    code VARCHAR(20) NOT NULL,
    label VARCHAR(60) NOT NULL,
    color_hex VARCHAR(7) NOT NULL,
    priority_order SMALLINT NOT NULL
);

CREATE TABLE monitoring.kpi_status (
    id UUID,
    code VARCHAR(20) NOT NULL,
    description TEXT,
    risk_level_id UUID NOT NULL
);

CREATE TABLE monitoring.ficha_tracking (
    id UUID,
    ficha_id UUID NOT NULL,
    assigned_instructor_id UUID NOT NULL,
    overall_status_id UUID NOT NULL,
    active_alert_count INT NOT NULL DEFAULT 0,
    last_tracking_date DATE,
    next_tracking_date DATE,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE monitoring.kpi_tracking (
    id UUID,
    ficha_tracking_id UUID NOT NULL,
    kpi_type_id UUID NOT NULL,
    current_value DECIMAL(10,4) NOT NULL,
    threshold_value DECIMAL(10,4) NOT NULL,
    kpi_status_id UUID NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    measured_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE monitoring.tracking_session (
    id UUID,
    ficha_tracking_id UUID NOT NULL,
    instructor_id UUID NOT NULL,
    session_date DATE NOT NULL,
    session_type monitoring.tracking_session_type NOT NULL,
    attendance_count INT,
    total_learners INT,
    attendance_percentage DECIMAL(5,2)
        GENERATED ALWAYS AS (
            CASE
                WHEN total_learners > 0
                THEN ROUND(CAST(attendance_count AS DECIMAL(10,4)) / total_learners * 100, 2)
                ELSE NULL
            END
        ) STORED,
    curriculum_progress_percentage DECIMAL(5,2),
    observations TEXT,
    requires_follow_up BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE monitoring.generated_alert (
    id UUID,
    ficha_tracking_id UUID NOT NULL,
    alert_type_id UUID NOT NULL,
    risk_level_id UUID NOT NULL,
    source_event_id UUID NOT NULL,
    affected_learner_id UUID,
    affected_instructor_id UUID,
    triggered_value DECIMAL(10,4),
    threshold_value DECIMAL(10,4),
    description TEXT NOT NULL,
    is_resolved BOOLEAN NOT NULL DEFAULT FALSE,
    resolved_by UUID,
    resolution_notes TEXT,
    generated_at TIMESTAMPTZ NOT NULL,
    resolved_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ NOT NULL,
    CHECK (
        affected_learner_id IS NULL
        OR affected_instructor_id IS NULL
    )
);

CREATE TABLE monitoring.improvement_plan (
    id UUID,
    ficha_tracking_id UUID NOT NULL,
    generated_alert_id UUID,
    learner_id UUID,
    instructor_id UUID,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    specific_actions TEXT NOT NULL,
    due_date DATE NOT NULL,
    status monitoring.improvement_plan_status_type NOT NULL,
    completion_notes TEXT,
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE monitoring.sent_notification (
    id UUID,
    generated_alert_id UUID,
    recipient_id UUID NOT NULL,
    recipient_email VARCHAR(255) NOT NULL,
    channel monitoring.notification_channel_type NOT NULL,
    subject VARCHAR(300) NOT NULL,
    body_summary TEXT,
    send_status monitoring.notification_send_status_type NOT NULL,
    failure_reason TEXT,
    sent_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL
);
