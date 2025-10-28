--
-- Fichier généré par SQLiteStudio v3.4.13 sur mer. oct. 22 10:18:19 2025
--
-- Encodage texte utilisé : UTF-8
--

-- Vue : balance_actual
CREATE VIEW balance_actual AS WITH balance AS (
SELECT 
        IFNULL(sum(amount), 0) + (select report FROM parameters) AS total
    FROM mvts)

SELECT replace(replace(format('%,.2f €', total), ',', ' '), '.', ',') AS money
FROM balance;

-- Vue : balance_bank
CREATE VIEW balance_bank AS WITH balance AS(
SELECT 
        IFNULL(sum(amount), 0) + (select report FROM parameters) AS total
    FROM mvts
    WHERE validated IS NOT NULL)

SELECT replace(replace(format('%,.2f €', total), ',', ' '), '.', ',') AS money
FROM balance;

-- Vue : mvts_supports
CREATE VIEW mvts_supports AS SELECT mvts.id, performed, label, amount, money, validated, support_id, name, sign
    FROM mvts INNER JOIN supports ON mvts.support_id = supports.id
    ORDER BY performed;

-- Vue : mvts_supports_pending
CREATE VIEW mvts_supports_pending AS SELECT *
    FROM mvts_supports
    WHERE validated IS NULL;

-- Vue : mvts_supports_validated
CREATE VIEW mvts_supports_validated AS SELECT *
FROM mvts_supports
WHERE validated NOT NULL;
