#show figure: set figure(supplement: none)
= Implementazione in PostgreSQL e Definizione delle Query
== Definizione delle Query
Di seguito vengono presentate e descritte le query con i relativi output generati e viene motivato l’utilizzo dell’indice proposto.

*Query 1* Mostrare i dettagli dei tecnici che hanno lavorato a canzoni di un certo genere (ad esempio Rock) ordinati in ordine decrescente per il numero di canzoni che hanno prodotto
```sql
SELECT T.Nome, T.Cognome, T.Nazionalita, COUNT(P.Id_Canzone) AS Canzoni_Prodotte
FROM Tecnico T
JOIN Produzione P ON T.Nome = P.Nome_Tecnico 
                 AND T.Cognome = P.Cognome_Tecnico 
                 AND T.Data_Nascita = P.Data_Nascita_Tecnico
JOIN Canzone C ON P.Id_Canzone = C.Id
WHERE C.GENERE = 'Rock'
GROUP BY T.Nome, T.Cognome, T.Nazionalita
ORDER BY Canzoni_Prodotte DESC;
```
#figure(
  image("query1.png", width: 80%),
  caption: [
    Esecuzione query 1 
  ],
)

*Query 2* Selezionare le canzoni che hanno ricevuto una somma di pitch totale dei campioni superiore o uguale a 1
```sql
SELECT C.Titolo, SUM(CA.pitch) AS Somma_Pitch
FROM Canzone C
JOIN Campione CA ON C.Id = CA.Canzone_Id
GROUP BY C.Titolo
HAVING SUM(CA.pitch) >= 1;
```
#figure(
  image("query2.png", width: 80%),
  caption: [
    Esecuzione query 2
  ],
)

*Query 3* Trovare i due artisti che hanno collaborato di più assime
```sql
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
```

#figure(
  image("query3.png", width: 80%),
  caption: [
    Esecuzione query 3
  ],
)

*Query 4* Restituire la lista dei campioni velocizzati, ovvero con canzone.bpm < campione.bpm
```sql
SELECT 
    Ca.Data_Creazione, 
    Ca.Utente, 
    C.Titolo AS Titolo_Canzone, 
    C.bpm AS BPM_Originale, 
    Ca.bpm AS BPM_Campione
FROM Campione Ca
JOIN Canzone C ON Ca.Canzone_Id = C.Id
WHERE Ca.bpm > C.bpm;
```
#figure(
  image("query4.png", width: 80%),
  caption: [
    Esecuzione query 4
  ],
)

*Query 5* Restituire la lista di canzone che usano il maggior numero in assoluto di campioni
```sql
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
```
#figure(
  image("query5.png", width: 80%),
  caption: [
    Esecuzione query 5
  ],
)

== Creazione degli indici
Si è scelto di ottimizzare la Query 1, la quale seleziona i dettagli dei tecnici che hanno lavorato a canzoni di genere 'Rock'. La struttura logica dell'interrogazione prevede l'esecuzione di una `JOIN` tra le tabelle `Tecnico`, `Produzione` e `Canzone`, seguita da un filtraggio basata su un operatore di ugualianza (`C.Genere = 'Rock'`) e un'operazione finale di aggregazione e ordinamento (`GROUP BY T.Nome, T.Cognome, T.Nazionalita`) (`ORDER BY Canzoni_Prodotte DESC`).

Per ottimizzare questa query si è deciso di intervenire su:
1. Filtraggio sul Genere della Canzone: La clausola `WHERE C.Genere = 'Rock'` richiede una ricerca basata su un'uguaglianza, quindi l'implementazione di un indice basato su hasing risulta particolarmente efficace.
2. Analisi sull'esclusione di altri indici: si è ritenuto superfluo creare ulteriori indici per ottimizzare la clausola `GROUP BY T.Nome, T.Cognome, T.Nazionalita`. I campi in questione costituiscono infatti la chiave primaria della tabella `Tecnico`. Poiché PostgreSQL crea in automatico un indice B+ Tree per ogni chiave primaria, esiste già un indice in cui le tuple sono mantenute in ordine

In conclusione l'indice è riportato a seguire:
```sql
CREATE INDEX idx_canzone_genere ON Canzone USING HASH (Genere);
```
