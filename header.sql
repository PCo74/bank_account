/**
  set menu and shell configuration
  display balances and last statement date

  * @global {json} $c : configuration constants
  * @global {int} $no : active menu index
  * @global {json} $p : parameters table
  * @global {json} $t : translation texts
 */

-- MENU BAR

SET menu_items = SELECT json_group_array(
    json_object(
        "title", T.value->>"title",
        "link", "index?no=" || P.key)
    ) AS menu_item
    FROM json_each($c->'pages') P, json_each($t) T
    WHERE P.value = T.key
    AND T.value->>'title' IS NOT NULL;

-- ACTIVE MENU

SET menu_items = json_set($menu_items, '$[' || $no|| '].active', true);

-- SHELL

SELECT 
    'shell'                 AS component,
    -- bank illustration
    'assets/bank.jpg'       AS image,
    'assets/bank.ico'       AS favicon,
    -- choice of the 'dark' theme or not
    IIF($p->>'dark_theme', 'dark', '')
                            AS theme,
    'fluid'                 AS layout,
    $t->>'app_title'        AS title,
    "/"                     AS link,
    "/assets/perso.css"     AS css,
    $t->>'language'         AS language,
    JSON($menu_items)       AS menu_item,
    "©PCo2025 with [SQLPage](https://sql-page.com)" 
                            AS footer;

-- DISPLAY BALANCES AND LAST STATEMENT DATE

SET mc = $c->'money_colors'; -- debit/credit

SET total_actual = SELECT money FROM balance_actual;
SET total_bank   = SELECT money FROM balance_bank;

SELECT 
    'big_number' AS component,
    'balance' AS id; -- id for css styling

SELECT 
    $t->'balance'->>'current' AS title,
    IIF($total_actual < 0, $mc->>'debit', $mc->>'credit') AS color,
    $total_actual AS value;
    
SELECT 
    $t->'balance'->>'bank' AS title,
    IIF($total_bank < 0, $mc->>'debit', $mc->>'credit') AS color,
    $total_bank AS value;

SELECT 
    $t->'parameters'->>'last_statement' || ' ✎' AS title,
    $p->>'last_statement' AS value,
    'index?no=5' AS title_link;
