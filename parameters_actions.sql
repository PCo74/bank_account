-- UPDATE

UPDATE parameters
SET
    report = :report,
    last_statement = :last_statement,
    dec_sep = :dec_sep,
    dec_nb = :dec_nb,
    currency = :currency
WHERE $action = 'update'
RETURNING 'redirect' AS component, 'index?no=0' AS link

-- UPDATE_LAST_STATEMENT

UPDATE parameters
SET
    last_statement = :last_statement
WHERE $action= 'update_last_statement'
RETURNING 'redirect' AS component, 'index?no=0' AS link

-- ERROR

SELECT 'dynamic' AS component,
    sqlpage.run_sql('error.sql') AS properties;