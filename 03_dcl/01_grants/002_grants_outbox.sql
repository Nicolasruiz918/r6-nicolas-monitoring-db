-- HU-MON-F3 (2026-08-28): least-privilege grants for monitoring.outbox (additive, targeted).
-- Targeted (not "ON ALL TABLES") so it also applies on incremental runs, where the
-- base grants changeset (dcl-grants-monitoring-001) already ran and will not re-run.
GRANT SELECT                         ON monitoring.outbox TO monitoring_reader;
GRANT SELECT, INSERT, UPDATE, DELETE ON monitoring.outbox TO monitoring_writer;
GRANT ALL PRIVILEGES                 ON monitoring.outbox TO monitoring_admin;
