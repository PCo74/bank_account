-- YOUR TRANSLATION & MENU
/*
SET t = sqlpage.read_file_as_text('text.json');
SET mc = sqlpage.read_file_as_text('money_colors.json');

SELECT 'dynamic' AS component,
    sqlpage.run_sql('header.sql',
    json_object('t', $t, 'mc', $mc, 'i_active', 4)) AS properties;

*/
-- FORM DATA

SET p = SELECT 
    json_object(
        'report', report,
        'last_statement', last_statement,
        'dec_sep', dec_sep,
        'dec_nb', dec_nb,
        'step', step,
        'currency', currency,
        'money_format', money_format
        ) FROM parameters;

-- FORM

SELECT
    'form' AS component,
    'form_id' as id,
    '' as validate;

SELECT
    'report'                AS name,
    'report'                AS label,
    $p->>'report'           AS value,
    'number'                AS type,
    $p->>'step'             AS step;

SELECT
    'last_statement'        AS name,
    'dernier relevé'        AS label,
    $p->>'last_statement'   AS value,
    'date'                  AS type;

SELECT
    'dec_sep'               AS name,
    'séparateur décimal'    AS label,
    $p->>'dec_sep'          AS value;

SELECT
    'dec_nb'                AS name,
    'nb de décimales'       AS label,
    $p->>'dec_nb'           AS value,
    'number'                AS type;

SELECT
    'currency'              AS name,
    'devise'                AS label,
    $p->>'currency'         AS value;

-- VALIDATE BUTTON

SET action_link = CONCAT(
    'parameters_actions?no=', $no,
    '&action=update');

SELECT 'dynamic' AS component,
    sqlpage.run_sql('form_buttons.sql',
        json_object(
            't', $t,
            'form_name', 'form_id',
            'action_link', $action_link,
            'action', 'update',
            'return_link', 'index?no=4')) AS properties;
