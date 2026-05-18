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
    PRIMARY KEY (Data_Creazione, Utente),
    FOREIGN KEY(Utente) REFERENCES Utente(Email),
    FOREIGN KEY(Canzone_Id) REFERENCES Canzone(Id)
);

CREATE TABLE Creazione (
    Id_Canzone INT,
    Nome_Artista VARCHAR(20),
    Ruolo VARCHAR(20),
    PRIMARY KEY (Id_Canzone, Nome_Artista, Ruolo),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (Nome_Artista) REFERENCES Artista(Nome_DArte)
);

CREATE TABLE Rilascio (
    Id_Canzone INT,
    Id_Album INT,
    Numero_traccia INT,
    PRIMARY KEY (Id_Canzone, Id_Album, Numero_traccia),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (Id_Album) REFERENCES Album(Id)
);

CREATE TABLE Produzione (
    Id_Canzone INT,
    Nome_Tecnico VARCHAR(20),
    Cognome_Tecnico VARCHAR(20),
    Data_Nascita_Tecnico DATE NOT NULL,
    Ruolo VARCHAR(20),
    PRIMARY KEY (Id_Canzone, Nome_Tecnico, Cognome_Tecnico, Nascita_Tecnico, Ruolo),
    FOREIGN KEY (Id_Canzone) REFERENCES Canzone(Id),
    FOREIGN KEY (Nome_Tecnico, Cognome_Tecnico, Nascita_Tecnico) REFERENCES Tecnico(Nome, Cognome, Nascita)
);

-- Relazione cambiata
CREATE TABLE Compone (
    Nome_Singolo VARCHAR(20),
    Cognome_Singolo VARCHAR(20),
    Data_Nascita_Singolo DATE,
    Id_Band INT,
    PRIMARY KEY (Nome_Singolo, Cognome_Singolo, Data_Nascita_Singolo, Id_Band),
    FOREIGN KEY (Nome_Singolo, Cognome_Singolo, Data_Nascita_Singolo) REFERENCES Singolo(Nome, Cognome, Nascita),
    FOREIGN KEY (Id_Band) REFERENCES Band(Id)
);
