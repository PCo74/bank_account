-- YOUR TRANSLATION & HEADER

SET t = sqlpage.read_file_as_text('text.json');

SELECT 'dynamic' AS component,
    sqlpage.run_sql('header.sql',
    json_object('t', $t, 'i_active', 3)) AS properties;

-- FORM DATA

SET id = IIF($id, $id, ''); -- id == '' for new insert

SET action = IIF($action IN ('create', 'update', 'delete'), $action, 'create');

SET record = (
    SELECT 
    json_object(
        'id', id,
        'name', name
        )
    FROM supports
    WHERE id=$id);

-- FORM

SELECT
    'form' AS component,
    'support' as id,
    '' as validate;

SELECT
    'name' AS name,
    $t->>'support'->>'name' AS label,
    $record->>'name' AS value,
    TRUE AS required;

-- ACTION BUTTONS

SET action_link = CONCAT('supports_actions?id=', $id, '&action=', $action);

SELECT 'dynamic' AS component,
    sqlpage.run_sql('form_buttons.sql',
        json_object(
            't', $t,
            'form_name', 'support',
            'action_link', $action_link,
            'action', $action,
            'return_link', 'supports')) AS properties;

-- TABLE

SET actions = format(
    "[✎](?id=%s&action=update '%s') &nbsp;
     [✘](?id=%s&action=delete '%s')",
     '%s', CONCAT($t->>'edit','…'),
     '%s', CONCAT($t->>'delete','…')
     );

SELECT 
    'table'             AS component,
    json_array(
        $t->'support'->>'name',
        $t->'action')   AS col_labels,
    'action'            AS markdown,
    'action'            AS align_center,
    TRUE                AS sort,
    TRUE                AS freeze_headers,
    TRUE                AS search,
    $t->>'no_data'      AS empty_description,
    $t->>'search'       AS search_placeholder;
    
SELECT
    name,
    format($actions, id, id, id) AS action
FROM supports;
