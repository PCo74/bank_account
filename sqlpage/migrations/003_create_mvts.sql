--
-- Fichier généré par SQLiteStudio v3.4.13 sur jeu. sept. 25 15:56:56 2025
--
-- Encodage texte utilisé : UTF-8
--

-- Tableau : mvts

CREATE TABLE mvts (
    id         INTEGER      PRIMARY KEY,
    performed  TEXT (8),
    label      TEXT,
    amount     REAL (12, 4),
    validated  TEXT (8)     CONSTRAINT dates CHECK (performed <= validated),
    support_id INTEGER      REFERENCES supports (id),
    money      "[TEXT ] "   GENERATED ALWAYS AS (replace(replace(format('%,.2f €', amount), ',', ' '), '.', ',') ) STORED
);