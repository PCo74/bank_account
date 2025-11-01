-- DATA SETUP

SET debit = $c->'money_colors'->>'debit';
SET credit = $c->'money_colors'->>'credit';

SET tp = $t->'parameters';
SET action = 'delete';
SET form_id = 'mvts';
SET purge_date = COALESCE(:purge_date,
    date('now', 'start of month', '-4 month'));
SET more_action = '_purge';

-- FORM

SELECT
    'form' AS component,
    $form_id AS id,
    TRUE AS auto_submit;

SELECT
    'purge_date'                    AS name,
    $t->'mvts_purge'->>'date'       AS label,
    TRUE                            AS required,
    'date'                          AS type,
    $purge_date                     AS value;

-- TABLE MVTS PURGE

SELECT 'dynamic' AS component,
    sqlpage.run_sql('top_level_table_for_mvts.sql') AS properties;

SELECT 'dynamic' AS component,
    json_group_array(json_object(
    $t->'mvt'->>'performed', performed,
    $t->'mvt'->>'label', label,
    $t->'mvt'->>'amount', money,
    $t->'mvt'->>'support_id', name,
    $t->'mvt'->>'validated', validated,
    '_sqlpage_color', IIF(amount < 0, $debit, $credit)
    )) AS properties
FROM mvts_supports_validated
WHERE validated < $purge_date;

-- BUTTONS FORM

SELECT 'dynamic' AS component,
    sqlpage.run_sql('buttons_form.sql') AS properties;