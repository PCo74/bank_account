-- SQL ACTION

UPDATE parameters
SET
    last_statement = :last_statement
WHERE :last_statement
RETURNING 'redirect' AS component, '?last_statement=' || :last_statement AS link

-- TRANSLATION & MENU

SET t = sqlpage.read_file_as_text('text.json');

SELECT 'dynamic' AS component,
    sqlpage.run_sql('header.sql') AS properties;

-- FORM

SELECT
    'form' AS component,
    'last_statement_id' as id,
    '' as validate;

SELECT
    'last_statement' AS name,
    $t->>'last_statement' AS label,
    $last_statement as value,
    'date'      AS type;

-- FORM BUTTONS

SELECT 'dynamic' AS component,
    sqlpage.run_sql('form_buttons.sql',
        json_object(
            't', $t,
            'form_name', 'last_statement_id',
            'action_link', '',
            'action', 'update',
            'return_link', 'mvts')) AS properties;
