#set text(font: "Arial", size: 11pt)
#set heading(numbering: "1.1")

== Analisi delle Ridondanze

L'attributo *N_BRANI* in *ALBUM*, che memorizza il numero di canzoni associate ad un album, presenta una ridondanza. Questo può infatti essere ottenuto contando il numero di occorrenze per quell'album tramite la relazione *RILASCIO*.

Questo attributo viene modificato ogni volta che viene inserita una nuova traccia in un album e viene visualizzato frequentemente per il monitoraggio del catalogo. Si riassume nelle seguenti due operazioni principali:
- *Operazione 1 (50 al giorno):* memorizza una nuova canzone in relativo album.
- *Operazione 2 (5000 al giorno):* visualizza il numero di brani in un album.

Assumendo i seguenti volumi nella base di dati:

#align(center)[
  #table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [*Concetto*], [*Costrutto*], [*Volume*],
    [ALBUM], [E], [5.000],
    [RILASCIO], [R], [120.000],
    [CANZONE], [E], [100.000],
  )
]

La seguente analisi serve per stabilire se sia utile o meno tenere l'attributo ridondante *N_BRANI* in *ALBUM*.

*CON RIDONDANZA* Analizziamo prima il costo totale con ridondanza.

- Operazione 1:
#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto),
    inset: 8pt,
    [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*], [*Freq*],
    [CANZONE], [E], [1], [S], [50],
    [RILASCIO], [R], [1], [S], [50],
    [ALBUM], [E], [1], [L], [50],
    [ALBUM], [E], [1], [S], [50],
  )
]

- Operazione 2:
#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto),
    inset: 8pt,
    [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*], [*Freq*],
    [ALBUM], [E], [1], [L], [5.000],
  )
]

Assumendo costo doppio per gli accessi in scrittura:
$ "Costo Totale" = 50 times 3 times 2 + 50 + 5000 = 5.350 $

*SENZA RIDONDANZA* Analizziamo il costo totale senza ridondanza.

- Operazione 1:
#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto),
    inset: 8pt,
    [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*], [*Freq*],
    [CANZONE], [E], [1], [S], [50],
    [RILASCIO], [R], [1], [S], [50],
  )
]

- Operazione 2 (con circa $120.000 / 5.000 = 24$ canzoni per album):
#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto),
    inset: 8pt,
    [*Concetto*], [*Costrutto*], [*Accessi*], [*Tipo*], [*Freq*],
    [ALBUM], [E], [1], [L], [5.000],
    [RILASCIO], [R], [24], [L], [5.000],
  )
]

Assumendo costo doppio per gli accessi in scrittura:
$ "Costo Totale" = 50 times 2 times 2 + 24 times 5000 + 5000 = 125200$

L'analisi suggerisce quindi di tenere l'attributo ridondante, ottimizzando così il numero di accessi.

