USE GrupoC;

INSERT IGNORE INTO Evento(Nombre_espectaculo, Recinto, Fecha, Estado)
SELECT
    e.Nombre_espectaculo,
    r.nombre AS Recinto,

    CASE
        -- Fútbol / deporte: tarde-noche, no madrugada
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

        -- Conciertos: normalmente noche
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

        -- Teatro: tarde o noche temprana
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

        -- Cultural: mañana o tarde
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

        -- Otros: congresos, ferias, galas...
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
  ON (
        -- Deportes en estadios o pabellones
        (e.Tipo = 'deportivo' AND r.tipo_recinto IN ('estadio', 'pabellon'))

        -- Música en estadios, pabellones, auditorios o ferias
     OR (e.Tipo = 'musical' AND r.tipo_recinto IN ('estadio', 'pabellon', 'auditorio', 'feria'))

        -- Teatro solo en teatros
     OR (e.Tipo = 'teatral' AND r.tipo_recinto = 'teatro')

        -- Cultural en teatro, auditorio o feria
     OR (e.Tipo = 'cultural' AND r.tipo_recinto IN ('teatro', 'auditorio', 'feria'))

        -- Otros en feria, auditorio o pabellón
     OR (e.Tipo = 'otro' AND r.tipo_recinto IN ('feria', 'auditorio', 'pabellon'))
  )

-- Evita llenar demasiado: ajusta este número
WHERE n.n <= 2000

-- Escoge un recinto compatible, pero no todos
AND r.id = (
    SELECT r2.id
    FROM recintos_demo r2
    WHERE
           (e.Tipo = 'deportivo' AND r2.tipo_recinto IN ('estadio', 'pabellon'))
        OR (e.Tipo = 'musical' AND r2.tipo_recinto IN ('estadio', 'pabellon', 'auditorio', 'feria'))
        OR (e.Tipo = 'teatral' AND r2.tipo_recinto = 'teatro')
        OR (e.Tipo = 'cultural' AND r2.tipo_recinto IN ('teatro', 'auditorio', 'feria'))
        OR (e.Tipo = 'otro' AND r2.tipo_recinto IN ('feria', 'auditorio', 'pabellon'))
    ORDER BY RAND()
    LIMIT 1
);