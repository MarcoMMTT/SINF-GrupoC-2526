USE GrupoC;

INSERT IGNORE INTO Oferta(Precio, Recinto, Fecha, Nombre_grada, Tipo)
SELECT
    CASE u.Tipo
        WHEN 'Adulto' THEN 40 + gnum.n * 5 + (DAY(g.Fecha) % 20) + (CHAR_LENGTH(g.Recinto) % 15)
        WHEN 'Jubilado' THEN 30 + gnum.n * 3
        WHEN 'Infantil' THEN 25 + gnum.n * 2
        WHEN 'Parado' THEN 20 + gnum.n * 2
        WHEN 'Bebé' THEN 5
    END AS Precio,
    g.Recinto,
    g.Fecha,
    g.Nombre_Grada,
    u.Tipo
FROM Grada g
JOIN numeros gnum
  ON g.Nombre_Grada = CONCAT('Grada ', gnum.n)
CROSS JOIN Usuario u
WHERE gnum.n <= 5;
-- =========================
-- OFERTA / PRECIOS
-- Precio por evento, grada y tipo de usuario
-- =========================
