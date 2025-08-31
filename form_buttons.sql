-- VALIDATE BUTTON 
-- $t, $action, $action-link, $form_name, $return_link

SET b = sqlpage.read_file_as_text('button_styles.json');

select 
    'button' as component,
    'form-buttons' AS class;
select 
    $action_link as link,
    $form_name              AS form,
    $b->$action->>'color'   AS color,
    $b->$action->>'icon'    AS icon,
    $t->'actions'->>$action AS title;
select 
    $return_link            AS link,
    --$form_name              AS form,
    $b->>'cancel'->>'color' AS color,
    $b->>'cancel'->>'icon'  AS icon,
    ($action='create')      AS disabled,
    $t->'actions'->>'cancel' AS title;        
