-- =========================
-- VENTAS
-- Inserta 20000 ventas simuladas
-- El UNIQUE evita vender dos veces la misma entrada
-- =========================

INSERT IGNORE INTO Vendida(
    Nombre_grada,
    Tipo,
    Fecha,
    Recinto,
    Nombre_espectaculo,
    DNI,
    Localidad
)
SELECT
    en.Nombre_grada,
    CASE
        WHEN n.n % 5 = 0 THEN 'Jubilado'
        WHEN n.n % 5 = 1 THEN 'Adulto'
        WHEN n.n % 5 = 2 THEN 'Infantil'
        WHEN n.n % 5 = 3 THEN 'Parado'
        ELSE 'Bebé'
    END AS Tipo,
    en.Fecha,
    en.Recinto,
    ev.Nombre_espectaculo,
    CONCAT('DNI', LPAD(((n.n - 1) % 5000) + 1, 8, '0')),
    en.Localidad
FROM Entrada en
JOIN Evento ev
  ON ev.Recinto = en.Recinto
 AND ev.Fecha = en.Fecha
JOIN numeros n
WHERE en.Estado = 'libre'
LIMIT 20000;