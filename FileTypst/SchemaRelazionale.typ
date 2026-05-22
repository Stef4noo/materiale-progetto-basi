#set text(font: "AdwaitaMono Nerd Font Propo", size: 11pt)
#set heading(numbering: "1.1")

== Schema Relazionale
Lo schema ristrutturato contiene solamente costrutti mappabili in corrispettivi dello schemas relazionale - detto anche schema logico. Lo schema logico è rappresentato a seguire.


#underline[*NOTE*] (appunti provvisori): 
- Manca ancora la parte che riguarda la generalizzazione in canzone, anche la tabella nuova canzone

#line(length: 100%, stroke: 0.5pt)

- *Utente*(#underline[Email], NickName)
- *Campione*(#underline[Data_Creazione, Utente, Canzone-Id], Descrizione, pitch, bpm, has_echo, is_invertita, url)
  - Campione.Utente -> Utente.Email
  - Campione.Canzone-Id -> Canzone.Id
- *Canzone*(#underline[Id], Data_rilascio, Titolo, Genere, bpm, url)
- *Creazione*(#underline[Id_Canzone, Nome_Artista], Ruolo)
  - Creazione.Id_Canzone ->  Canzone.Id
  - Creazione.Nome_Artista -> Artista.Nome_D'Arte
- *Rilascio*(#underline[Id_Canzone, Id_Album], Numero_traccia)
  - Rilascio.Id_Canzone -> Canzone.Id
  - Rilascio.Id_Album -> Album.Id
- *Album*(#underline[Id], Nome, Data_rilascio, Numero_tracce, Nome_CasaDiscografica)
  - Album.Nome_CasaDiscografica -> CasaDiscografica.nome
- *Produzione*(#underline[Id_Canzone, Nome_Tecnico, Cognome_Tecnico, Data_Nascita_Tecnico], Ruolo)
  - Produzione.Id_Canzone -> Canzone.Id
  - (Produzione.Nome_Tecnico, Produzione.Cognome_Tecnico, Produzione.Data_Nascita_Tecnico) -> Tecnico.(Nome, Cognome, Data_Nascita) 
- *Tecnico*(#underline[Nome, Cognome, Data_Nascita], Nazionalità)
- *Artista*(#underline[Nome_D'Arte], Nome_CasaDiscografica)
  - Artista.Nome_CasaDiscografica -> CasaDiscografica.Nome
- *CasaDiscografica*(#underline[Nome], Sede_legale)
- *Singolo*(#underline[NomeArte], Nome, Cognome, Data_Nascita, Nazionalità)
  - Singolo.NomeArte -> Artista.Nome_D'arte
- *Membro*(#underline[Nome_Singolo, Nome_Band])
  - Membro.Nome_Singolo -> Singolo.NomeArte 
  - Membro.Nome_Band -> Band.NomeBand
- *Band*(#underline[NomeBand], Anno_Fondazione)
  - Band.NomeBand -> Artista.Nome_D'arte
