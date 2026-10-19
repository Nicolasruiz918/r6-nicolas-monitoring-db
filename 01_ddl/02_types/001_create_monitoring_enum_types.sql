CREATE TYPE monitoring.threshold_unit_type AS ENUM (
    'PERCENTAGE',
    'COUNT',
    'DAYS',
    'HOURS'
);

CREATE TYPE monitoring.tracking_session_type AS ENUM (
    'ACADEMIC',
    'WELLNESS',
    'PROJECT',
    'PRODUCTIVE_STAGE'
);

CREATE TYPE monitoring.improvement_plan_status_type AS ENUM (
    'PENDING',
    'IN_PROGRESS',
    'COMPLETED',
    'CANCELLED'
);

CREATE TYPE monitoring.notification_channel_type AS ENUM (
    'EMAIL',
    'IN_APP'
);

CREATE TYPE monitoring.notification_send_status_type AS ENUM (
    'PENDING',
    'SENT',
    'FAILED'
);
