-- ERROR PAGE --

select 
    'alert'              as component,
    'ERROR' as title,
    "Problem in «**" || sqlpage.path() || "**»." as description_md,
    "Please, report to the *developer*!" as description_md,
    'alert-circle'       as icon,
    'danger'             as color;
select 
    'index'         AS link,
    'green'         AS color,
    'BACK to index' AS title;

-- GET VARIABLES --

SELECT
    'title'          AS component,
    'GET Variables'  AS contents,
    3                AS level,
    TRUE             AS center;

SELECT
    'table'          AS component,
    TRUE             AS sort,
    TRUE             AS search,
    TRUE             AS border,
    TRUE             AS hover,
    FALSE            AS striped_columns,
    TRUE             AS striped_rows,
    'value'          AS markdown;

SELECT "key" AS variable, value
FROM json_each(sqlpage.variables('GET'))
ORDER BY substr("key", 1, 1) = '_', "key";


-- POST VARIABLES --

SELECT
    'title'          AS component,
    'POST Variables' AS contents,
    3                AS level,
    TRUE             AS center;

SELECT
    'table'          AS component,
    TRUE             AS sort,
    TRUE             AS search,
    TRUE             AS border,
    TRUE             AS hover,
    FALSE            AS striped_columns,
    TRUE             AS striped_rows,
    'value'          AS markdown;

SELECT "key" AS variable, value
FROM json_each(sqlpage.variables('POST'))
ORDER BY "key";