USE GrupoC;

INSERT IGNORE INTO Vendida(
    Nombre_grada,
    Tipo,
    Fecha,
    Recinto,
    DNI,
    Localidad
)
SELECT
    e.Nombre_grada,
    CASE
        WHEN rn % 5 = 0 THEN 'Jubilado'
        WHEN rn % 5 = 1 THEN 'Adulto'
        WHEN rn % 5 = 2 THEN 'Infantil'
        WHEN rn % 5 = 3 THEN 'Parado'
        ELSE 'Bebé'
    END AS Tipo,
    e.Fecha,
    e.Recinto,
    CONCAT('DNI', LPAD(((rn - 1) % 5000) + 1, 8, '0')),
    e.Localidad
FROM (
    SELECT
        e.*,
        ROW_NUMBER() OVER (
            ORDER BY e.Fecha, e.Recinto, e.Nombre_grada, e.Localidad
        ) AS rn
    FROM Entrada e
    WHERE e.Estado = 'libre'
) e
LIMIT 100000;

UPDATE Entrada e
JOIN Vendida v
  ON v.Fecha = e.Fecha
 AND v.Recinto = e.Recinto
 AND v.Nombre_grada = e.Nombre_grada
 AND v.Localidad = e.Localidad
SET e.Estado = 'reservado';