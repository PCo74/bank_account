-- TABLE PARAMETERS ACTIONS

-- UPDATE

UPDATE parameters
SET
    report = :report,
    last_statement = :last_statement,
    dark_theme = IIF(:dark_theme="",1,0),
    search_area = IIF(:search_area="",1,0)
WHERE $action = 'update'
RETURNING 'redirect' AS component, 'index?no=0' AS link

-- UPDATE LAST STATEMENT

UPDATE parameters
SET
    last_statement = :last_statement
WHERE $action= 'update_last_statement'
RETURNING 'redirect' AS component, 'index?no=0' AS link

-- ERROR

SELECT 'dynamic' AS component,
    sqlpage.run_sql('error.sql') AS properties;