-- MVTS PURGE

-- DATA SETUP

SET mc = $c->'money_colors';
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

select 
    'table' AS component,
    $t->'mvt'->>'money' AS align_right,
    TRUE AS sort,
    TRUE AS freeze_headers,
    $p->>'search_area' AS search,
    $t->>'no_data' AS empty_description,
    $t->>'search' || '…' AS search_placeholder;
    
SELECT 'dynamic' AS component,
    json_group_array(json_object(
    $t->'mvt'->>'performed', performed,
    $t->'mvt'->>'label', label,
    $t->'mvt'->>'amount', money,
    $t->'mvt'->>'support_id', name,
    $t->'mvt'->>'validated', validated,
    '_sqlpage_color', IIF(amount < 0, $mc->>'debit', $mc->>'credit')
    )) AS properties
FROM mvts_supports_validated
WHERE validated < $purge_date;

-- BUTTONS FORM

SELECT 'dynamic' AS component,
    sqlpage.run_sql('buttons_form.sql') AS properties;