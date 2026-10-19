-- HU-MON-F3 (2026-08-28): partial index for the relay to scan pending monitoring.outbox rows.
CREATE INDEX IF NOT EXISTS ix_outbox_unpublished
    ON monitoring.outbox (published_at, created_at)
    WHERE published_at IS NULL;
