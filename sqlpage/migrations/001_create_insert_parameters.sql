--
-- Fichier généré par SQLiteStudio v3.4.13 sur mer. oct. 22 10:21:01 2025
--
-- Encodage texte utilisé : UTF-8
--

-- Tableau : parameters
CREATE TABLE parameters (
    report REAL,
    last_statement TEXT (8),
    search_area INTEGER DEFAULT (0),
    dark_theme INTEGER DEFAULT (0)
);

INSERT INTO parameters (
    report,
    last_statement,
    search_area,
    dark_theme)
VALUES (0, date('now', 'localtime'), 0, 0);

