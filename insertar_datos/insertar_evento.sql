USE GrupoC;

INSERT IGNORE INTO Evento(
    Nombre_espectaculo,
    Recinto,
    Fecha,
    Estado
)
SELECT
    e.Nombre_espectaculo,
    r.nombre AS Recinto,

    TIMESTAMP(
        DATE_ADD(
            '2026-01-01',
            INTERVAL FLOOR(n.n / 20) DAY
        ),

        CASE
            -- Eventos deportivos
            WHEN e.Tipo = 'deportivo' THEN
                MAKETIME(
                    CASE
                        WHEN n.n % 3 = 0 THEN 17
                        WHEN n.n % 3 = 1 THEN 19
                        ELSE 21
                    END,
                    0,
                    0
                )

            -- Conciertos
            WHEN e.Tipo = 'musical' THEN
                MAKETIME(
                    CASE
                        WHEN n.n % 3 = 0 THEN 20
                        WHEN n.n % 3 = 1 THEN 21
                        ELSE 22
                    END,
                    0,
                    0
                )

            -- Teatro
            WHEN e.Tipo = 'teatral' THEN
                MAKETIME(
                    CASE
                        WHEN n.n % 2 = 0 THEN 18
                        ELSE 20
                    END,
                    30,
                    0
                )

            -- Cultura
            WHEN e.Tipo = 'cultural' THEN
                MAKETIME(
                    CASE
                        WHEN n.n % 3 = 0 THEN 11
                        WHEN n.n % 3 = 1 THEN 17
                        ELSE 19
                    END,
                    0,
                    0
                )

            -- Cine
            WHEN e.Tipo = 'cine' THEN
                MAKETIME(
                    CASE
                        WHEN n.n % 4 = 0 THEN 16
                        WHEN n.n % 4 = 1 THEN 18
                        WHEN n.n % 4 = 2 THEN 20
                        ELSE 22
                    END,
                    0,
                    0
                )

            -- Otros
            ELSE
                MAKETIME(
                    CASE
                        WHEN n.n % 2 = 0 THEN 10
                        ELSE 18
                    END,
                    0,
                    0
                )
        END
    ) AS Fecha,

    CASE
        WHEN n.n % 30 = 0 THEN 'cerrado'
        ELSE 'abierto'
    END AS Estado

FROM numeros n

JOIN (
    SELECT
        Nombre_espectaculo,
        Tipo,
        ROW_NUMBER() OVER (
            ORDER BY Nombre_espectaculo
        ) AS rn,
        COUNT(*) OVER () AS total
    FROM Espectaculo
) e
    ON e.rn = ((n.n - 1) % e.total) + 1

JOIN (
    SELECT
        id,
        nombre,
        tipo_recinto,

        ROW_NUMBER() OVER (
            PARTITION BY tipo_recinto
            ORDER BY id
        ) AS rn_tipo,

        COUNT(*) OVER (
            PARTITION BY tipo_recinto
        ) AS total_tipo

    FROM recintos_demo
) r
ON (
       (e.Tipo = 'deportivo'
            AND r.tipo_recinto IN ('estadio', 'pabellon'))

    OR (e.Tipo = 'musical'
            AND r.tipo_recinto IN (
                'estadio',
                'pabellon',
                'auditorio',
                'feria'
            ))

    OR (e.Tipo = 'teatral'
            AND r.tipo_recinto = 'teatro')

    OR (e.Tipo = 'cultural'
            AND r.tipo_recinto IN (
                'teatro',
                'auditorio',
                'feria'
            ))

    OR (e.Tipo = 'cine'
            AND r.tipo_recinto = 'cine')

    OR (e.Tipo = 'otro'
            AND r.tipo_recinto IN (
                'feria',
                'auditorio',
                'pabellon'
            ))
)

WHERE n.n <= 2000

AND r.rn_tipo =
    ((n.n - 1) % r.total_tipo) + 1;