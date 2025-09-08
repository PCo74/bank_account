-- FORM DATA

--SELECT 'dynamic' AS component, sqlpage.run_sql('error.sql') AS properties;


SET id = IFNULL($id, '');

SET action = IIF($action IN ('create', 'update', 'delete'),
             $action, 'create');

SET mvt = (
    SELECT json_object(
        'performed', performed,
        'label', label,
        'amount', amount,
        'support_id', support_id
    )
    FROM mvts
    WHERE id=$id);

-- FORM

SELECT
    'form' AS component,
    'mvt' as id,
    '' as validate;

SELECT
    'performed' AS name,
    $t->'mvt'->>'performed' AS label,
    TRUE AS required,
    CASE WHEN $id
        THEN $mvt->>'performed'
        ELSE date('now', 'localtime')  
        END as value,
    3           AS width,
    'date'      AS type;

SELECT
    'label'     AS name,
    $t->'mvt'->>'label' AS label,
    $mvt->>'label' AS value,
    TRUE        AS required,
    5           AS width;
SELECT
    'amount'  AS name,
    $t->'mvt'->>'amount' AS label,
    $mvt->>'amount' AS value,
    2           AS width,
    'number'    AS type,
    $p->>'step' AS step;

SELECT 
    'select' as type,
    'support_id' AS name,
    $t->'mvt'->>'support_id' AS label,
    $mvt->>'support_id' AS value,
    2           AS width,
    json_group_array(json_object(
        'label', name,
        'value', id
    )) as options
FROM supports;

-- VALIDATE BUTTON

SET action_link = CONCAT('mvts_actions?no=', $no, '&id=', $id, '&action=', $action);

SELECT 'dynamic' AS component,
    sqlpage.run_sql('form_buttons.sql',
        json_object(
            't', $t,
            'form_name', 'mvt',
            'action_link', $action_link,
            'action', $action,
            'return_link', 'index?no=0')) AS properties;

-- TABLE MVTS

SET actions = format(
    "[✎](?no=0&id=%s&action=update '%s') &nbsp;
     [✘](?no=0&id=%s&action=delete '%s') &nbsp;
     [✔](mvts_actions?no=0&id=%s&action=validate '%s')",
     '%s', CONCAT($t->'actions'->>'edit','…'),
     '%s', CONCAT($t->'actions'->>'delete','…'),
     '%s', $t->>'actions'->>'validate');

select 
    'table' AS component,
    json_array(
        $t->'mvt'->>'performed',
        $t->'mvt'->>'label',
        $t->'mvt'->>'amount',
        $t->'mvt'->>'support_id',
        $t->>'action') AS col_labels,
    'action' AS markdown, 
    'money' AS align_right,
    'action' AS align_center,
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
    format($actions, M.id, M.id, M.id) AS action,
    IIF(amount < 0, $mc->>'debit', $mc->>'credit') AS _sqlpage_color
FROM mvts M INNER JOIN supports S ON M.support_id = S.id
WHERE validated IS NULL;
