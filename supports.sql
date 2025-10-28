-- GLOBAL DATA

-- $c : application constants as json
-- $p : parameters as json
-- $t : translation texts as json


-- MORE DATA SETUP

SET action = IIF($action IN ('create', 'update', 'delete'),
             $action, 'create');
SET form_id = 'supports';

SET record =
    SELECT json_object(
        'id', id,
        'name', name,
        'sign', sign
    )
    FROM supports
    WHERE id=$id;

SET options = 
    SELECT json_group_array(
        json_object(
            'label', value,
            'value', value  
        ) 
    )
    FROM json_each(json_array('-', '+'));

-- FORM

SELECT
    'form' AS component,
    $form_id as id,
    '' as validate;

SELECT
    'name' AS name,
    $t->>'support'->>'name' AS label,
    $record->>'name' AS value,
    TRUE AS required;

SELECT
    'sign' AS name,
    $t->>'support'->>'sign' AS label,
    $record->>'sign' AS value,
    'select' AS type,
    $options AS options;

-- BUTTONS FORM

SELECT 'dynamic' AS component,
    sqlpage.run_sql('buttons_form.sql') AS properties;

-- TABLE OF SUPPORTS

SET actions = format(
    "[✎](index?no=%s&id=%s&action=update '%s') &nbsp;
     [✘](index?no=%s&id=%s&action=delete '%s')",
     $no, '%s', CONCAT($t->'actions'->>'edit','…'),
     $no, '%s', CONCAT($t->'actions'->>'delete','…')
     );

SELECT 
    'table'             AS component,
    $t->>'action'       AS markdown,
    $t->>'action'       AS align_center,
    TRUE                AS sort,
    TRUE                AS freeze_headers,
    $p->>'search_area'       AS search,
    $t->>'no_data'      AS empty_description,
    $t->>'search' || '…' AS search_placeholder;
    
SELECT 'dynamic' AS component,
    json_group_array(json_object(
    $t->'support'->>'name', name,
    $t->'support'->>'sign', sign,
    $t->>'action', format($actions, id, id, id)
     )) AS properties
FROM supports;
