-- SQL ACTION
/*
UPDATE parameters
SET report = report + (
    SELECT IFNULL(sum(amount), 0)
    FROM mvts
    WHERE $action = 'delete'
        AND validated IS NOT NULL 
        AND validated < $purge_date
    );

DELETE FROM mvts
WHERE $action = 'delete'
    AND validated IS NOT NULL
    AND validated < $purge_date
RETURNING 'redirect' AS component, '?purge_date=' || $purge_date AS link;
*/

-- PARAMETERS
/*
SET p = SELECT json_object(
            'report', report,
            'last_statement', last_statement,
            'dec_sep', dec_sep,
            'step', step,
            'money_format', money_format
        )
        FROM parameters;
*/

-- FORM

SET purge_date = COALESCE($purge_date, :purge_date, date('now', 'start of month', '-4 month'));

SELECT
    'form' AS component,
    --'form_purge_date' AS id,
    TRUE AS auto_submit;

SELECT
    'purge_date' AS name,
    $t->'mvts_purge'->>'date' AS label,
    TRUE AS required,
    'date'      AS type,
    $purge_date as value;

-- TABLE MVTS PURGE

select 
    'table' AS component,
        json_array(
        $t->'mvt'->>'performed',
        $t->'mvt'->>'label',
        $t->'mvt'->>'amount',
        $t->'mvt'->>'support_id',
        $t->'mvt'->>'validated') AS col_labels,
    'money' AS align_right,
    TRUE AS sort,
    TRUE AS freeze_headers,
    TRUE AS search,
    $t->>'no_data' AS empty_description,
    $t->'actions'->>'search' AS search_placeholder;
    
SELECT
    performed,
    label,
    replace(format($p->>'money_format', amount),
        '.', $p->>'dec_sep') AS money,
    name,
    M.validated,
    IIF(amount < 0, 'orange', 'green') as _sqlpage_color
FROM mvts M INNER JOIN supports S ON M.support_id = S.id
WHERE validated IS NOT NULL AND validated < $purge_date;

-- VALIDATE BUTTON

SET action_link = CONCAT(
    'mvts_actions?no=', $no,
    '&purge_date=', $purge_date,
    '&action=', 'purge');
/*SET return_link = CONCAT(
    'index?no=', $no,
    '&purge_date=', $purge_date);*/

SELECT 'dynamic' AS component,
    sqlpage.run_sql('form_buttons.sql',
        json_object(
            't', $t,
            'form_name', '',
            'action_link', $action_link,
            'action', 'delete',
            'return_link', 'index?no=0')) AS properties;