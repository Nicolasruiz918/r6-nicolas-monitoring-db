UPDATE monitoring.improvement_plan
SET specific_actions = specific_actions_v2->'actions'->0->>'text'
WHERE specific_actions_v2 IS NOT NULL;
