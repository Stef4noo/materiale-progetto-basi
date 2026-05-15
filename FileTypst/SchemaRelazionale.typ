#set text(font: "AdwaitaMono Nerd Font Propo", size: 11pt)
#set heading(numbering: "1.1")

== Schema Relazionale
Lo schema ristrutturato contiene solamente costrutti mappabili in corrispettivi dello schemas relazionale - detto anche schema logico. Lo schema logico è rappresentato a seguire.


#underline[*NOTE*] (appunti provvisori): 
- Nelle slide non ho trovato come trattare come chiave esterna una chiave multivalore, penso si faccia così, se sai come si fa dimmi pure
- La relazione Compone è stata cambiata, devo ancora modificarla

#line(length: 100%, stroke: 0.5pt)

- *Utente*(#underline[Email], NickName)
- *Campione*(#underline[Data_Creazione, Utente, Canzone-Id], Descrizione, pitch, bpm, echo, is_invertita)
  - Campione.Utente -> Utente.Email
  - Campione.Canzone-Id -> Canzone.Id
- *Canzone*(#underline[Id], Data_rilascio, Titolo, Genere)
- *Creazione*(#underline[Id_Canzone, Nome_Artista, Ruolo])
  - Creazione.Id_Canzone ->  Canzone.Id
  - Creazione.Nome_Artista -> Artista.Nome_D'Arte
- *Rilascio*(#underline[Id_Canzone, Id_Album, Numero_traccia])
  - Rilascio.Id_Canzone -> Canzone.Id
  - Rilascio.Id_Album -> Album.Id
- *Album*(#underline[Id], Nome, Anno_rilascio, Numero_tracce)
- *Produzione*(#underline[Id_Canzone, Nome_Tecnico, Cognome_Tecnico, Data_Nascita_Tecnico, Ruolo])
  - Produzione.Id_Canzone -> Canzone.Id
  - (Produzione.Nome_Tecnico, Produzione.Cognome_Tecnico, Produzione.Data_Nascita_Tecnico) -> Tecnico.(Nome, Cognome, Data_Nascita) 
- *Tecnico*(#underline[Nome, Cognome, Data_Nascita], Nazionalità)
- *Artista*(#underline[Nome_D'Arte], Nome_CasaDiscografica)
  - Artista.Nome_CasaDiscografica -> CasaDiscografica.Nome
- *CasaDiscografica*(#underline[Nome], Sede_legale, Album_Id)
  - CasaDiscografica.Album_Id -> Album.Id
- *Singolo*(#underline[Nome, Cognome, Data_Nascita], Nazionalità, NomeArte)
  - Singolo.NomeArte -> Artista.Nome_D'arte
- *Compone*(#underline[Nome_Singolo, Cognome_Singolo, Data_Nascita_Singolo, Id_Band])
  - (Compone.Nome_Singolo, Compone.Cognome_Singolo, Compone.Data_Nascita_Singolo) -> Singolo.(Nome, Cognome, Data_Nascita) 
  - Compone.Id_Band -> Band.Id 
- *Band*(#underline[Id], Numero_membri, NomeBand)
  - Band.NomeBand -> Artista.Nome_D'arte
