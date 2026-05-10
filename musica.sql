DROP TABLE IF EXISTS Compone;
DROP TABLE IF EXISTS Produzione;
DROP TABLE IF EXISTS Rilascio;
DROP TABLE IF EXISTS Creazione;
DROP TABLE IF EXISTS Campione;
DROP TABLE IF EXISTS Singolo;
DROP TABLE IF EXISTS Band;
DROP TABLE IF EXISTS Artista;
DROP TABLE IF EXISTS CasaDiscografica;
DROP TABLE IF EXISTS Tecnico;
DROP TABLE IF EXISTS Canzone;
DROP TABLE IF EXISTS Album;
DROP TABLE IF EXISTS Utente;

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
    GENERE VARCHAR(20) NOT NULL
);

CREATE TABLE Tecnico (
    CF VARCHAR(16) PRIMARY KEY,
    Nome VARCHAR(20) NOT NULL,
    Cognome VARCHAR(20) NOT NULL,
    Nascita DATE NOT NULL,
    Nazionalita VARCHAR(20) NOT NULL
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
    CF VARCHAR(16) PRIMARY KEY,
    Nome VARCHAR(20) NOT NULL,
    Cognome VARCHAR(20) NOT NULL,
    Nazionalita VARCHAR(20) NOT NULL,
    NomeArte VARCHAR(20) NOT NULL,
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
    CF_Tecnico VARCHAR(10),
    Ruolo VARCHAR(20) NOT NULL,
    PRIMARY KEY (Id_Canzone, CF_Tecnico),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (CF_Tecnico) REFERENCES Tecnico(CF)
);

CREATE TABLE Compone (
    CF_Singolo VARCHAR(16),
    Id_Band INT,
    PRIMARY KEY (CF_Singolo, Id_Band),
    FOREIGN KEY (CF_Singolo) REFERENCES Singolo(CF),
    FOREIGN KEY (Id_Band) REFERENCES Band(Id)
);
