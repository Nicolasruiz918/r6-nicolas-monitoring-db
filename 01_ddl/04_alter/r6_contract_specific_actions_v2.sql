-- R6 CONTRACT. La precondición ya demostró equivalencia exacta.
ALTER TABLE monitoring.improvement_plan DROP COLUMN specific_actions;
ALTER TABLE monitoring.improvement_plan RENAME COLUMN specific_actions_v2 TO specific_actions;
ALTER TABLE monitoring.improvement_plan ALTER COLUMN specific_actions SET NOT NULL;
