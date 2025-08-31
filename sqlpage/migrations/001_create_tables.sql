--
-- Fichier généré par SQLiteStudio v3.4.13 sur jeu. août 14 15:56:09 2025
--
-- Encodage texte utilisé : UTF-8
--

-- Tableau : mvts
CREATE TABLE IF NOT EXISTS mvts (id INTEGER PRIMARY KEY, performed TEXT (8), label TEXT, amount REAL (10, 2), validated TEXT (8) CONSTRAINT dates CHECK (performed <= validated), support_id INTEGER REFERENCES supports (id));

-- Tableau : parameters
CREATE TABLE IF NOT EXISTS parameters (report REAL, last_statement TEXT (8), dec_sep TEXT (1), dec_nb INTEGER CHECK (dec_nb >= 0 AND dec_nb <= 4), step REAL GENERATED ALWAYS AS (CASE dec_nb WHEN 1 THEN 0.1 WHEN 2 THEN 0.01 WHEN 3 THEN 0.001 WHEN 4 THEN 0.0001 ELSE 1 END) VIRTUAL, currency TEXT, money_format TEXT GENERATED ALWAYS AS ('%.' || dec_nb || 'f ' || currency) VIRTUAL);

-- Tableau : supports
CREATE TABLE IF NOT EXISTS supports (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT (5));

-- Vue : balance_actual
CREATE VIEW IF NOT EXISTS balance_actual AS SELECT
    IFNULL(sum(amount), 0) + (SELECT report FROM parameters) AS total
FROM mvts;

-- Vue : balance_bank
CREATE VIEW IF NOT EXISTS balance_bank AS SELECT 
    IFNULL(sum(amount), 0) + (select report FROM parameters) AS total
FROM mvts
WHERE validated IS NOT NULL;
