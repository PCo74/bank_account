/**
 * set menu and global configuration
 * display balances and last statement date
 *
 * @param {json} $t : translation texts
 * @param {int} $no : active menu index
 */

-- MENU BAR

SET menu_items = json_array(
    json_object(
        "title", $t->"mvts_pending"->>"title",
        "link", "index?no=0"
    ),
    json_object(
        "title", $t->"mvts_validated"->>"title",
        "link", "index?no=1"
    ),
    json_object(
        "title", $t->"mvts_purge"->>"title",
        "link", "index?no=2"
    ),
    json_object(
        "title", $t->"supports"->>"title",
        "link", "index?no=3"
    ),
    json_object(
        "title", $t->"parameter"->>"title",
        "link", "index?no=4"
    )
);

-- ACTIVE MENU

SET menu_items = json_set($menu_items, '$[' || $no|| '].active', true);

-- SHELL

SELECT 
    'shell'             AS component,
    -- bank illustration change !
    'assets/bank.jpg'   AS image,
    'assets/bank.ico'   AS favicon,
    -- choice of the 'dark' theme or nothing
    -- 'dark'              AS theme,

    $t->>'app_title'    AS title,
    "/"                 AS link,
    "/assets/perso.css" AS css,
    $t->>'language'     AS language,
    JSON($menu_items)   AS menu_item,
    "©PCo2025 with [SQLPage](https://sql-page.com)" 
                        AS footer;
