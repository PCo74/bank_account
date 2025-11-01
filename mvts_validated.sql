-- DATA SETUP

SET debit = $c->'money_colors'->>'debit';
SET credit = $c->'money_colors'->>'credit';

-- TABLE MVTS VALIDATED

SET actions = format(
    "[❗](mvts_actions?no=2&id=%s&action=invalidate '%s')",
     '%s', $t->'actions'->>'invalidate');

SELECT 'dynamic' AS component,
    sqlpage.run_sql('top_level_table_for_mvts.sql') AS properties;
    
SELECT 'dynamic' AS component,
    json_group_array(json_object(
    $t->'mvt'->>'performed', performed,
    $t->'mvt'->>'label', label,
    $t->'mvt'->>'amount', money,
    $t->'mvt'->>'support_id', name,
    $t->'mvt'->>'validated', validated,
    $t->>'action', format($actions, id, id, id),
    '_sqlpage_color', IIF(amount < 0, $debit, $credit)
    )) AS properties
FROM mvts_supports_validated;
