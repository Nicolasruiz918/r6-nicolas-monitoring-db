-- Rollback espejo de hu-mon-f3-drop-notification-980: recrea monitoring.sent_notification
-- tal como quedaba tras quality-fixes-monitoring-950 + remediation-monitoring-960 +
-- refinamiento-monitoring-notification-970 + refinamiento-monitoring-notification-idx-970 +
-- refinamiento-monitoring-d12-dedup-980 (estado justo antes de este DROP).
CREATE TABLE monitoring.sent_notification (
    id                 UUID          NOT NULL DEFAULT gen_random_uuid(),
    generated_alert_id UUID,
    recipient_id       UUID          NOT NULL,
    recipient_email    VARCHAR(255)  NOT NULL,
    channel            VARCHAR(20)   NOT NULL,
    subject            VARCHAR(300)  NOT NULL,
    body_summary       TEXT,
    send_status        VARCHAR(20)   NOT NULL,
    failure_reason     TEXT,
    sent_at            TIMESTAMPTZ,
    created_at         TIMESTAMPTZ   NOT NULL,
    is_read            BOOLEAN       NOT NULL DEFAULT false,
    read_at            TIMESTAMPTZ,
    category           VARCHAR(30),
    priority           VARCHAR(10)   NOT NULL DEFAULT 'NORMAL',
    deep_link          VARCHAR(500),
    source_event_id    UUID,
    source_event_type  VARCHAR(100),

    CONSTRAINT pk_sent_notification
        PRIMARY KEY (id),

    CONSTRAINT fk_sent_notification_generated_alert
        FOREIGN KEY (generated_alert_id)
        REFERENCES monitoring.generated_alert(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT ck_sent_notification_channel
        CHECK (channel IN ('EMAIL','IN_APP')),

    CONSTRAINT ck_sent_notification_send_status
        CHECK (send_status IN ('PENDING','SENT','FAILED')),

    CONSTRAINT ck_sent_notification_priority
        CHECK (priority IN ('LOW','NORMAL','HIGH')),

    CONSTRAINT ck_sent_notification_category
        CHECK (category IS NULL OR category IN
            ('SCHEDULE_PUBLISHED','SCHEDULE_CHANGED','CONFLICT','INSTRUCTOR_EXCEPTION','GENERAL'))
);

CREATE INDEX idx_sent_notification_recipient
    ON monitoring.sent_notification(recipient_id);

CREATE INDEX idx_sent_notification_pending
    ON monitoring.sent_notification(send_status)
    WHERE send_status = 'PENDING';

CREATE INDEX ix_sent_notification_generated_alert_id
    ON monitoring.sent_notification (generated_alert_id);

CREATE INDEX ix_sent_notification_recipient_unread
    ON monitoring.sent_notification (recipient_id) WHERE is_read = false;

CREATE UNIQUE INDEX uq_sent_notification_dedup
    ON monitoring.sent_notification (source_event_id, recipient_id, channel, category)
    WHERE source_event_id IS NOT NULL;
