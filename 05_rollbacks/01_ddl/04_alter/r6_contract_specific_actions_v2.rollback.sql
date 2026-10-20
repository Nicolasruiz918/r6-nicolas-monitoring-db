ALTER TABLE monitoring.improvement_plan ADD COLUMN IF NOT EXISTS specific_actions_legacy TEXT;
UPDATE monitoring.improvement_plan SET specific_actions_legacy = specific_actions->'actions'->0->>'text' WHERE specific_actions_legacy IS NULL;
ALTER TABLE monitoring.improvement_plan ALTER COLUMN specific_actions_legacy SET NOT NULL;
ALTER TABLE monitoring.improvement_plan RENAME COLUMN specific_actions TO specific_actions_v2;
ALTER TABLE monitoring.improvement_plan RENAME COLUMN specific_actions_legacy TO specific_actions;
ALTER TABLE monitoring.improvement_plan ALTER COLUMN specific_actions_v2 DROP NOT NULL;
