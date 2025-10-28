/**
  displays an action button and a cancel button
  
  * @global {json} $t : translation texts
  * @global {json} $c : constants
  * @global {int} $id : record identifier
  * @global {int} $no : navigation number
  * @global {str} $action : requested action on database

  * @parent {str} $form_id : form identifier
  * @parent {str} $more_action : additional action parameters
 */



-- DATA SETUP

-- translation texts for actions
SET ta = $t->>'actions';
-- button styles for actions
SET cbs = $c->>'button_styles';
-- action link
SET more_action = IFNULL($more_action, '');
SET action_link = CONCAT(
    $form_id, '_actions?',
    'no=', $no,
    '&id=', $id,
    '&action=', $action || $more_action);

-- RETURN THE VALIDATE & CANCEL BUTTONS

SELECT 
    'button'                        AS component,
    'sm'                            AS size,
    'form-buttons'                  AS class;

SELECT
    $ta->>$action                   AS title,
    $action_link                    AS link,
    $cbs->$action->>'color'         AS color,
    $cbs->$action->>'icon'          AS icon,
    $form_id                        AS form;

SELECT
    $ta->>'cancel'                  AS title, 
    'index?no=' || $no              AS link,
    $cbs->'cancel'->>'color'        AS color,
    $cbs->'cancel'->>'icon'         AS icon;

--SELECT 'dynamic' AS component,
  --  sqlpage.run_sql('error.sql') AS properties;