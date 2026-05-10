#set text(font: "AdwaitaMono Nerd Font Propo", size: 11pt)
#set heading(numbering: "1.1")

== Schema Relazionale
Lo schema ristrutturato contiene solamente costrutti mappabili in corrispettivi dello schemas relazionale - detto anche schema logico. Lo schema logico è rappresentato a seguire.


#underline[*NOTE*] (appunti provvisori): 
- Non ho capito bene la gestazione di campione originale/scoperto.
- Non ho capito bene la chiave di campione.
- Manca la chiave su artista (forse nome d'arte)
- Per convenienza aggiungerei il CF al tecnico (e all'artista singolo)
- La parte dell'artista è ancora da capire bene come fare, nel caso di artista che è anche tecnico, e mancano gli attributi in band (ipotizzo id e numero membri)
- Per la generalizzazione artista singolo o band, ho fatto come nell'esempio di progetto del moodle

#line(length: 100%, stroke: 0.5pt)

- *Utente*(#underline[Email], NickName)
- *Campione*(#underline[Data_Creazione, Utente], Canzone-Id, Descrizione, pitch, bpm, echo, is_invertita)
  - Campione.Utente -> Utente.Email
  - Campione.Canzone-Id -> Canzone.Id
- *Canzone*(#underline[Id], Data_rilascio, Titolo, Genere)
- *Creazione*(#underline[Id_Canzone, Nome_Artista], Ruolo)
  - Creazione.Id_Canzone ->  Canzone.Id
  - Creazione.Nome_Artista -> Artista.Nome_D'Arte
- *Rilascio*(#underline[Id_Canzone, Id_Album], Numero_traccia)
  - Rilascio.Id_Canzone -> Canzone.Id
  - Rilascio.Id_Album -> Album.Id
- *Album*(#underline[Id], Nome, Anno_rilascio, Numero_tracce)
- *Produzione*(#underline[Id_Canzone, CF_tecnico], Ruolo)
  - Produzione.Id_Canzone -> Canzone.Id
  - Produzione.CF_tecnico -> Tecnico.CF 
- *Tecnico*(#underline[CF], Nome, Cognome, Nascita, Nazionalità)
- *Artista*(#underline[Nome_D'Arte], Nome_CasaDiscografica)
  - Artista.Nome_CasaDiscografica -> CasaDiscografica.Nome
- *CasaDiscografica*(#underline[Nome], Sede_legale, Album_Id)
  - CasaDiscografica.Album_Id -> Album.Id
- *Singolo*(#underline[CF], Nome, Cognome, Nazionalità, NomeArte)
  - Singolo.NomeArte = Artista.Nome_D'arte
- *Compone*(#underline[CF_Singolo, Id_Band])
  - Compone.CF_Singolo -> Singolo.CF
  - Compone.Id_Band -> Band.Id
- *Band*(#underline[Id], Numero_membri, NomeBand)
  - Band.NomeBand -> Artista.Nome_D'arte
