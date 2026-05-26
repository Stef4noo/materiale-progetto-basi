CREATE VIEW collab_singolo_singolo AS
SELECT
    cs1.nome_artista AS artista_1,
    cs2.nome_artista AS artista_2,
    COUNT(*) AS numero_collaborazioni
FROM
    creazione_singolo cs1
    JOIN creazione_singolo cs2
    ON cs1.canzone = cs2.canzone AND cs1.autore < cs2.autore
    AND cs1.autore NOT IN (
        SELECT nome_artista
        FROM
            creazione_band cb
            JOIN membri me
            ON cb.nome_band = me.nome_band
        WHERE
            cb.canzone = cs1.canzone -- è possibile?
        )
    AND cs2.autore NOT IN (
        SELECT nome_artista
        FROM
            creazione_band cb
            JOIN membri me
            ON cb.nome_band = me.nome_band
        WHERE
            cb.canzone = cs1.canzone -- è possibile?
        )
GROUP BY
  cs1.nome_artista,
  cs2.nome_artista;

CREATE VIEW collab_band_band AS
SELECT
    cb1.nome_band as artista_1,
    cb2.nome_band as artista_2,
    COUNT(*) AS numero_collaborazioni
FROM
    creazione_band cb1
    JOIN creazione_band cb2
    ON cb1.canzone = cb2.canzone AND cb1.nome_band < cb2.nome_band
GROUP BY
    cb1.nome_band,
    cb2.nome_band;

CREATE VIEW collab_band_singolo AS
SELECT
    cb1.nome_band as artista_1,
    cs1.nome_artista as artista_1,
    COUNT(*) AS numero_collaborazioni
FROM
    creazione_band cb1
    JOIN creazione_singolo cs1
    ON cs1.canzone = cb1.canzone AND cs1.autore NOT IN (
        SELECT nome_artista
        FROM
            creazione_band cb
            JOIN membri me
            ON cb.nome_band = me.nome_band
        WHERE
            cb.canzone = cs1.canzone -- è possibile?
        )
GROUP BY
    cb1.nome_band,
    cs1.nome_artista;

CREATE VIEW vista_collaborazioni AS
SELECT *
FROM collab_singolo_singolo
UNION
SELECT *
FROM collab_band_band
UNION
SELECT *
FROM collab_band_singolo;

SELECT
    artista_1,
    artista_2,
    numero_collaborazioni
FROM
    vista_collaborazioni
WHERE numero_collaborazioni = (
    SELECT MAX(numero_collaborazioni)
    FROM vista_collaborazioni
);
