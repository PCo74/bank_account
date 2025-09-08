SELECT
    'form'                  AS component,
    'last_statement_id'     AS id,
    ''                      AS validate;

SET label = $t->'parameter'->>'last_statement';
SELECT
    'last_statement'        AS name,
    $label                  AS label,
    $p->>'last_statement'   AS value,
    'date'                  AS type;

-- FORM BUTTONS

SET action_link = CONCAT(
    'parameters_actions?no=', $no,
    '&action=', 'update_last_statement');

SELECT 'dynamic' AS component,
    sqlpage.run_sql('form_buttons.sql',
        json_object(
            't', $t,
            'form_name', 'last_statement_id',
            'action_link', $action_link,
            'action', 'update',
            'return_link', 'index?no=0')) AS properties;

/*
select 
    'alert'     as component,
    'Attention' as title,
    $p->>'last_statement' as description;*/
