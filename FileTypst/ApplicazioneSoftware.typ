= Applicazione Software
Il file songDNA.c contiene il codice C necessario per connettersi al database e visualizzare a schermo i risultati delle query presentate nella Sezione 5. Una volta compilato ed eseguito il programma, verrà mostrato all’utente un menu con la seguente lista di interrogazioni disponibili:

1. Dettagli dei tecnici che hanno lavorato a canzoni di un certo genere
2. Canzoni che hanno ricevuto una somma di pitch totale dei campioni superiore o uguale a 1
3. I due artisti che hanno collaborato di più assieme
4. Lista di campioni velocizzati (ovvero con canzone.bpm < campione.bpm)
5. Lista di canzoni che usano il maggior numero in assoluto di campioni

L'utente potrà selezionare la query da eseguire digitando il numero corrispondente. In particolare, la query 1 è parametrica, quindi al momento della selezione il programma chiederà l'inserimento del genere musicale per il quale visualizzare i dettagli dei tecnici che hanno lavorato a canzoni del genere scelto.
