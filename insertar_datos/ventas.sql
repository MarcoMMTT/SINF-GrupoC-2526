USE GrupoC;

CREATE INDEX idx_entrada_estado
ON Entrada(Estado);

CREATE INDEX idx_entrada_estado_pk
ON Entrada(Estado, Fecha, Recinto, Nombre_grada, Localidad);

CREATE INDEX idx_vendida_entrada
ON Vendida(Fecha, Recinto, Nombre_grada, Localidad);

INSERT IGNORE INTO Vendida(
    Nombre_grada,
    Tipo,
    Fecha,
    Recinto,
    DNI,
    Localidad
)
SELECT
    x.Nombre_grada,
    CASE
        WHEN x.r_tipo < 60 THEN 'Adulto'
        WHEN x.r_tipo < 80 THEN 'Infantil'
        WHEN x.r_tipo < 92 THEN 'Jubilado'
        WHEN x.r_tipo < 99 THEN 'Parado'
        ELSE 'Bebé'
    END AS Tipo,
    x.Fecha,
    x.Recinto,
    CONCAT('DNI', LPAD(x.cliente_id, 8, '0')),
    x.Localidad
FROM (
    SELECT
        e.*,
        FLOOR(RAND() * 100) AS r_tipo,
        FLOOR(1 + RAND() * 5000) AS cliente_id
    FROM Entrada e
    WHERE e.Estado = 'libre'
    ORDER BY e.Fecha, e.Recinto, e.Nombre_grada, e.Localidad
    LIMIT 100000
) x;

UPDATE Entrada e
JOIN Vendida v
  ON v.Fecha = e.Fecha
 AND v.Recinto = e.Recinto
 AND v.Nombre_grada = e.Nombre_grada
 AND v.Localidad = e.Localidad
SET e.Estado = 'reservado'
WHERE e.Estado = 'libre';