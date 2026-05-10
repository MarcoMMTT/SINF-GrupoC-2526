USE GrupoC;

INSERT IGNORE INTO Evento(Nombre_espectaculo, Recinto, Fecha, Estado)
SELECT
    e.Nombre_espectaculo,
    r.nombre,
    DATE_ADD('2026-01-01 20:00:00', INTERVAL n.n HOUR),
    CASE
        WHEN n.n % 20 = 0 THEN 'finalizado'
        WHEN n.n % 7 = 0 THEN 'cerrado'
        ELSE 'abierto'
    END
FROM numeros n
JOIN recintos_demo r
  ON r.id = ((n.n - 1) % (SELECT COUNT(*) FROM recintos_demo)) + 1
JOIN Espectaculo e
  ON e.Nombre_espectaculo = (
      SELECT e2.Nombre_espectaculo
      FROM Espectaculo e2
      ORDER BY RAND()
      LIMIT 1
  )
WHERE n.n <= 1000;

-- =========================
-- EVENTOS
-- Genera 1000 eventos realistas
-- =========================

