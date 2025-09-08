-- DISPLAY BALANCES AND LAST STATEMENT DATE

-- @param $t    translate texts
-- @param $p    parameters
-- @param $mc   money colors,

SELECT 
    'big_number'                AS component;

SELECT 
    $t->'balance'->>'current' AS title,
    IIF(total<0, $mc->>'debit', $mc->>'credit') AS color,
    replace(
        format($p->>'money_format', total),
        '.', $p->>'dec_sep') AS value
FROM balance_actual;

SELECT 
    $t->'balance'->>'bank' AS title,
    IIF(total<0, $mc->>'debit', $mc->>'credit') AS color,
    replace(
        format($p->>'money_format', total),
        '.', $p->>'dec_sep') AS value
FROM balance_bank;

SELECT 
    $t->'parameter'->>'last_statement' || ' ✎' AS title,
    $p->>'last_statement' AS value,
    CONCAT('index?no=5&date=', $p->>'last_statement') as title_link;
