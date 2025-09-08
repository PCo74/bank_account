/**
 * displays an action button and a cancel button
 *
 * @param {json} $t : translation texts
 * @param {str} $action : requested action on database
 * @param {url} $action-link : link to perform the requested action
 * @param {str} $form_name : form name
 * @param {url} $return_link : link to interrupt the current action
 */

-- LOAD BUTTON DECORATION JSON

SET b = sqlpage.read_file_as_text('button_styles.json');

-- DISPLAY BUTTONS

select 
    'button'                    AS component,
    'form-buttons'              AS class;
select
    $t->'actions'->>$action     AS title,
    $action_link                AS link,
    $b->$action->>'color'       AS color,
    $b->$action->>'icon'        AS icon,
    $form_name                  AS form;

select
    $t->'actions'->>'cancel'    AS title, 
    $return_link                AS link,
    $b->>'cancel'->>'color'     AS color,
    $b->>'cancel'->>'icon'      AS icon,
    ($action='create')          AS disabled;
