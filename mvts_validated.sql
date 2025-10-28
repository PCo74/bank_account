-- DATA SETUP

SET mc = $c->'money_colors';

-- TABLE MVTS VALIDATED

SET actions = format(
    "[❗](mvts_actions?no=2&id=%s&action=invalidate '%s')",
     '%s', $t->'actions'->>'invalidate');

select 
    'table' AS component,
    $t->>'action' AS markdown, 
    $t->>'action' AS align_right,
    $t->'mvt'->>'amount' AS money,
    $t->'mvt'->>'amount' AS align_right,
    TRUE AS sort,
    TRUE AS freeze_headers,
    $p->>'search_area' AS search,
    $t->>'no_data' AS empty_description,
    $t->>'search' || '…' AS search_placeholder;
    
SELECT 'dynamic' AS component,
    json_group_array(json_object(
    $t->'mvt'->>'performed', performed,
    $t->'mvt'->>'label', label,
    $t->'mvt'->>'amount', amount,
    $t->'mvt'->>'support_id', name,
    $t->'mvt'->>'validated', validated,
    $t->>'action', format($actions, id, id, id),
    '_sqlpage_color', IIF(amount < 0, $mc->>'debit', $mc->>'credit')
    )) AS properties
FROM mvts_supports_validated;
