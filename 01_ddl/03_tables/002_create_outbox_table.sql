-- HU-MON-F3 (2026-08-28): transactional outbox for monitoring domain events (ADR-005).
-- Same style as identity.outbox (design-software-iam-db). alert-worker inserts
-- monitoring.alert.triggered here in the same tx as generated_alert; a relay
-- publishes pending rows and stamps published_at after the broker ack.
CREATE TABLE monitoring.outbox (
    id            UUID          NOT NULL DEFAULT gen_random_uuid(),
    event_id      UUID          NOT NULL DEFAULT gen_random_uuid(),
    event_type    VARCHAR(150)  NOT NULL,
    payload       JSONB         NOT NULL,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT now(),
    published_at  TIMESTAMPTZ,

    CONSTRAINT pk_outbox
        PRIMARY KEY (id),

    CONSTRAINT uq_outbox_event_id
        UNIQUE (event_id)
);

COMMENT ON TABLE monitoring.outbox IS 'Transactional outbox: monitoring domain events (e.g. monitoring.alert.triggered) written in the same tx as the business state change; a relay publishes unpublished rows to the broker (at-least-once). See data-model.md.';
