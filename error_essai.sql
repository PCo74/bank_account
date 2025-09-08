SET nom = "Philippe";

SET url = sqlpage.path();

SELECT 'dynamic' AS component,
    sqlpage.run_sql('error.sql',
    json_object('name', $nom)) AS properties;