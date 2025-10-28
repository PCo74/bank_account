-- TABLE SUPPORTS ACTIONS

SET return_link = "index?no=" || $no;

-- CREATE/UPDATE

INSERT OR REPLACE
INTO supports(id, name, sign)
SELECT
    CASE WHEN $id='' THEN NULL ELSE $id END,
    :name,
    :sign
WHERE $action = 'create' OR $action='update'
RETURNING 'redirect' AS component, $return_link AS link;

-- DELETE

DELETE FROM supports
WHERE id = $id and $action = 'delete'
RETURNING 'redirect' AS component, $return_link AS link

-- ERROR

SELECT 'dynamic' AS component,
    sqlpage.run_sql('error.sql') AS properties;