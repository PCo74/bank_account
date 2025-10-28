-- TABLE MVTS ACTIONS

SET return_link = "index?no=" || $no;

-- CREATE/UPDATE

SET sign = SELECT sign FROM supports WHERE id = $support_id;

INSERT OR REPLACE
INTO mvts(id, performed, label, amount, support_id)
SELECT
    CASE WHEN $id='' THEN NULL ELSE $id END,
    :performed,
    :label,
    $sign || ABS(:amount),
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
RETURNING 'redirect' AS component, "index?no=0" AS link

-- VALIDATE

SET last_statement = SELECT last_statement from parameters;
UPDATE mvts
SET
    validated = IIF(performed > $last_statement, performed, $last_statement)
WHERE id = $id and $action = 'validate'
RETURNING 'redirect' AS component, $return_link AS link

-- DELETE PURGE (TODO transaction ?)

UPDATE parameters
SET report = report + (
    SELECT IFNULL(sum(amount), 0)
    FROM mvts
    WHERE $action = 'delete_purge'
        AND validated IS NOT NULL 
        AND validated < $purge_date
    );
DELETE FROM mvts
WHERE $action = 'delete_purge'
    AND validated IS NOT NULL
    AND validated < $purge_date
RETURNING 'redirect' AS component, $return_link AS link;
-- redirect after empty purge !
SELECT 'redirect' AS component, $return_link AS link
WHERE $action = 'delete_purge';

-- ERROR

SELECT 'dynamic' AS component,
    sqlpage.run_sql('error.sql') AS properties;