SELECT column_name, data_type, udt_name, is_nullable
FROM information_schema.columns
WHERE table_schema = 'monitoring' AND table_name = 'improvement_plan'
ORDER BY ordinal_position;

SELECT count(*) AS total_rows, count(specific_actions) AS non_null_actions
FROM monitoring.improvement_plan;
