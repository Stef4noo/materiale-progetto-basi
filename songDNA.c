#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libpq-fe.h>

// Definire i parametri di connessione qui
#define PG_HOST "localhost"
#define PG_USER "postgres"
#define PG_DB "Musica"
#define PG_PASS "Ctynnul65g"
#define PG_PORT 5432

void checkResults(PGresult *res, const PGconn *conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        printf("Errore: %s\n", PQerrorMessage(conn));
        PQclear(res);
        exit(1);
    }
}

int selezione(){
    printf("1. Dettagli dei tecnici che hanno lavorato a canzoni di un certo genere\n");
    printf("2. Canzoni che hanno ricevuto una somma di pitch totale dei campioni superiore o uguale a 1\n");
    printf("3. I due artisti che hanno collaborato di più assieme\n");
    printf("4. Lista di campioni velocizzati (ovvero con canzone.bpm < campione.bpm)\n");
    printf("5. Lista di canzoni che usano il maggior numero in assoluto di campioni\n\n");

    printf("Seleziona la query: ");
    int selezionato;
    scanf("%d", &selezionato);
    printf("\n");
    return selezionato;
}

void stampaLinea(int campi) {
        for (int i = 0; i < campi; i++) {
            printf("+-------------------------");
        }
        printf("+\n");
}

void eseguiStampaQueryParametrica(PGconn *conn, const char *stmtName, const char *query, const char *valoreParametro) {
    PGresult *res = PQprepare(conn, stmtName, query, 1, NULL);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        printf("Errore in fase di preparazione: %s\n", PQerrorMessage(conn));
        PQclear(res);
        return;
    }
    PQclear(res);

    const char *params[1] = {valoreParametro};
    res = PQexecPrepared(conn, stmtName, 1, params, NULL, NULL, 0);

    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        printf("Errore nell'esecuzione: %s\n", PQerrorMessage(conn));
        PQclear(res);
        return;
    }

    int tuple = PQntuples(res);
    int campi = PQnfields(res);
    stampaLinea(campi);
    printf("|");
    for (int i = 0; i < campi; i++) printf(" %-24s|", PQfname(res, i));
    printf("\n");
    stampaLinea(campi);
    for (int i = 0; i < tuple; i++) {
        printf("|");
        for (int j = 0; j < campi; j++) printf(" %-24s|", PQgetvalue(res, i, j));
        printf("\n");
    }
    stampaLinea(campi);
    PQclear(res);
}

void eseguiStampaQuery(PGconn *conn, const char *query) {
    PGresult *res = PQexec(conn, query);

    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        printf("Errore nell'esecuzione della query: %s\n", PQerrorMessage(conn));
        PQclear(res);
        return; 
    }

    int tuple = PQntuples(res);
    int campi = PQnfields(res);

    stampaLinea(campi);

    printf("|");
    for (int i = 0; i < campi; i++) {
        printf(" %-24s|", PQfname(res, i));
    }
    printf("\n");

    stampaLinea(campi);


    for (int i = 0; i < tuple; i++) {
        printf("|");
        for (int j = 0; j < campi; j++) {
            printf(" %-24s|", PQgetvalue(res, i, j)); 
        }
        printf("\n");
    }

    stampaLinea(campi);

    PQclear(res);
}



int main() {

    int selezionato = selezione();

    char conninfo[250];
    sprintf(conninfo, "user=%s password=%s dbname=%s host=%s port=%d", 
            PG_USER, PG_PASS, PG_DB, PG_HOST, PG_PORT);

    PGconn *conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        printf("Errore di connessione: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        return 1;
    }

    const char *query1 ="SELECT T.Nome, T.Cognome, T.Nazionalita, COUNT(P.Id_Canzone) AS Canzoni_Prodotte "
                        "FROM Tecnico T "
                        "JOIN Produzione P ON T.Nome = P.Nome_Tecnico "
                        "AND T.Cognome = P.Cognome_Tecnico "
                        "AND T.Data_Nascita = P.Data_Nascita_Tecnico "
                        "JOIN Canzone C ON P.Id_Canzone = C.Id "
                        "WHERE C.Genere = $1 "
                        "GROUP BY T.Nome, T.Cognome, T.Nazionalita "
                        "ORDER BY Canzoni_Prodotte DESC;";

    const char *query2 = "SELECT C.Titolo, SUM(CA.pitch) AS Somma_Pitch "
                         "FROM Canzone C "
                         "JOIN Campione CA ON C.Id = CA.Canzone_Id "
                         "GROUP BY C.Titolo "
                         "HAVING SUM(CA.pitch) >= 1; ";

    const char *query3 = "DROP VIEW IF EXISTS Vista_Tutti_Autori CASCADE; "
                         "CREATE VIEW Vista_Tutti_Autori AS "
                         "SELECT Id_Canzone, NomeSingolo AS Nome_Artista FROM CreazioneSingolo "
                         "UNION ALL "
                         "SELECT Id_Canzone, NomeBand AS Nome_Artista FROM CreazioneBand; "

                         "DROP VIEW IF EXISTS Vista_Collaborazioni; "
                         "CREATE VIEW Vista_Collaborazioni AS "
                         "SELECT "
                            "C1.Nome_Artista AS Artista_1, "
                            "C2.Nome_Artista AS Artista_2, "
                            "COUNT(*) AS Numero_Collaborazioni "
                        "FROM Vista_Tutti_Autori C1 "
                        "JOIN Vista_Tutti_Autori C2 ON C1.Id_Canzone = C2.Id_Canzone "
                            "AND C1.Nome_Artista < C2.Nome_Artista "
                        "WHERE "
                        "NOT EXISTS ( "
                        "SELECT * FROM Membro M1 "
                        "JOIN Membro M2 ON M1.Nome_Band = M2.Nome_Band "
                        "WHERE M1.Nome_Singolo = C1.Nome_Artista "
                            "AND M2.Nome_Singolo = C2.Nome_Artista"
                        ") "
                        "AND NOT EXISTS ( "
                        "SELECT * FROM Membro "
                        "WHERE Nome_Singolo = C1.Nome_Artista "
                        "AND Nome_Band = C2.Nome_Artista "
                        ") "
                        "AND NOT EXISTS ( "
                        "SELECT * FROM Membro "
                        "WHERE Nome_Singolo = C2.Nome_Artista "
                            "AND Nome_Band = C1.Nome_Artista "
                        ") "
                        "GROUP BY C1.Nome_Artista, C2.Nome_Artista; "

                        "SELECT Artista_1, Artista_2, Numero_Collaborazioni "
                        "FROM Vista_Collaborazioni "
                        "WHERE Numero_Collaborazioni = (SELECT MAX(Numero_Collaborazioni) FROM Vista_Collaborazioni); ";


    const char *query4 = "SELECT "
                         "Ca.Data_Creazione, "
                         "Ca.Utente, "
                         "C.Titolo AS Titolo_Canzone, "
                         "C.bpm AS BPM_Originale, "
                         "Ca.bpm AS BPM_Campione "
                         "FROM Campione Ca "
                         "JOIN Canzone C ON Ca.Canzone_Id = C.Id "
                         "WHERE Ca.bpm > C.bpm;";

    const char *query5 = "DROP VIEW IF EXISTS Vista_Conteggio_Campioni; "
                         "CREATE VIEW Vista_Conteggio_Campioni AS "
                         "SELECT "
                         "C.Id AS Canzone_Id, "
                         "C.Titolo, "
                         "C.Genere, "
                         "COUNT(Ca.Canzone_Id) AS Totale_Campioni "
                         "FROM Canzone C "
                         "JOIN Campione Ca ON C.Id = Ca.Canzone_Id "
                         "GROUP BY C.Id, C.Titolo, C.Genere; "

                         "SELECT Canzone_Id, Titolo, Genere, Totale_Campioni "
                         "FROM Vista_Conteggio_Campioni "
                         "WHERE Totale_Campioni = (SELECT MAX(Totale_Campioni) FROM Vista_Conteggio_Campioni); ";

    if(selezionato == 1){
        char genere[50];
        printf("Inserisci il genere (es. Rock): ");
        scanf("%s", genere);
        eseguiStampaQueryParametrica(conn, "query1_stmt", query1, genere);
    } 
    else if(selezionato == 2) eseguiStampaQuery(conn, query2);
    else if(selezionato == 3) eseguiStampaQuery(conn, query3);
    else if(selezionato == 4) eseguiStampaQuery(conn, query4);
    else if(selezionato == 5) eseguiStampaQuery(conn, query5);
    else printf("Selezione non valida");

    PQfinish(conn);
}
