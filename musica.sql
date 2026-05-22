CREATE TABLE Utente (
    Email VARCHAR(30) PRIMARY KEY,
    Nickname VARCHAR(20) NOT NULL
);

CREATE TABLE Album (
    Id INT PRIMARY KEY,
    Nome varchar(20) NOT NULL,
    Anno_rilascio DATE NOT NULL,
    Numero_tracce INT NOT NULL
);

CREATE TABLE Canzone (
    Id INT PRIMARY KEY,
    Data_rilascio DATE NOT NULL,
    Titolo VARCHAR(20) NOT NULL,
    GENERE VARCHAR(20) NOT NULL,
    bpm INT NOT NULL
);

CREATE TABLE Tecnico (
    Nome VARCHAR(20),
    Cognome VARCHAR(20),
    Data_Nascita DATE,
    Nazionalita VARCHAR(20) NOT NULL,
    PRIMARY KEY (Nome, Cognome, Data_Nascita)
);

CREATE TABLE CasaDiscografica (
    Nome VARCHAR(20) PRIMARY KEY,
    Sede_legale VARCHAR(20) NOT NULL,
    Album_Id INT NOT NULL,
    FOREIGN KEY (Album_Id) REFERENCES Album(Id)
);

CREATE TABLE Artista (
    Nome_DArte VARCHAR(20) PRIMARY KEY,
    Nome_CasaDiscografica VARCHAR(20) NOT NULL,
    FOREIGN KEY (Nome_CasaDiscografica) REFERENCES CasaDiscografica(Nome)
);

CREATE TABLE Singolo (
    Nome VARCHAR(20),
    Cognome VARCHAR(20),
    Data_Nascita DATE,
    Nazionalita VARCHAR(20) NOT NULL,
    NomeArte VARCHAR(20) NOT NULL,
    PRIMARY KEY (Nome, Cognome, Data_Nascita),
    FOREIGN KEY (NomeArte) REFERENCES Artista(Nome_DArte)
);

CREATE TABLE Band (
    Id INT PRIMARY KEY,
    Numero_membri INT NOT NULL,
    NomeBand VARCHAR(20) NOT NULL, 
    FOREIGN KEY (NomeBand) REFERENCES Artista(Nome_DArte)
);

CREATE TABLE Campione (
    Data_Creazione DATE,
    Utente VARCHAR(30),
    Canzone_Id INT NOT NULL,
    Descrizione VARCHAR(100) NOT NULL,
    pitch INT NOT NULL, 
    bpm INT NOT NULL,
    PRIMARY KEY (Data_Creazione, Utente),
    FOREIGN KEY(Utente) REFERENCES Utente(Email),
    FOREIGN KEY(Canzone_Id) REFERENCES Canzone(Id)
);

CREATE TABLE Creazione (
    Id_Canzone INT,
    Nome_Artista VARCHAR(20),
    Ruolo VARCHAR(20) NOT NULL,
    PRIMARY KEY (Id_Canzone, Nome_Artista),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (Nome_Artista) REFERENCES Artista(Nome_DArte)
);

CREATE TABLE Rilascio (
    Id_Canzone INT,
    Id_Album INT,
    Numero_traccia INT NOT NULL,
    PRIMARY KEY (Id_Canzone, Id_Album),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (Id_Album) REFERENCES Album(Id)
);

CREATE TABLE Produzione (
    Id_Canzone INT,
    Nome_Tecnico VARCHAR(20),
    Cognome_Tecnico VARCHAR(20),
    Data_Nascita_Tecnico DATE NOT NULL,
    Ruolo VARCHAR(20) NOT NULL,
    PRIMARY KEY (Id_Canzone, Nome_Tecnico, Cognome_Tecnico, Data_Nascita_Tecnico),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (Nome_Tecnico, Cognome_Tecnico, Data_Nascita_Tecnico) REFERENCES Tecnico(Nome, Cognome, Data_Nascita)
);

-- Relazione cambiata
CREATE TABLE Compone (
    Nome_Singolo VARCHAR(20),
    Cognome_Singolo VARCHAR(20),
    Data_Nascita_Singolo DATE,
    Id_Band INT,
    PRIMARY KEY (Nome_Singolo, Cognome_Singolo, Data_Nascita_Singolo, Id_Band),
    FOREIGN KEY (Nome_Singolo, Cognome_Singolo, Data_Nascita_Singolo) REFERENCES Singolo(Nome, Cognome, Data_Nascita),
    FOREIGN KEY (Id_Band) REFERENCES Band(Id)
);


-- 1. UTENTI
INSERT INTO Utente (Email, Nickname) VALUES
('leo@email.com', 'LeoProd'),
('giulia@email.com', 'GiuBeat'),
('marco@email.com', 'Mark99');

-- 2. ALBUM
INSERT INTO Album (Id, Nome, Anno_rilascio, Numero_tracce) VALUES
(1, 'Random Access', '2013-05-17', 13),
(2, 'The Dark Side', '1973-03-01', 10),
(3, 'After Hours', '2020-03-20', 14);

-- 3. CANZONI
INSERT INTO Canzone (Id, Data_rilascio, Titolo, GENERE, bpm) VALUES
(101, '2013-04-19', 'Get Lucky', 'Electronic', 116),
(102, '2013-05-17', 'Instant Crush', 'Electronic', 110),
(103, '1973-03-01', 'Time', 'Rock', 120),
(104, '1973-03-01', 'Money', 'Rock', 122),
(105, '2020-01-29', 'Blinding Lights', 'Pop', 171),
(106, '2020-03-20', 'Save Your Tears', 'Pop', 118),

(107, '2016-09-22', 'Starboy', 'R&B', 186),
(108, '2016-11-18', 'I Feel It Coming', 'R&B', 123),
(109, '2013-01-01', 'Odd Look', 'Synthwave', 115);

-- 4. TECNICI
INSERT INTO Tecnico (Nome, Cognome, Data_Nascita, Nazionalita) VALUES
('Giorgio', 'Moroder', '1940-04-26', 'Italiana'),
('Alan', 'Parsons', '1948-12-20', 'Britannica'),
('Max', 'Martin', '1971-02-26', 'Svedese');

-- 5. CASE DISCOGRAFICHE
INSERT INTO CasaDiscografica (Nome, Sede_legale, Album_Id) VALUES
('Sony Music', 'New York', 1),
('EMI Records', 'Londra', 2),
('Universal Music', 'Santa Monica', 3);

-- 6. ARTISTI
INSERT INTO Artista (Nome_DArte, Nome_CasaDiscografica) VALUES
('Daft Punk', 'Sony Music'),
('Pink Floyd', 'EMI Records'),
('The Weeknd', 'Universal Music'),
('Kavinsky', 'Universal Music');

-- 7. SINGOLI (Artisti Solisti o Componenti di Band)
INSERT INTO Singolo (Nome, Cognome, Data_Nascita, Nazionalita, NomeArte) VALUES
('Abel', 'Tesfaye', '1990-02-16', 'Canadese', 'The Weeknd'),
('Vincent', 'Belorgey', '1975-07-31', 'Francese', 'Kavinsky'),
('Thomas', 'Bangalter', '1975-01-03', 'Francese', 'Daft Punk'),
('Guy-Manuel', 'de Homem-Christo', '1974-02-08', 'Francese', 'Daft Punk'),
('David', 'Gilmoure', '1946-03-06', 'Britannica', 'Pink Floyd'),
('Roger', 'Waters', '1943-09-06', 'Britannica', 'Pink Floyd');

-- 8. BAND
INSERT INTO Band (Id, Numero_membri, NomeBand) VALUES
(1, 2, 'Daft Punk'),
(2, 4, 'Pink Floyd');

-- 9. COMPONE (Associazione Singoli -> Band)
INSERT INTO Compone (Nome_Singolo, Cognome_Singolo, Data_Nascita_Singolo, Id_Band) VALUES
('Thomas', 'Bangalter', '1975-01-03', 1),
('Guy-Manuel', 'de Homem-Christo', '1974-02-08', 1),
('David', 'Gilmoure', '1946-03-06', 2),
('Roger', 'Waters', '1943-09-06', 2);

-- 10. CAMPIONI
INSERT INTO Campione (Data_Creazione, Utente, Canzone_Id, Descrizione, pitch, bpm) VALUES
('2026-01-10', 'leo@email.com', 101, 'Chitarra funky intro', 0, 124),       
('2026-01-12', 'leo@email.com', 101, 'Vocoder loop ritornello', 2, 116),    
('2026-02-15', 'giulia@email.com', 102, 'Synth lead loop', -1, 115),       
('2026-03-01', 'marco@email.com', 105, 'Main synth wave 80s', 0, 171),

('2026-05-21', 'giulia@email.com', 101, 'Bass slap cut', 0, 116),
('2026-05-21', 'marco@email.com', 101, 'Rhodes chords', -2, 116),
('2026-05-20', 'marco@email.com', 103, 'Drum loop velocizzato', 4, 140);

-- 11. CREAZIONE
INSERT INTO Creazione (Id_Canzone, Nome_Artista, Ruolo) VALUES
(101, 'Daft Punk', 'Compositore'),
(102, 'Daft Punk', 'Compositore'),
(103, 'Pink Floyd', 'Autore'),
(104, 'Pink Floyd', 'Autore'),
(105, 'The Weeknd', 'Cantante'),
(106, 'The Weeknd', 'Cantante'),
(107, 'The Weeknd', 'Cantante'),
(107, 'Daft Punk', 'Produttore'), 
(108, 'The Weeknd', 'Cantante'),
(108, 'Daft Punk', 'Produttore'), 
(109, 'The Weeknd', 'Cantante'),
(109, 'Kavinsky', 'Compositore');


-- 12. RILASCIO
INSERT INTO Rilascio (Id_Canzone, Id_Album, Numero_traccia) VALUES
(101, 1, 5),
(102, 1, 6),
(103, 2, 4),
(104, 2, 6),
(105, 3, 4),
(106, 3, 11);

-- 13. PRODUZIONE
INSERT INTO Produzione (Id_Canzone, Nome_Tecnico, Cognome_Tecnico, Data_Nascita_Tecnico, Ruolo) VALUES
(101, 'Giorgio', 'Moroder', '1940-04-26', 'Produttore Associato'),
(103, 'Alan', 'Parsons', '1948-12-20', 'Ingegnere del Suono'),
(105, 'Max', 'Martin', '1971-02-26', 'Produttore Esecutivo'),
(106, 'Max', 'Martin', '1971-02-26', 'Produttore Esecutivo');


-- IPOTESI DI QUERY PROVVISORIE

-- Query 3: Mostra i dettagli dei tecnici che hanno lavorato a canzoni di genere 'Rock'
-- Ci sta, magari gli ordiniamo in ordine decrescente per il numero di canzoni che hanno prodotto (?)
SELECT T.Nome, T.Cognome, T.Nazionalita, COUNT(P.Id_Canzone) AS Canzoni_Prodotte
FROM Tecnico T
JOIN Produzione P ON T.Nome = P.Nome_Tecnico 
                 AND T.Cognome = P.Cognome_Tecnico 
                 AND T.Data_Nascita = P.Data_Nascita_Tecnico
JOIN Canzone C ON P.Id_Canzone = C.Id
WHERE C.GENERE = 'Rock'
GROUP BY T.Nome, T.Cognome, T.Nazionalita
ORDER BY Canzoni_Prodotte DESC;

-- Query 4: Visualizza i brani musicali contenuti nell'album 'Random Access' con il loro numero di traccia
SELECT R.Numero_traccia, C.Titolo, A.Nome AS Nome_Album
FROM Rilascio R
JOIN Canzone C ON R.Id_Canzone = C.Id
JOIN Album A ON R.Id_Album = A.Id
WHERE A.Nome = 'Random Access'
ORDER BY R.Numero_traccia;

-- Query 6: Numero di campioni caricati nel sistema per ogni utente (mostrando il nickname)
SELECT U.Nickname, COUNT(C.Data_Creazione) AS Totale_Campioni
FROM Utente U
LEFT JOIN Campione C ON U.Email = C.Utente
GROUP BY U.Nickname;

-- Query 7: Conteggio delle canzoni prodotte da ciascun tecnico
SELECT P.Nome_Tecnico, P.Cognome_Tecnico, COUNT(P.Id_Canzone) AS Canzoni_Prodotte
FROM Produzione P
GROUP BY P.Nome_Tecnico, P.Cognome_Tecnico;

-- Query 8: Trova gli artisti che hanno pubblicato più di un brano nel database
SELECT CR.Nome_Artista, COUNT(CR.Id_Canzone) AS Numero_Brani
FROM Creazione CR
GROUP BY CR.Nome_Artista
HAVING COUNT(CR.Id_Canzone) > 1;

-- Query 9: Generi musicali che hanno una quantità di canzoni strettamente superiore a 1, ordinati per importanza

SELECT GENERE, COUNT(*) AS Quantita
FROM Canzone
GROUP BY GENERE
HAVING COUNT(*) > 1;

-- Query 10: Seleziona le canzoni che hanno ricevuto una somma di pitch totale dei campioni superiore o uguale a 1
-- Ci sta
SELECT C.Titolo, SUM(CA.pitch) AS Somma_Pitch
FROM Canzone C
JOIN Campione CA ON C.Id = CA.Canzone_Id
GROUP BY C.Titolo
HAVING SUM(CA.pitch) >= 1;

-- Query 11: Trova tutti i membri di una specifica Band (es. 'Daft Punk')
SELECT S.Nome, S.Cognome, B.NomeBand
FROM Singolo S
JOIN Compone CO ON S.Nome = CO.Nome_Singolo 
               AND S.Cognome = CO.Cognome_Singolo 
               AND S.Data_Nascita = CO.Data_Nascita_Singolo
JOIN Band B ON CO.Id_Band = B.Id
WHERE B.NomeBand = 'Daft Punk';

-- Proposte extra:
-- * i due artisti che hanno collaborato di più assieme (sarà una query molto lunga)
CREATE VIEW Vista_Collaborazioni AS
SELECT 
    C1.Nome_Artista AS Artista_1, 
    C2.Nome_Artista AS Artista_2, 
    COUNT(*) AS Numero_Collaborazioni
FROM Creazione C1
JOIN Creazione C2 ON C1.Id_Canzone = C2.Id_Canzone 
                 AND C1.Nome_Artista < C2.Nome_Artista 
GROUP BY C1.Nome_Artista, C2.Nome_Artista;

SELECT Artista_1, Artista_2, Numero_Collaborazioni
FROM Vista_Collaborazioni
WHERE Numero_Collaborazioni = (SELECT MAX(Numero_Collaborazioni) FROM Vista_Collaborazioni);

-- * lista di campioni velocizzati (ovvero con canzone.bpm < campione.bpm)
SELECT 
    Ca.Data_Creazione, 
    Ca.Utente, 
    C.Titolo AS Titolo_Canzone, 
    C.bpm AS BPM_Originale, 
    Ca.bpm AS BPM_Campione
FROM Campione Ca
JOIN Canzone C ON Ca.Canzone_Id = C.Id
WHERE Ca.bpm > C.bpm;

-- * lista di canzoni che usano il maggior numero in assoluto di campioni
CREATE VIEW Vista_Conteggio_Campioni AS
SELECT 
    C.Id AS Canzone_Id, 
    C.Titolo, 
    C.GENERE, 
    COUNT(Ca.Canzone_Id) AS Totale_Campioni
FROM Canzone C
JOIN Campione Ca ON C.Id = Ca.Canzone_Id
GROUP BY C.Id, C.Titolo, C.GENERE;

SELECT Canzone_Id, Titolo, GENERE, Totale_Campioni
FROM Vista_Conteggio_Campioni
WHERE Totale_Campioni = (SELECT MAX(Totale_Campioni) FROM Vista_Conteggio_Campioni);

-- lista di canzoni di musica elettronica che usano campioni di tutti i generi eccetto musica elettronica
SELECT Id, Titolo, GENERE
FROM Canzone
WHERE GENERE = 'Electronic'
  AND Id IN (SELECT Canzone_Id FROM Campione)
  
  AND Id NOT IN (
      SELECT Ca.Canzone_Id
      FROM Campione Ca
      JOIN Canzone C_Sorgente ON Ca.Canzone_Id = C_Sorgente.Id
      WHERE C_Sorgente.GENERE = 'Electronic'
  );
