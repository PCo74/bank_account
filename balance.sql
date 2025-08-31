-- YOUR TRANSLATION

SET t = sqlpage.read_file_as_text('text.json');


-- PARAMETERS

SET p = SELECT 
    json_object(
        'report', report,
        'last_statement', last_statement,
        'dec_sep', dec_sep,
        'money_format', money_format
    )
    FROM parameters;

-- BIG_NUMBER

SELECT 
    'big_number'                AS component;
    --'place-value' AS class; -- TODO

SELECT 
    $t->'balance'->>'current' AS title,
    replace(
        format($p->>'money_format', total),
        '.', $p->>'dec_sep') AS value
FROM balance_actual;

SELECT 
    $t->'balance'->>'bank' AS title,
    replace(
        format($p->>'money_format', total),
        '.', $p->>'dec_sep') AS value
FROM balance_bank;

SELECT 
    $t->'parameter'->>'last_statement' || ' ✎' AS title,
    $p->>'last_statement' AS value,
    CONCAT('form_last_statement?last_statement=', $p->>'last_statement') as title_link;
