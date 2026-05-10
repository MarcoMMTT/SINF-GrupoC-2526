USE GrupoC;

DROP TEMPORARY TABLE IF EXISTS ventas_nuevas;

CREATE TEMPORARY TABLE ventas_nuevas AS
SELECT
    e.Nombre_grada,
    CASE
        WHEN FLOOR(RAND() * 100) < 60 THEN 'Adulto'
        WHEN FLOOR(RAND() * 100) < 80 THEN 'Infantil'
        WHEN FLOOR(RAND() * 100) < 92 THEN 'Jubilado'
        WHEN FLOOR(RAND() * 100) < 99 THEN 'Parado'
        ELSE 'Bebé'
    END AS Tipo,
    e.Fecha,
    e.Recinto,
    CONCAT('DNI', LPAD(FLOOR(1 + RAND() * 5000), 8, '0')) AS DNI,
    e.Localidad
FROM Entrada e
WHERE e.Estado = 'libre'
LIMIT 100000;

INSERT IGNORE INTO Vendida(
    Nombre_grada,
    Tipo,
    Fecha,
    Recinto,
    DNI,
    Localidad
)
SELECT
    Nombre_grada,
    Tipo,
    Fecha,
    Recinto,
    DNI,
    Localidad
FROM ventas_nuevas;

UPDATE Entrada e
JOIN ventas_nuevas v
  ON v.Fecha = e.Fecha
 AND v.Recinto = e.Recinto
 AND v.Nombre_grada = e.Nombre_grada
 AND v.Localidad = e.Localidad
SET e.Estado = 'reservado'
WHERE e.Estado = 'libre';