--
-- Fichier généré par SQLiteStudio v3.4.13 sur jeu. sept. 25 15:59:40 2025
--
-- Encodage texte utilisé : UTF-8
--

-- Tableau : supports

CREATE TABLE supports (
    id   INTEGER   PRIMARY KEY AUTOINCREMENT,
    name TEXT (10),
    sign TEXT (1)  DEFAULT ('-') 
                   CHECK (sign IN ('-', '+') ) 
);

INSERT INTO supports (id, name, sign)
VALUES (1, 'CB', '-'),
       (2, 'CHQ', '-'),
       (3, 'PRE', '-'),
       (4, 'VIR', '+');
