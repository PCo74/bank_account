-- YOUR TRANSLATION & MENU
/*
SET t = sqlpage.read_file_as_text('text.json');
SET mc = sqlpage.read_file_as_text('money_colors.json');

SELECT 'dynamic' AS component,
    sqlpage.run_sql('header.sql',
    json_object('t', $t, 'mc', $mc, 'i_active', 1)) AS properties;
*/

-- PARAMETERS
/*
SET p = SELECT json_object(
            'report', report,
            'last_statement', last_statement,
            'dec_sep', dec_sep,
            'step', step,
            'money_format', money_format
        )
        FROM parameters;
*/
-- TABLE MVTS VALIDATED

SET actions = format(
    "[❗](mvts_actions?no=2&id=%s&action=invalidate '%s')",
     '%s', $t->'actions'->>'invalidate');

select 
    'table' AS component,
    json_array(
        $t->'mvt'->>'performed',
        $t->'mvt'->>'label',
        $t->'mvt'->>'amount',
        $t->'mvt'->>'support_id',
        $t->'mvt'->>'validated',
        $t->'action') AS col_labels,
    'action' AS markdown, 
    'money' AS align_right,
    'action' AS align_center,
    $t->>'no_data' AS empty_description,
    TRUE AS sort,
    TRUE AS freeze_headers,
    TRUE AS search,
    $t->'actions'->>'search' AS search_placeholder;
    
SELECT
    performed,
    label,
    replace(format($p->>'money_format', amount),
        '.', $p->>'dec_sep') AS money,
    name,
    M.validated,
    format($actions, M.id) AS action,
    IIF(amount < 0, 'orange', 'green') as _sqlpage_color
FROM mvts M INNER JOIN supports S ON M.support_id = S.id
WHERE validated IS NOT NULL;
