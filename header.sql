--> $t : Translation Texts
    -- SET t = sqlpage.read_file_as_text('text.json');
--> $i_active : active menu index
    -- SET i_active = 1;

-- MENU BAR

SET menu_items = json_array(
    json_object(
        "title", $t->"mvts_pending"->>"title",
        "link", "mvts"
    ),
    json_object(
        "title", $t->"mvts_validated"->>"title",
        "link", "mvts_validated"
    ),
            json_object(
        "title", $t->"mvts_purge"->>"title",
        "link", "mvts_purge"
    ),
        json_object(
        "title", $t->"supports"->>"title",
        "link", "supports"
    ),
            json_object(
        "title", $t->"parameter"->>"title",
        "link", "parameters"
    )
);

-- ACTIVE MENU

SET menu_items = json_set($menu_items, '$[' || $i_active || '].active', true);

-- SHELL

SELECT 
    'shell'             AS component,
    'assets/bank.jpg'   AS image,
    'assets/bank.ico'   AS favicon,
    $t->>'app_title'    AS title,
    "©PCo2025 with [SQLPage](https://sql-page.com)" 
                        AS footer,
    "/mvts"             AS link,
    "/assets/perso.css" AS css,
    $t->>'language'     AS language,
    IIF($t->>'dark_theme', 'dark', '') AS theme,
    --"dark"              AS theme,
    JSON($menu_items)   AS menu_item;

-- BALANCE & LAST STATEMENT

SELECT 'dynamic' AS component,
    sqlpage.run_sql('balance.sql') AS properties;