USE GrupoC;

-- =========================
-- VENTAS
-- Inserta 20000 ventas simuladas
-- El UNIQUE evita vender dos veces la misma entrada
-- =========================

-- ventas.sql
-- Vendida depende de Entrada, Cliente, Usuario y Grada

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
        WHEN n.n % 5 = 0 THEN 'Jubilado'
        WHEN n.n % 5 = 1 THEN 'Adulto'
        WHEN n.n % 5 = 2 THEN 'Infantil'
        WHEN n.n % 5 = 3 THEN 'Parado'
        ELSE 'Bebé'
    END,
    e.Fecha,
    e.Recinto,
    CONCAT('DNI', LPAD(((n.n - 1) % 5000) + 1, 8, '0')),
    e.Localidad
FROM Entrada e
JOIN numeros n
WHERE e.Estado = 'libre'
LIMIT 20000;

UPDATE Entrada e
JOIN Vendida v
  ON v.Fecha = e.Fecha
 AND v.Recinto = e.Recinto
 AND v.Nombre_grada = e.Nombre_grada
 AND v.Localidad = e.Localidad
SET e.Estado = 'reservado';