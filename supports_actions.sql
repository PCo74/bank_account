-- SUPPORTS : CREATE / UPDATE / DELETE

INSERT OR REPLACE
INTO supports(id, name)
SELECT
    (case when $id='' then NULL else $id end),
    :name
WHERE $action = 'create' OR $action='update'
RETURNING 'redirect' AS component, 'supports' AS link;

DELETE FROM supports
WHERE id = $id and $action = 'delete'
RETURNING 'redirect' AS component, 'supports' AS link