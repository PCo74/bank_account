-- TABLE LEVEL 0 FOR MVTS

SELECT 
    'table' AS component,
    TRUE AS small,
    $t->>'action' AS markdown,
    $t->'mvt'->>'amount' AS align_right,
    $t->'mvt'->>'support_id' AS align_center,
    $t->>'action' AS align_center,
    TRUE AS sort,
    TRUE AS freeze_headers,
    $p->>'search_area' AS search,
    $t->>'no_data' AS empty_description,
    $t->>'search' || '…' AS search_placeholder;
