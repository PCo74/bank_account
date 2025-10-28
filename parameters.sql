-- global $p : parameters as json
-- global $t : translation texts as json
-- global $c : application constants as json

-- DATA FORM

SET action = 'update';
SET tp = $t->'parameters';
SET form_id = 'parameters';

-- FORM

SELECT
    'form' AS component,
    $form_id AS id,
    '' AS validate;

SELECT
    'report'                        AS name,
    $tp->>'report'                  AS label,
    $p->>'report'                   AS value,
    'number'                        AS type,
    $c->>'number_step'              AS step;

SELECT
    'last_statement'                AS name,
    $tp->>'last_statement'          AS label,
    'date'                          AS type,
    $p->>'last_statement'           AS value;

SELECT
    'dark_theme'                    AS name,
    'switch'                        AS type,    
    CONCAT('🌓 ', $tp->>'dark_theme')      AS label,
    $p->>'dark_theme'               AS checked;

SELECT
    'search_area'                   AS name,
    'switch'                        AS type,   
    CONCAT('🔍 ', $tp->>'search_area') AS label,
    $p->>'search_area'              AS checked;

-- BUTTONS FORM

SELECT 'dynamic' AS component,
    sqlpage.run_sql('buttons_form.sql') AS properties;
