-- FORM DATA

--SELECT 'dynamic' AS component, sqlpage.run_sql('error.sql') AS properties;


--SET id = IFNULL($id, '');
SET mc = $c->'money_colors';

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

SET form_id = 'mvts';

-- FORM

SELECT
    'form'                          AS component,
    $form_id                        AS id,
    ''                              AS validate;

SELECT
    'performed'                     AS name,
    $t->'mvt'->>'performed'         AS label,
    TRUE                            AS required,
    CASE WHEN $id
        THEN $mvt->>'performed'
        ELSE date('now', 'localtime')  
        END                         AS value,
    3                               AS width,
    'date'                          AS type;

SELECT
    'label'                         AS name,
    $t->'mvt'->>'label'             AS label,
    $mvt->>'label'                  AS value,
    TRUE                            AS required,
    5                               AS width;

SELECT
    'amount'                        AS name,
    $t->'mvt'->>'amount'            AS label,
    $mvt->>'amount'                 AS value,
    2                               AS width,
    'number'                        AS type,
    $c->>'number_step'              AS step;

SELECT 
    'select'                        AS type,
    'support_id'                    AS name,
    $t->'mvt'->>'support_id'        AS label,
    $mvt->>'support_id'             AS value,
    2                               AS width,
    json_group_array(json_object(
        'label', name,
        'value', id))               AS options
FROM supports;

-- BUTTONS FORM

SELECT 'dynamic' AS component,
    sqlpage.run_sql('buttons_form.sql') AS properties;

-- TABLE MVTS

SET actions = format(
    "[✎](?no=0&id=%s&action=update '%s') &nbsp;
     [✘](?no=0&id=%s&action=delete '%s') &nbsp;
     [✔](mvts_actions?no=0&id=%s&action=validate '%s')",
     '%s', CONCAT($t->'actions'->>'edit','…'),
     '%s', CONCAT($t->'actions'->>'delete','…'),
     '%s', $t->>'actions'->>'validate');

SELECT 
    'table' AS component,
    TRUE AS small,
    $t->>'action' AS markdown,
    $t->'mvt'->>'amount' AS align_right,
    $t->'mvt'->>'support_id' AS align_center,
    $t->>'action' AS align_center,
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
    $t->>'action', format($actions, id, id, id),
    '_sqlpage_color', IIF(amount < 0, $mc->>'debit', $mc->>'credit')
    )) AS properties
FROM mvts_supports_pending;
