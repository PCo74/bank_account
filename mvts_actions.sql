-- CREATE / UPDATE / DELETE / + VALIDATE / INVALIDATE

DELETE FROM mvts
WHERE id = $id and $action = 'delete'
RETURNING 'redirect' AS component, 'mvts.sql' AS link

UPDATE mvts
SET
    validated = NULL
WHERE id = $id and $action = 'invalidate'
RETURNING 'redirect' AS component, 'mvts_validated' AS link

SET last_statement = SELECT last_statement from parameters;
UPDATE mvts
SET
    validated = IIF(performed > $last_statement, performed, $last_statement)
WHERE id = $id and $action = 'validate'
--AND performed <= $last_statement
RETURNING 'redirect' AS component, 'mvts.sql' AS link

INSERT OR REPLACE
INTO mvts(id, performed, label, amount, support_id)
SELECT
    (case when $id='' then NULL else $id end),
    :performed,
    :label, 
    :amount,
    :support_id
WHERE $action = 'create' OR $action='update'
RETURNING 'redirect' AS component, 'mvts.sql' AS link;

--SET action = IIF($action IN ('create', 'update', 'delete'), $action, 'create');

select 
    'alert'              as component,
    'Erreur'              as title,
    CASE $action
        WHEN 'validate' THEN "Date de validation non valide !!!"
        ELSE '«**' || $action || '**» : action inconnue !'
        END as description_md,
    'alert-circle'       as icon,
    'red'                as color;
select 
    'mvts.sql'       as link,
    'Retourner aux mouvements' as title;