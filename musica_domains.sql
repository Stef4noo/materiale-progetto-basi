CREATE DOMAIN URL_AUDIO AS VARCHAR(128)
CHECK (
    VALUE IS NULL
    OR VALUE LIKE 'https://open.spotify.com/%'
    OR VALUE LIKE 'https://soundcloud.com/%'
    OR VALUE LIKE 'https://www.youtube.com/%'
);

CREATE DOMAIN TIPO_CANZONE AS VARCHAR(12)
CHECK(
    VALUE LIKE 'Cover'
    OR VALUE LIKE 'Remix'
    OR VALUE LIKE 'Originale'
);

CREATE TABLE Utente (
    Email VARCHAR(30) PRIMARY KEY,
    Nickname VARCHAR(20) NOT NULL
);

CREATE TABLE CasaDiscografica (
    Nome VARCHAR(20) PRIMARY KEY,
    Sede_legale VARCHAR(20) NOT NULL
);

CREATE TABLE Canzone (
    Id INT PRIMARY KEY,
    Data_rilascio DATE NOT NULL,
    Titolo VARCHAR(20) NOT NULL,
    Genere VARCHAR(20) NOT NULL,
    url URL_AUDIO,
    bpm INT NOT NULL,
    Tipo TIPO_CANZONE NOT NULL,
    Originale INT,
    FOREIGN KEY (Originale) References Canzone(Id)
);

CREATE TABLE Tecnico (
    Nome VARCHAR(20),
    Cognome VARCHAR(20),
    Data_Nascita DATE,
    Nazionalita VARCHAR(20),
    PRIMARY KEY (Nome, Cognome, Data_Nascita)
);

CREATE TABLE Album (
    Id INT PRIMARY KEY,
    Nome varchar(20) NOT NULL,
    Data_rilascio DATE NOT NULL,
    Numero_tracce INT NOT NULL,
    Nome_CasaDiscografica VARCHAR(20) NOT NULL,
    FOREIGN KEY (Nome_CasaDiscografica) REFERENCES CasaDiscografica(Nome)
);

CREATE TABLE Campione (
    Data_Creazione DATE,
    Utente VARCHAR(30),
    Canzone_Id INT,
    Descrizione VARCHAR(100) NOT NULL,
    pitch INT NOT NULL,
    bpm INT NOT NULL,
    has_ehco BOOL NOT NULL,
    Is_invertita BOOL NOT NULL,
    url URL_AUDIO,
    PRIMARY KEY (Data_Creazione, Utente, Canzone_Id),
    FOREIGN KEY(Utente) REFERENCES Utente(Email),
    FOREIGN KEY(Canzone_Id) REFERENCES Canzone(Id)
);

CREATE TABLE NuovaCanzone (
    Id_Canzone INT,
    Campione_Data DATE,
    Campione_Utente VARCHAR(30),
    Campione_Canzone_Id INT,
    PRIMARY KEY (Id_Canzone, Campione_Data, Campione_Utente, Campione_Canzone_Id),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (Campione_Data, Campione_Utente, Campione_Canzone_Id) REFERENCES Campione(Data_Creazione, Utente, Canzone_Id)
);

CREATE TABLE Produzione (
    Id_Canzone INT,
    Nome_Tecnico VARCHAR(20),
    Cognome_Tecnico VARCHAR(20),
    Data_Nascita_Tecnico DATE NOT NULL,
    Ruolo VARCHAR(20),
    PRIMARY KEY (Id_Canzone, Nome_Tecnico, Cognome_Tecnico, Data_Nascita_Tecnico, Ruolo),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (Nome_Tecnico, Cognome_Tecnico, Data_Nascita_Tecnico) REFERENCES Tecnico(Nome, Cognome, Data_Nascita)
);

CREATE TABLE Singolo (
    Nome VARCHAR(20),
    Cognome VARCHAR(20),
    Data_Nascita DATE,
    Nazionalita VARCHAR(20),
    Nome_DArte VARCHAR(20) PRIMARY KEY,
    Contratto VARCHAR(20) NOT NULL,
    FOREIGN KEY (Contratto) REFERENCES CasaDiscografica(Nome)
);

CREATE TABLE Band (
    Data_Fondazione DATE NOT NULL,
    Nome_DArte VARCHAR(20),
    Contratto VARCHAR(20),
    PRIMARY KEY (Nome_DArte),
    FOREIGN KEY (Contratto) REFERENCES CasaDiscografica(Nome)
);

CREATE TABLE CreazioneSingolo (
    Id_Canzone INT,
    NomeSingolo VARCHAR(20),
    Ruolo VARCHAR(20) NOT NULL,
    PRIMARY KEY (Id_Canzone, NomeSingolo),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (NomeSingolo) REFERENCES Singolo(Nome_DArte)
);

CREATE TABLE CreazioneBand (
    Id_Canzone INT,
    NomeBand VARCHAR(20),
    PRIMARY KEY (Id_Canzone, NomeBand),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (NomeBand) REFERENCES Band(Nome_DArte)
);

CREATE TABLE Rilascio (
    Id_Canzone INT,
    Id_Album INT,
    Numero_traccia INT,
    PRIMARY KEY (Id_Canzone, Id_Album, Numero_traccia),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (Id_Album) REFERENCES Album(Id)
);

CREATE TABLE Membro (
    Nome_Singolo VARCHAR(20),
    Nome_Band VARCHAR (20),
    PRIMARY KEY (Nome_Singolo, Nome_Band),
    FOREIGN KEY (Nome_Singolo) REFERENCES Singolo(Nome_DArte),
    FOREIGN KEY (Nome_Band) REFERENCES Band(Nome_DArte)
);

-- 1. UTENTI
INSERT INTO Utente (Email, Nickname) VALUES
('leo@email.com', 'LeoProd'),
('giulia@email.com', 'GiuBeat'),
('marco@email.com', 'Mark99'),
('alice@email.com', 'AliceSynth'),
('bob@email.com', 'BobCrates'),
('chloe@email.com', 'AnalogGirl'),
('synthlord@email.com', 'MoogMaster');

-- 2. CASE DISCOGRAFICHE
INSERT INTO CasaDiscografica (Nome, Sede_legale) VALUES
('Sony Music', 'New York'),
('EMI Records', 'Londra'),
('Universal Music', 'Santa Monica'),
('Parlophone', 'Londra'),
('Warner Bros', 'Burbank'),
('Virgin Records', 'Londra'),
('Kling Klang', 'Düsseldorf'),
('RCA Records', 'New York'),
('Nothing Records', 'Los Angeles');

-- 3. ALBUM
INSERT INTO Album (Id, Nome, Data_rilascio, Numero_tracce, Nome_CasaDiscografica) VALUES
(1, 'Random Access', '2013-05-17', 13, 'Sony Music'),
(2, 'The Dark Side', '1973-03-01', 10, 'EMI Records'),
(3, 'After Hours', '2020-03-20', 14, 'Universal Music'),
(4, 'OK Computer', '1997-05-21', 12, 'Parlophone'),
(5, 'Led Zeppelin IV', '1971-11-08', 8, 'Warner Bros'),
(6, 'Mezzanine', '1998-04-20', 11, 'Virgin Records'),
(7, 'Trans-Europe Express', '1977-03-01', 8, 'Kling Klang'),
(8, 'Heroes', '1977-10-14', 10, 'RCA Records'),
(9, 'The Downward Spiral', '1994-03-08', 14, 'Nothing Records');

-- 4. CANZONI
INSERT INTO Canzone (Id, Data_rilascio, Titolo, Genere, url, bpm, Tipo, Originale) VALUES
(101, '2013-04-19', 'Get Lucky', 'Electronic', 'https://open.spotify.com/track/get-lucky-101', 116, 'Originale', NULL),
(102, '2013-05-17', 'Instant Crush', 'Electronic', 'https://soundcloud.com/fakeartist/instant-crush-102', 110, 'Originale', NULL),
(103, '1973-03-01', 'Time', 'Rock', 'https://www.youtube.com/watch?v=time103rock', 120, 'Originale', NULL),
(104, '1973-03-01', 'Money', 'Rock', 'https://open.spotify.com/track/money-104', 122, 'Originale', NULL),
(105, '2020-01-29', 'Blinding Lights', 'Pop', 'https://soundcloud.com/fakeartist/blinding-lights-105', 171, 'Originale', NULL),
(106, '2020-03-20', 'Save Your Tears', 'Pop', 'https://www.youtube.com/watch?v=saveyourtears106', 118, 'Originale', NULL),
(107, '2016-09-22', 'Starboy', 'R&B', 'https://open.spotify.com/track/starboy-107', 186, 'Originale', NULL),
(108, '2016-11-18', 'I Feel It Coming', 'R&B', 'https://soundcloud.com/fakeartist/i-feel-it-coming-108', 123, 'Originale', NULL),
(109, '2013-01-01', 'Odd Look', 'Synthwave', 'https://www.youtube.com/watch?v=oddlook109', 115, 'Originale', NULL),
(110, '1997-05-21', 'Paranoid Android', 'Rock', 'https://open.spotify.com/track/paranoid-android-110', 82, 'Originale', NULL),
(111, '1997-05-21', 'Karma Police', 'Rock', 'https://soundcloud.com/fakeartist/karma-police-111', 75, 'Originale', NULL),
(112, '1971-11-08', 'Stairway to Heaven', 'Rock', 'https://www.youtube.com/watch?v=stairway112', 82, 'Originale', NULL),
(113, '1998-04-27', 'Teardrop', 'Electronic', 'https://open.spotify.com/track/teardrop-113', 77, 'Originale', NULL),
(114, '1997-05-21', 'No Surprises', 'Rock', 'https://soundcloud.com/fakeartist/no-surprises-114', 76, 'Originale', NULL),
(115, '1977-03-01', 'Trans-Europe Express', 'Electronic', 'https://www.youtube.com/watch?v=transeurope115', 114, 'Originale', NULL),
(116, '1977-03-01', 'Showroom Dummies', 'Electronic', 'https://open.spotify.com/track/showroom-dummies-116', 118, 'Originale', NULL),
(117, '1994-03-08', 'Closer', 'Industrial', 'https://soundcloud.com/fakeartist/closer-117', 90, 'Originale', NULL),
(118, '1994-03-08', 'Hurt', 'Industrial', 'https://www.youtube.com/watch?v=hurt118', 85, 'Originale', NULL),
(119, '1977-09-23', 'Heroes', 'Rock', 'https://open.spotify.com/track/heroes-119', 112, 'Originale', NULL),
(120, '1994-02-25', 'March of the Pigs', 'Industrial', 'https://soundcloud.com/fakeartist/march-of-the-pigs-120', 269, 'Originale', NULL),
(121, '2005-04-18', 'The Hand That Feeds', 'Industrial', 'https://www.youtube.com/watch?v=handthatfeeds121', 135, 'Originale', NULL),
(122, '2014-06-01', 'Get Lucky Remix', 'Electronic', 'https://open.spotify.com/track/get-lucky-remix-122', 123, 'Remix', 101),
(123, '2021-02-10', 'Save Your Tears Rmx', 'Pop', 'https://soundcloud.com/fakeartist/save-your-tears-rmx-123', 118, 'Remix', 106);

-- 5. TECNICI
INSERT INTO Tecnico (Nome, Cognome, Data_Nascita, Nazionalita) VALUES
('Giorgio', 'Moroder', '1940-04-26', 'Italiana'),
('Alan', 'Parsons', '1948-12-20', 'Britannica'),
('Max', 'Martin', '1971-02-26', 'Svedese'),
('Nigel', 'Godrich', '1971-02-28', 'Britannica'),
('Jimmy', 'Page', '1944-01-09', 'Britannica'),
('Brian', 'Eno', '1948-05-15', 'Britannica'),
('Mark', 'Ellis', '1960-08-16', 'Britannica');

-- 6. SINGOLI
INSERT INTO Singolo (Nome, Cognome, Data_Nascita, Nazionalita, Nome_DArte, Contratto) VALUES
('Abel', 'Tesfaye', '1990-02-16', 'Canadese', 'The Weeknd', 'Universal Music'),
('Vincent', 'Belorgey', '1975-07-31', 'Francese', 'Kavinsky', 'Universal Music'),
('Thomas', 'Bangalter', '1975-01-03', 'Francese', 'Thomas Bangalter', 'Sony Music'),
('Guy-Manuel', 'de Homem-Christo', '1974-02-08', 'Francese', 'Guy-Manuel', 'Sony Music'),
('David', 'Gilmoure', '1946-03-06', 'Britannica', 'David Gilmour', 'EMI Records'),
('Roger', 'Waters', '1943-09-06', 'Britannica', 'Roger Waters', 'EMI Records'),
('Thomas', 'Yorke', '1968-10-07', 'Britannica', 'Thom Yorke', 'Parlophone'),
('Jonathan', 'Greenwood', '1971-11-05', 'Britannica', 'Jonny Greenwood', 'Parlophone'),
('Robert', 'Plant', '1948-08-20', 'Britannica', 'Robert Plant', 'Warner Bros'),
('David', 'Jones', '1947-01-08', 'Britannica', 'David Bowie', 'RCA Records'),
('Trent', 'Reznor', '1965-05-17', 'Statunitense', 'Trent Reznor', 'Nothing Records'),
('Atticus', 'Ross', '1968-01-16', 'Britannica', 'Atticus Ross', 'Nothing Records'),
('Ralf', 'Hutter', '1946-08-20', 'Tedesca', 'Ralf Hutter', 'Kling Klang'),
('Florian', 'Schneider', '1947-04-07', 'Tedesca', 'Florian Schneider', 'Kling Klang');

-- 7. BAND
INSERT INTO Band (Data_Fondazione, Nome_Darte, Contratto) VALUES
('1993-01-01', 'Daft Punk', 'Sony Music'),
('1965-01-01', 'Pink Floyd', 'EMI Records'),
('1985-01-01', 'Radiohead', 'Parlophone'),
('1968-01-01', 'Led Zeppelin', 'Warner Bros'),
('1970-01-01', 'Kraftwerk', 'Kling Klang'),
('1988-01-01', 'Nine Inch Nails', 'Nothing Records'),
('1988-01-01', 'Massive Attack', 'Virgin Records');

-- 8. MEMBRO
INSERT INTO Membro (Nome_Singolo, Nome_Band) VALUES
('Thomas Bangalter', 'Daft Punk'),
('Guy-Manuel', 'Daft Punk'),
('David Gilmour', 'Pink Floyd'),
('Roger Waters', 'Pink Floyd'),
('Thom Yorke', 'Radiohead'),
('Jonny Greenwood', 'Radiohead'),
('Robert Plant', 'Led Zeppelin'),
('Trent Reznor', 'Nine Inch Nails'),
('Atticus Ross', 'Nine Inch Nails'),
('Ralf Hutter', 'Kraftwerk'),
('Florian Schneider', 'Kraftwerk');

-- 9. CAMPIONI
INSERT INTO Campione (Data_Creazione, Utente, Canzone_Id, Descrizione, pitch, bpm, has_ehco, Is_invertita, url) VALUES
('2026-01-10', 'leo@email.com', 101, 'Chitarra funky intro', 0, 124, FALSE, FALSE, 'https://open.spotify.com/track/funk101intro'),
('2026-01-12', 'leo@email.com', 101, 'Vocoder loop ritornello', 2, 116, TRUE, FALSE, 'https://soundcloud.com/fakeartist/vocoder-loop-101'),
('2026-02-15', 'giulia@email.com', 102, 'Synth lead loop', -1, 115, TRUE, FALSE, 'https://www.youtube.com/watch?v=synth102lead'),
('2026-03-01', 'marco@email.com', 105, 'Main synth wave 80s', 0, 171, FALSE, FALSE, 'https://open.spotify.com/track/synthwave105'),
('2026-05-21', 'giulia@email.com', 101, 'Bass slap cut', 0, 116, FALSE, FALSE, 'https://soundcloud.com/fakeartist/bass-slap-101'),
('2026-05-21', 'marco@email.com', 101, 'Rhodes chords', -2, 116, TRUE, TRUE, 'https://www.youtube.com/watch?v=rhodes101chords'),
('2026-05-20', 'marco@email.com', 103, 'Drum loop velocizzato', 4, 140, FALSE, FALSE, 'https://open.spotify.com/track/drumloop103'),
('2026-05-22', 'alice@email.com', 110, 'Guitar solo glitch', 3, 100, TRUE, TRUE, 'https://soundcloud.com/fakeartist/guitar-glitch-110'),
('2026-05-22', 'bob@email.com', 113, 'Harpsichord loop', -1, 77, TRUE, FALSE, 'https://www.youtube.com/watch?v=harp113loop'),
('2026-05-23', 'bob@email.com', 113, 'Vocal breath', 0, 77, TRUE, FALSE, 'https://open.spotify.com/track/vocalbreath113'),
('2026-05-24', 'alice@email.com', 113, 'Heartbeat kick drum', 2, 85, FALSE, FALSE, 'https://soundcloud.com/fakeartist/heartbeat-kick-113'),
('2026-05-25', 'leo@email.com', 113, 'Vinyl crackle FX', 0, 77, FALSE, TRUE, 'https://www.youtube.com/watch?v=vinyl113fx'),
('2026-05-26', 'giulia@email.com', 113, 'Sub bass slide', 1, 77, FALSE, FALSE, 'https://open.spotify.com/track/subbass113'),
('2026-06-01', 'synthlord@email.com', 115, 'Metal percussion hit', 0, 114, TRUE, FALSE, 'https://soundcloud.com/fakeartist/metal-hit-115'),
('2026-06-02', 'synthlord@email.com', 115, 'Synth string chord', 1, 114, FALSE, FALSE, 'https://www.youtube.com/watch?v=string115chord'),
('2026-06-03', 'chloe@email.com', 115, 'Train rhythm beat', 0, 130, FALSE, FALSE, 'https://open.spotify.com/track/trainbeat115'),
('2026-06-04', 'bob@email.com', 115, 'Robotic voice "Trans"', 4, 114, TRUE, TRUE, 'https://soundcloud.com/fakeartist/trans-voice-115'),
('2026-06-05', 'bob@email.com', 115, 'Robotic voice "Europe"', 4, 114, TRUE, TRUE, 'https://www.youtube.com/watch?v=europevoice115'),
('2026-06-06', 'leo@email.com', 115, 'Moog bassline', -2, 114, FALSE, FALSE, 'https://open.spotify.com/track/moog115bass'),
('2026-06-10', 'marco@email.com', 117, 'Industrial drum fill', 2, 100, FALSE, FALSE, 'https://soundcloud.com/fakeartist/industrial117fill'),
('2026-06-11', 'alice@email.com', 119, 'Fripp guitar wail', 3, 112, TRUE, FALSE, 'https://www.youtube.com/watch?v=fripp119wail');



-- 10. NUOVA CANZONE
INSERT INTO NuovaCanzone (Id_Canzone, Campione_Data, Campione_Utente, Campione_Canzone_Id) VALUES
(122, '2026-01-10', 'leo@email.com', 101),
(122, '2026-01-12', 'leo@email.com', 101),
(123, '2026-03-01', 'marco@email.com', 105);

-- 11. CREAZIONE SINGOLO (Solo entità Singolo con rispettivo Ruolo)
INSERT INTO CreazioneSingolo (Id_Canzone, NomeSingolo, Ruolo) VALUES
(105, 'The Weeknd', 'Cantante'),
(106, 'The Weeknd', 'Cantante'),
(107, 'The Weeknd', 'Cantante'),
(108, 'The Weeknd', 'Cantante'),
(109, 'The Weeknd', 'Cantante'),
(109, 'Kavinsky', 'Compositore'),
(110, 'Thom Yorke', 'Cantante'),
(110, 'Jonny Greenwood', 'Chitarrista'),
(111, 'Thom Yorke', 'Cantante'),
(111, 'Jonny Greenwood', 'Chitarrista'),
(114, 'Thom Yorke', 'Cantante'),
(114, 'Jonny Greenwood', 'Chitarrista'),
(117, 'Trent Reznor', 'Compositore'),
(117, 'Atticus Ross', 'Tastierista'),
(118, 'Trent Reznor', 'Compositore'),
(118, 'Atticus Ross', 'Sintetizzatore'),
(120, 'Trent Reznor', 'Cantante'),
(120, 'Atticus Ross', 'Sintetizzatore'),
(121, 'Trent Reznor', 'Compositore'),
(121, 'Atticus Ross', 'Produttore'),
(119, 'David Bowie', 'Cantante'),
(123, 'The Weeknd', 'Cantante');

-- 12. CREAZIONE BAND (Solo entità Band, colonna Ruolo rimossa)
INSERT INTO CreazioneBand (Id_Canzone, NomeBand) VALUES
(101, 'Daft Punk'),
(102, 'Daft Punk'),
(103, 'Pink Floyd'),
(104, 'Pink Floyd'),
(107, 'Daft Punk'),
(108, 'Daft Punk'),
(112, 'Led Zeppelin'),
(113, 'Massive Attack'),
(115, 'Kraftwerk'),
(116, 'Kraftwerk'),
(122, 'Daft Punk');

-- 13. RILASCIO
INSERT INTO Rilascio (Id_Canzone, Id_Album, Numero_traccia) VALUES
(101, 1, 5),
(102, 1, 6),
(103, 2, 4),
(104, 2, 6),
(105, 3, 4),
(106, 3, 11),
(110, 4, 2),
(111, 4, 6),
(114, 4, 10),
(112, 5, 4),
(113, 6, 3),
(115, 7, 1),
(116, 7, 3),
(117, 9, 5),
(118, 9, 14),
(119, 8, 3),
(120, 9, 4),
(121, 9, 8);

-- 14. PRODUZIONE
INSERT INTO Produzione (Id_Canzone, Nome_Tecnico, Cognome_Tecnico, Data_Nascita_Tecnico, Ruolo) VALUES
(101, 'Giorgio', 'Moroder', '1940-04-26', 'Produttore Associato'),
(103, 'Alan', 'Parsons', '1948-12-20', 'Ingegnere del Suono'),
(105, 'Max', 'Martin', '1971-02-26', 'Produttore Esecutivo'),
(106, 'Max', 'Martin', '1971-02-26', 'Produttore Esecutivo'),
(110, 'Nigel', 'Godrich', '1971-02-28', 'Produttore'),
(111, 'Nigel', 'Godrich', '1971-02-28', 'Produttore'),
(112, 'Jimmy', 'Page', '1944-01-09', 'Produttore'),
(119, 'Brian', 'Eno', '1948-05-15', 'Co-Produttore'),
(117, 'Mark', 'Ellis', '1960-08-16', 'Produttore'),
(118, 'Mark', 'Ellis', '1960-08-16', 'Produttore');




-- Query 1: Mostra i dettagli dei tecnici che hanno lavorato a canzoni di genere 'Rock'
SELECT T.Nome, T.Cognome, T.Nazionalita, COUNT(P.Id_Canzone) AS Canzoni_Prodotte
FROM Tecnico T
JOIN Produzione P ON T.Nome = P.Nome_Tecnico
                 AND T.Cognome = P.Cognome_Tecnico
                 AND T.Data_Nascita = P.Data_Nascita_Tecnico
JOIN Canzone C ON P.Id_Canzone = C.Id
WHERE C.Genere = 'Rock'
GROUP BY T.Nome, T.Cognome, T.Nazionalita
ORDER BY Canzoni_Prodotte DESC;

-- Query 2: Seleziona le canzoni che hanno ricevuto una somma di pitch totale dei campioni superiore o uguale a 1
SELECT C.Titolo, SUM(CA.pitch) AS Somma_Pitch
FROM Canzone C
JOIN Campione CA ON C.Id = CA.Canzone_Id
GROUP BY C.Titolo
HAVING SUM(CA.pitch) >= 1;

-- Query 3: i due artisti che hanno collaborato di più assieme che non facciano parte della stessa band
CREATE VIEW Vista_Tutti_Autori AS
SELECT Id_Canzone, NomeSingolo AS Nome_Artista FROM CreazioneSingolo
UNION ALL
SELECT Id_Canzone, NomeBand AS Nome_Artista FROM CreazioneBand;

CREATE VIEW Vista_Collaborazioni AS
SELECT
    C1.Nome_Artista AS Artista_1,
    C2.Nome_Artista AS Artista_2,
    COUNT(*) AS Numero_Collaborazioni
FROM Vista_Tutti_Autori C1
JOIN Vista_Tutti_Autori C2 ON C1.Id_Canzone = C2.Id_Canzone
                 AND C1.Nome_Artista < C2.Nome_Artista
WHERE
    NOT EXISTS (
        SELECT * FROM Membro M1
        JOIN Membro M2 ON M1.Nome_Band = M2.Nome_Band
        WHERE M1.Nome_Singolo = C1.Nome_Artista
          AND M2.Nome_Singolo = C2.Nome_Artista
    )
    AND NOT EXISTS (
        SELECT * FROM Membro
        WHERE Nome_Singolo = C1.Nome_Artista
          AND Nome_Band = C2.Nome_Artista
    )
    AND NOT EXISTS (
        SELECT * FROM Membro
        WHERE Nome_Singolo = C2.Nome_Artista
          AND Nome_Band = C1.Nome_Artista
    )
GROUP BY C1.Nome_Artista, C2.Nome_Artista;

SELECT Artista_1, Artista_2, Numero_Collaborazioni
FROM Vista_Collaborazioni
WHERE Numero_Collaborazioni = (SELECT MAX(Numero_Collaborazioni) FROM Vista_Collaborazioni);

-- Query 4 lista di campioni velocizzati (ovvero con canzone.bpm < campione.bpm)
SELECT
    Ca.Data_Creazione,
    Ca.Utente,
    C.Titolo AS Titolo_Canzone,
    C.bpm AS BPM_Originale,
    Ca.bpm AS BPM_Campione
FROM Campione Ca
JOIN Canzone C ON Ca.Canzone_Id = C.Id
WHERE Ca.bpm > C.bpm;

-- Query 5 lista di canzoni che usano il maggior numero in assoluto di campioni
CREATE VIEW Vista_Conteggio_Campioni AS
SELECT
    C.Id AS Canzone_Id,
    C.Titolo,
    C.Genere,
    COUNT(Ca.Canzone_Id) AS Totale_Campioni
FROM Canzone C
JOIN Campione Ca ON C.Id = Ca.Canzone_Id
GROUP BY C.Id, C.Titolo, C.Genere;

SELECT Canzone_Id, Titolo, Genere, Totale_Campioni
FROM Vista_Conteggio_Campioni
WHERE Totale_Campioni = (SELECT MAX(Totale_Campioni) FROM Vista_Conteggio_Campioni);


-- Creazione degli indici basati su B+ tree per ottimizzare la query 4
CREATE INDEX idx_bpm ON campione USING BTREE (bpm);
CREATE INDEX idx_bpm ON canzone USING BTREE (bpm);
