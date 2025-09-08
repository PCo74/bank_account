-- CREATE / UPDATE / DELETE / VALIDATE / INVALIDATE / PURGE

SET return_link = "index?no=" || $no;

-- CREATE/UPDATE

INSERT OR REPLACE
INTO mvts(id, performed, label, amount, support_id)
SELECT
    (case when $id='' then NULL else $id end),
    :performed,
    :label, 
    IIF(:amount > 0 AND :support_id <> 4, -:amount, :amount),
    :support_id
WHERE $action = 'create' OR $action='update'
RETURNING 'redirect' AS component, $return_link AS link;

-- DELETE

DELETE FROM mvts
WHERE id = $id and $action = 'delete'
RETURNING 'redirect' AS component, $return_link AS link

-- INVALIDATE

UPDATE mvts
SET
    validated = NULL
WHERE id = $id and $action = 'invalidate'
RETURNING 'redirect' AS component, $return_link AS link

-- VALIDATE

SET last_statement = SELECT last_statement from parameters;
UPDATE mvts
SET
    validated = IIF(performed > $last_statement, performed, $last_statement)
WHERE id = $id and $action = 'validate'
RETURNING 'redirect' AS component, $return_link AS link

-- PURGE (TODO transaction ?)

UPDATE parameters
SET report = report + (
    SELECT IFNULL(sum(amount), 0)
    FROM mvts
    WHERE $action = 'purge'
        AND validated IS NOT NULL 
        AND validated < $purge_date
    );
DELETE FROM mvts
WHERE $action = 'purge'
    AND validated IS NOT NULL
    AND validated < $purge_date
RETURNING 'redirect' AS component, $return_link AS link;

-- ERROR

SELECT 'dynamic' AS component,
    sqlpage.run_sql('error.sql') AS properties;