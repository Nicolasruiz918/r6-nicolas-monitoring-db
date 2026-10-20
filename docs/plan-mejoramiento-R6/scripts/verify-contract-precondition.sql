-- Negative, isolated PostgreSQL test for CONTRACT 993's safe precondition.
-- It uses only a temporary table and never changes monitoring data.
CREATE TEMP TABLE r6_contract_precondition_cases (
    case_name text PRIMARY KEY,
    specific_actions text,
    specific_actions_v2 jsonb
);

INSERT INTO r6_contract_precondition_cases(case_name, specific_actions, specific_actions_v2)
VALUES
    ('valid', 'Acción válida', '{"version":1,"actions":[{"text":"Acción válida"}]}'::jsonb),
    ('null_document', 'Texto original', NULL),
    ('not_object', 'Texto original', '[]'::jsonb),
    ('wrong_version', 'Texto original', '{"version":2,"actions":[{"text":"Texto original"}]}'::jsonb),
    ('actions_not_array', 'Texto original', '{"version":1,"actions":{}}'::jsonb),
    ('actions_empty', 'Texto original', '{"version":1,"actions":[]}'::jsonb),
    ('actions_multiple', 'Texto original', '{"version":1,"actions":[{"text":"Texto original"},{"text":"extra"}]}'::jsonb),
    ('element_not_object', 'Texto original', '{"version":1,"actions":["Texto original"]}'::jsonb),
    ('text_not_string', 'Texto original', '{"version":1,"actions":[{"text":7}]}'::jsonb),
    ('divergent_text', 'Texto original', '{"version":1,"actions":[{"text":"Texto diferente"}]}'::jsonb);

DO $$
DECLARE
    invalid_cases integer;
BEGIN
    SELECT count(*) INTO invalid_cases
    FROM r6_contract_precondition_cases
    WHERE CASE
        WHEN specific_actions_v2 IS NULL THEN 1
        WHEN jsonb_typeof(specific_actions_v2) <> 'object' THEN 1
        WHEN specific_actions_v2->'version' IS DISTINCT FROM to_jsonb(1) THEN 1
        WHEN jsonb_typeof(specific_actions_v2->'actions') <> 'array' THEN 1
        WHEN jsonb_array_length(specific_actions_v2->'actions') <> 1 THEN 1
        WHEN jsonb_typeof(specific_actions_v2->'actions'->0) <> 'object' THEN 1
        WHEN jsonb_typeof(specific_actions_v2->'actions'->0->'text') <> 'string' THEN 1
        WHEN (specific_actions_v2->'actions'->0->>'text') IS DISTINCT FROM specific_actions THEN 1
        ELSE 0
    END = 1;

    IF invalid_cases <> 9 THEN
        RAISE EXCEPTION 'Expected 9 invalid CONTRACT cases, got %', invalid_cases;
    END IF;
END $$;

DROP TABLE r6_contract_precondition_cases;
