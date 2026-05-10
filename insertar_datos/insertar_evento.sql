USE GrupoC;

INSERT IGNORE INTO Evento(Nombre_espectaculo, Recinto, Fecha, Estado)
SELECT
    e.Nombre_espectaculo,
    r.nombre AS Recinto,

    CASE
        WHEN e.Tipo = 'deportivo' THEN
            TIMESTAMP(
                DATE_ADD('2026-01-01', INTERVAL FLOOR(n.n / 20) DAY),
                MAKETIME(
                    CASE
                        WHEN n.n % 3 = 0 THEN 17
                        WHEN n.n % 3 = 1 THEN 19
                        ELSE 21
                    END,
                    0,
                    0
                )
            )

        WHEN e.Tipo = 'musical' THEN
            TIMESTAMP(
                DATE_ADD('2026-01-01', INTERVAL FLOOR(n.n / 20) DAY),
                MAKETIME(
                    CASE
                        WHEN n.n % 3 = 0 THEN 20
                        WHEN n.n % 3 = 1 THEN 21
                        ELSE 22
                    END,
                    0,
                    0
                )
            )

        WHEN e.Tipo = 'teatral' THEN
            TIMESTAMP(
                DATE_ADD('2026-01-01', INTERVAL FLOOR(n.n / 20) DAY),
                MAKETIME(
                    CASE
                        WHEN n.n % 2 = 0 THEN 18
                        ELSE 20
                    END,
                    30,
                    0
                )
            )

        WHEN e.Tipo = 'cultural' THEN
            TIMESTAMP(
                DATE_ADD('2026-01-01', INTERVAL FLOOR(n.n / 20) DAY),
                MAKETIME(
                    CASE
                        WHEN n.n % 3 = 0 THEN 11
                        WHEN n.n % 3 = 1 THEN 17
                        ELSE 19
                    END,
                    0,
                    0
                )
            )

        WHEN e.Tipo = 'cine' THEN
            TIMESTAMP(
                DATE_ADD('2026-01-01', INTERVAL FLOOR(n.n / 20) DAY),
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
            )

        ELSE
            TIMESTAMP(
                DATE_ADD('2026-01-01', INTERVAL FLOOR(n.n / 20) DAY),
                MAKETIME(
                    CASE
                        WHEN n.n % 2 = 0 THEN 10
                        ELSE 18
                    END,
                    0,
                    0
                )
            )
    END AS Fecha,

    CASE
        WHEN n.n % 30 = 0 THEN 'cerrado'
        ELSE 'abierto'
    END AS Estado

FROM numeros n
JOIN Espectaculo e
  ON e.Nombre_espectaculo = (
      SELECT e2.Nombre_espectaculo
      FROM Espectaculo e2
      ORDER BY RAND()
      LIMIT 1
  )
JOIN recintos_demo r
  ON r.id = (
    SELECT r2.id
    FROM recintos_demo r2
    WHERE
           (e.Tipo = 'deportivo' AND r2.tipo_recinto IN ('estadio', 'pabellon'))
        OR (e.Tipo = 'musical'   AND r2.tipo_recinto IN ('estadio', 'pabellon', 'auditorio', 'feria'))
        OR (e.Tipo = 'teatral'   AND r2.tipo_recinto = 'teatro')
        OR (e.Tipo = 'cultural'  AND r2.tipo_recinto IN ('teatro', 'auditorio', 'feria'))
        OR (e.Tipo = 'cine'      AND r2.tipo_recinto = 'cine')
        OR (e.Tipo = 'otro'      AND r2.tipo_recinto IN ('feria', 'auditorio', 'pabellon'))
    ORDER BY RAND()
    LIMIT 1
  )
WHERE n.n <= 2000;