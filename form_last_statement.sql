/** 
  Update the last statement date parameter
  
  * @global {json} $p : parameters table
  * @global {json} $t : translation texts
*/

-- DATA SETUP

SET tp = $t->'parameters';
SET form_id = 'parameters';
SET id = 1;
SET action = 'update';
SET more_action = '_last_statement';

-- FORM LAST STATEMENT

SELECT
    'form'                  AS component,
    $form_id                AS id,
    ''                      AS validate;

SELECT
    'last_statement'        AS name,
    $tp->>'last_statement'  AS label,
    $p->>'last_statement'   AS value,
    'date'                  AS type;

-- BUTTONS FORM

SELECT 'dynamic' AS component,
    sqlpage.run_sql('buttons_form.sql') AS properties;
