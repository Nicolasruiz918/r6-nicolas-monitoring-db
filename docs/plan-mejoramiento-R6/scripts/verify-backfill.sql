SELECT count(*) AS total_rows, count(specific_actions_v2) AS migrated_rows
FROM monitoring.improvement_plan;

SELECT count(*) AS mismatches
FROM monitoring.improvement_plan
WHERE specific_actions_v2 IS NULL
   OR specific_actions_v2->'actions'->0->>'text' <> specific_actions;
